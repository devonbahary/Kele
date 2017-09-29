require 'httparty'
require 'roadmap/roadmapscheckpoints'

class Kele
  include HTTParty
  include RoadmapsCheckpoints
  
  # initialize
  def initialize(email, password)
    @email = email
    @password = password
    @bloc_api_url = 'https://www.bloc.io/api/v1'
    
    # set up a POST request to 'https://www.bloc.io/api/v1/sessions' for a @user_auth_token
    body = {
      email: @email,
      password: @password
    }
    headers = {
      :content_type => 'application/json'
    }
    options = { headers: headers, body: body.to_json }
    
    # the POST request
    path = @bloc_api_url + '/sessions'
    http_party_response = self.class.post path, options
    
    # collect the user_auth_token
    @user_auth_token = http_party_response.parsed_response["auth_token"]
    # raise an error if @user_auth_token == nil
    raise "Invalid credentials" if !@user_auth_token
  end
  
  
  # get_me
  # => retrieves the current user from the Bloc API
  def get_me
    # set up a GET request to 'https://www.bloc.io/api/v1/users/me' for current user data
    headers = {
      :content_type   => 'application/json',
      :authorization  => @user_auth_token
    }
    options = { headers: headers }
    
    # the GET request
    path = @bloc_api_url + '/users/me'
    http_party_response = self.class.get path, options
    
    # parse the JSON response to a Ruby hash and return it
    JSON.parse(http_party_response.body)
  end
  
  # get_mentor_availability(...)
  # => retrieves an array of the mentor's available time slots for the given mentor_id
  def get_mentor_availability(mentor_id)
    # set up a GET request to 'https://www.bloc.io/api/v1/mentors/mentor_id/student_availability'
    headers = {
      :content_type   => 'application/json',
      :authorization  => @user_auth_token
    }
    options = { headers: headers, id: mentor_id }
    
    # the GET request
    path = @bloc_api_url + "/mentors/#{mentor_id}/student_availability"
    http_party_response = self.class.get path, options
    
    # parse the JSON response to a Ruby hash and convert it to useful array
    parsed_hash = JSON.parse(http_party_response.body)
    parsed_hash.reject! {|i| i["booked"] } # remove booked time slots
    parsed_hash.map {|i| [i["week_day"], i["starts_at"], i["ends_at"]] } # convert to array + return
  end
  
end
