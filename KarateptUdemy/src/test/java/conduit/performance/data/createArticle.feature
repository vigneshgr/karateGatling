Feature: Test the articles

Background: Define URL
    * url apiUrl
    * def articleRequestBody = read ('classpath:conduit/json/newArticle.json')
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * set articleRequestBody.article.title = dataGenerator.getRandomUserName()
    * set articleRequestBody.article.description =  dataGenerator.getRandomUserName()
    * set articleRequestBody.article.body =  dataGenerator.getRandomUserName()

    * def sleep = function(ms){ java.lang.Thread.sleep(ms) }
# or function(ms){ } for a no-op !
    * def pause = karate.get('__gatling.pause', sleep)
 
    Scenario: article creation and deletion
       
        Given path 'articles'
        And request articleRequestBody
        When method Post
        Then status 200
        * def articleId = response.article.slug

        #user think time
        * pause(5000)

        Given path 'articles',articleId
        When method Delete
        Then status 200
