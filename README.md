# Kele   
*A Ruby gem for easy access to the [Bloc API](http://docs.blocapi.apiary.io/#)*.


**Create a new instance of the Kele client with `Kele.new(email, password)`**

`kele_client = Kele.new("devonbahary@bloc.io", "password")`   
- An error will be raised if there were issues with user credentials.

**With a credentialed `Kele` instance, get current user information with `#get_me`**

`user_object = kele_client.get_me`   
`user_object["first_name"] # => "Devon"`

**Retrieve an array representing mentor time slot availability with `#get_mentor_availability(mentor_id)`**

`mentor_id = user_object["current_enrollment"]["mentor_id"]`   
`kele_client.get_mentor_availability(mentor_id) # => Array`