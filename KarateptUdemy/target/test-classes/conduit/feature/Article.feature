Feature: Test the articles

Background: Define URL
    * url apiUrl
    * def articleRequestBody = read ('classpath:conduit/json/newArticle.json')
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * print "viki debug"
    * print dataGenerator.getRandomArticleValues().title
    * print dataGenerator.getRandomArticleValues().description
    #* set articleRequestBody.article.title = dataGenerator.getRandomArticleValues().title
    #* set articleRequestBody.article.description =  dataGenerator.getRandomArticleValues().description
    #* set articleRequestBody.article.body =  dataGenerator.getRandomArticleValues().body
    * set articleRequestBody.article.title = dataGenerator.getRandomUserName()
    * set articleRequestBody.article.description =  dataGenerator.getRandomUserName()
    * set articleRequestBody.article.body =  dataGenerator.getRandomUserName()
    
    # Given path 'users/login'
    #     And request {"user": {"email": "karate1@gmai.com","password": "karate123"}}
    #     When method Post 
    #     Then status 200
    #     * def token = response.user.token
      #  * def tokenResponse = callonce read('classpath:helpers/CreateToken.feature') --removing since added to config
        #{"email":"karate1@gmai.com","password":"karate123"}
        #* def token = tokenResponse.authToken --removing since added to config

    Scenario: article creation
        
       # Given header Authorization =  'Token ' + token --Added to the config
        Given path 'articles'
        And request articleRequestBody
        When method Post
        Then status 200
        And match response.article.description == articleRequestBody.article.description
        

    Scenario: Create amd delete article
        Given params { limit: 10, offset: 0 }
        Given path 'articles'
        When method Get
        Then status 200
        And match response.articles[0].title == '#string'
        * def articleId = response.articles[0].slug
        

       # Given header Authorization =  'Token ' + token --Added to the config
        Given path 'articles/' + articleId
        When method Delete
        Then status 200

        Given params { limit: 10, offset: 0 }
        Given path 'articles'
        When method Get
        Then status 200
        And match response.articles[0].title == '#string'