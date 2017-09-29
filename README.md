# Kele   
*A Ruby gem for easy access to the [Bloc API](http://docs.blocapi.apiary.io/#)*.


**Create a new instance of the Kele client with `Kele.new(email, password)`**

`kele_client = Kele.new("devonbahary@bloc.io", "password")`   
- An error will be raised if there were issues with user credentials.

**With a credentialed `Kele` instance, get current user information with `#get_me`**

`user_object = kele_client.get_me`   
`user_object["first_name"] # => "Devon"`