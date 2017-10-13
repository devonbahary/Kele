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
    # parsed_hash.reject! {|i| i["booked"] } # remove booked time slots
    parsed_hash.map {|i| i } # convert to array + return
  end
  
  # get_messages(...*)
  # => retrieves the first page of message threads for the current user or a specified page
  def get_messages(page = 1) 
    # set up a GET request to 'https://www.bloc.io/api/v1/message_threads'
    headers = {
      :content_type   => 'application/json',
      :authorization  => @user_auth_token
    }
    options = { headers: headers, page: page}
  
    # the GET request
    path = @bloc_api_url + "/message_threads"
    http_party_response = self.class.get path, options
    
    # parse the JSON responses to native Ruby objects, return messages in the context of pages
    # =>  "Either return the first page of messages or a specified page"
    message_list = JSON.parse(http_party_response.body)["items"]
  end

  # create_message(...)
  # => creates a new message on an existing message thread, or creates a new message thread with new
  # => message if conversation thread argument is omitted
  def create_message(sender_email, recipient_id, subject, message, thread_token = nil)
    # set up a POST request to 'https://www.bloc.io/api/v1/messages'
    headers = {
      :content_type   => 'application/json',
      :authorization  => @user_auth_token
    }
    body = {
      sender: sender_email,
      recipient_id: recipient_id,
      token: thread_token,
      subject: subject,
      "stripped-text": message
    }
    options = { headers: headers, body: body.to_json }
    
    # the POST request
    path = @bloc_api_url + '/messages'
    http_party_response = self.class.post path, options
  end

  # create_submission(...)
  # => creates a new Bloc checkpoint submission
  def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment)
    # set up a POST request to 'https://www.bloc.io/api/v1/checkpoint_submissions'
    headers = {
      :content_type   => 'application/json',
      :authorization  => @user_auth_token
    }
    
    enrollment_id = get_me["current_enrollment"]["id"]
    
    body = {
      "assignment_branch": assignment_branch,
      "assignment_commit_link": assignment_commit_link,
      "checkpoint_id": checkpoint_id,
      comment: comment,
      enrollment_id: enrollment_id
    }
    
    options = { headers: headers, body: body.to_json }
    
    # the POST request
    path = @bloc_api_url + '/checkpoint_submissions'
    http_party_response = self.class.post path, options
  end

end
