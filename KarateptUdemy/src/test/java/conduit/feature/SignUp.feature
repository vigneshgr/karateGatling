
Feature:
Signup new user

    Background: Preconditions
    *  def randomDataGenerator = Java.type('helpers.DataGenerator')
    * def randomSignupEmail = randomDataGenerator.getRandomEmail() 
    * def randomSignupUserName = randomDataGenerator.getRandomUserName() 
    
    Given url apiUrl

    Scenario: New user signup
    #example for embedded expression
    #Given def userData = {"signupEmail":"vkarate9009@gmail.com","signupUserName":"vkarate9009"}
    * def randomSignupEmail = randomDataGenerator.getRandomEmail() 
    * def randomSignupUserName = randomDataGenerator.getRandomUserName() 

    Given path 'users'
    And request 
    """
        {
            "user":
                {"email":#(randomSignupEmail),
                "password":"karate123$",
                "username":"#(randomSignupUserName)"
                }
        }
    """
    
    When method Post
    Then status 200
    
    Scenario: Negative test for New user signup by using a email Id already taken
    #example for embedded expression
    #Given def userData = {"signupEmail":"vkarate9009@gmail.com","signupUserName":"vkarate9009"}
    #* def randomSignupEmail = randomDataGenerator.getRandomEmail() 
    #* def randomSignupUserName = randomDataGenerator.getRandomUserName() 

    Given path 'users'
    And request 
    """
        {
            "user":
                {"email":"hector66@test.com",
                "password":"karate123$",
                "username":"#(randomSignupUserName)"
                }
        }
    """
    
    When method Post
    Then status 422

        Scenario Outline: Negative test for New user signup by using data generator
    #example for embedded expression
    #Given def userData = {"signupEmail":"vkarate9009@gmail.com","signupUserName":"vkarate9009"}


    Given path 'users'
    And request 
    """
        {
            "user":
                {"email":"<email>",
                "password":"<password>",
                "username":"<username>"
                }
        }
    """
    
    When method Post
    Then status 422
    And match response == <errorResponse>


    Examples:
    |email            | password | username               | errorResponse                                          |
    |hector66@test.com|karate123$| #(randomSignupUserName)|{"errors":{"email":["has already been taken"]}}|
    |#(randomSignupEmail)|karate123$| kermit.swaniawski|{"errors":{"username":["has already been taken"]}}|