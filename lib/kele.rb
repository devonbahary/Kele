require 'httparty'

class Kele
  include HTTParty
  
  def initialize(email, password)
    @email = email
    @password = password
    @bloc_api_url = 'https://www.bloc.io/api/v1'
    
    # set up a POST request to 'https://www.bloc.io/api/v1/sessions' for a @user_auth_token
    values = {
      email: @email,
      password: @password
    }
    
    headers = {
      :content_type => 'application/json'
    }
    
    options = { body: values.to_json, headers: headers }
    
    # the POST request
    path = @bloc_api_url + '/sessions'
    http_party_response = self.class.post path, options
    
    # collect the user_auth_token
    @user_auth_token = http_party_response.parsed_response["auth_token"]
    # raise an error if @user_auth_token == nil
    raise "Invalid credentials" if !@user_auth_token
  end
  
end