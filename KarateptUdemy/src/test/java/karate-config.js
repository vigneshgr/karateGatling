function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    apiUrl: 'https://conduit.productionready.io/api/'
  }
  
  //option for the user to provide two different profiles based on the environment
  if (env == 'dev') {
    config.userEmail = 'karate1@gmai.com'
    config.userPassword = 'karate123'
  } else if (env == 'qa') {
    config.userEmail = 'karate2@gmai.com'
    config.userPassword = 'karate456'
  }

  //provision to setup a global access token that can be utilized by all the features. Passing config object that houses the email creds
  var accessToken = karate.callSingle('classpath:helpers/CreateToken.feature', config).authToken
  karate.configure('headers',{Authorization:  'Token ' + accessToken})

  return config;
}