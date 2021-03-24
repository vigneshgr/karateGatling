
Feature: Test for the home page

Background: Define URL
    Given url apiUrl

    #@Debug
    Scenario: Get all tags and simple assetion practice
        Given path 'tags'
        When method Get 
        Then status 200
        And match response.tags !contains ['cars','baby']
        And match response.tags contains 'HITLER'
        And match response.tags contains any ['test1','dragons']
        And match response.tags == '#array'
        And match each response.tags == '#string'

    Scenario: Get all articles in the page and complex assertions practice
        * def timeValidator = read ('classpath:helpers/timeValidator.js')

        Given params { limit: 10, offset: 0 }
        Given path 'articles'
        When method Get
        Then status 200
        # verify array count
        And match response.articles == '#[10]'
        And match response.articlesCount == 500
        And match response.articlesCount != 100
        #multi line assert
        And match response == { "articles": "#array","articlesCount": 500}
        #partial field assert
        And match response.articles[0].createdAt contains '2021'
        #field assert if any one of the array elements have 2021
        #And match response.articles[*].createdAt contains '2021'
        #search for a tag across the JSON
        And match response..bio contains null
        And match each response..following == false
        And match each response..following == '#boolean'
        # double hash validation allows the field to have null values or even if the field is not present
        And match each response..bio == '##string'
        #schema validation
        And match each response.articles ==
        """
            {
                "title": "#string",
                "slug": "#string",
                "body": "#string",
                "createdAt": "#? timeValidator(_)",
                "updatedAt": "#? timeValidator(_)",
                "tagList": "##array",
                "description": "#string",
                "author": {
                    "username": "#string",
                    "bio": "##string",
                    "image": "#string",
                    "following": '#boolean'
                },
                "favorited": '#boolean',
                "favoritesCount": '#number'
        }
        """

Scenario: Conditional logic feature
    

        Given params { limit: 10, offset: 0 }
        Given path 'articles'
        When method Get
        Then status 200
        * def favoritesCount = response.articles[0].favoritesCount
        * def article = response.articles[0]
        
        # a simple if statement logic
        #* if (favoritesCount == 0) karate.call('classpath:helpers/AddLikes.feature',article)
        # a if else flow 
        # if likes = 0, call function and record the linkes count of 1 into the result variable
        # else get the likescount of 1 or 2 or 3 and save that to result variable. need to change the response validation to compare against result 
        * def result = favoritesCount == 0 ? karate.call('classpath:helpers/AddLikes.feature',article).likesCount : favoritesCount

        Given params { limit: 10, offset: 0 }
        Given path 'articles'
        When method Get
        Then status 200
        And match response.articles[0].favoritesCount == result

#retry same scenario more than one time. useful when system is unstable
    Scenario: Retry call
    # time in ms; condition should be always placed before the method
        * configure retry = { count: 10, interval: 5000 }

        Given params { limit: 10, offset: 0 }
        Given path 'articles'
        And retry until response.articles[0].favoritesCount == 1
        When method Get
        Then status 200

#this is to have the service sleep for some time before trying again. the js std function is available in karate gh repo
#retry is best when we have a condition if not sleep should be used
    Scenario: Sleep call
        * def sleep = function(pause){ java.lang.Thread.sleep(pause) }

        Given params { limit: 10, offset: 0 }
        Given path 'articles'
        When method Get
        * eval sleep(5000)
        Then status 200

#Data Type transformations

    Scenario: Number to string
    * def foo = 10
    * def json = {"bar": #(foo+'')}
    * match json == {"bar": '10'}

    Scenario: String to number
    * def foo = '10'
    * def json = {"bar": #(foo*1)}
    #parse int to convert from string to number and the operator ~~ is used to modify a float to int
    * def json2 = {"bar": #(~~parseInt(foo))}
    * match json == {"bar": 10}
    * match json2 == {"bar": 10}