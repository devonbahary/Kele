module RoadmapsCheckpoints
  
  # get_roadmap(...)
  # => retrieves a 'roadmaps' object with its associated sections and checkpoints from a roadmap_id
  def get_roadmap(roadmap_id)
    # set up a GET request to 'https://www.bloc.io/api/v1/roadmaps/roadmap_id'
    headers = {
      :content_type   => 'application/json',
      :authorization  => @user_auth_token
    } 
    options = { headers: headers, id: roadmap_id }
    
    # the GET request
    path = @bloc_api_url + "/roadmaps/#{roadmap_id}"
    http_party_response = self.class.get path, options
    
    # parse the JSON request to a Ruby hash and return it
    JSON.parse(http_party_response.body)
  end
  
  # get_checkpoint(...)
  # => retrieves a 'checkpoint' object with its associated body and assignment from a checkpoint_id
  def get_checkpoint(checkpoint_id)
    # set up a GET request to 'https://www.bloc.io/api/v1/checkpoints/checkpoint_id'
    headers = {
      :content_type   => 'application/json',
      :authorization  => @user_auth_token
    }
    options = { headers: headers, id: checkpoint_id }
    
    # the GET request
    path = @bloc_api_url + "/checkpoints/#{checkpoint_id}"
    http_party_response = self.class.get path, options
    
    # parse the JSON request to a Ruby hash and return it
    JSON.parse(http_party_response.body)
  end
  
end