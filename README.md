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

**Retrieve a roadmap object containing its associated sections and checkpoints with `#get_roadmap(roadmap_id)`**

`roadmap_id = 31 # Rails roadmap`   
`kele_client.get_roadmap(roadmap_id) # => Hash`

**Retrieve a checkpoint object containing its associated body and assignment with `#get_checkpoint(checkpoint_id)`**

`checkpoint_id = 1938`   
`kele_client.get_checkpoint(checkpoint_id) # => Hash`


**Retrieve the first page of message threads or a specified page with `#get_messages(page_num)`**

`page_num = 2`   
`kele_client.get_messages(page_num) # => hash containing message threads from page 2`   
`kele_client.get_messages           # => hash containing message threads from page 1 (default)`


**Send a message to another Bloc user with `#create_message(your_email, recipient_bloc_id, subject, message, message_thread*)`**

`email = 'devonbahary@bloc.io`   
`recipient_id = 1437294`   
`subject = 'Hey Mark!'`   
`message_thread = '7991495e-8d73-430c-99b8-46bc7f7df7e3'`

`kele_client.create_message(email, recipient_id, subject, 'How's it going?')`   
`# => creates a new conversation thread`   
`kele_client.create_message(email, recipient_id, subject, 'This is my reply to an existing thread!', message_thread)`   
`# => a reply to an existing thread`

** Create a checkpoint submission with `#create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment)`**

`checkpoint_id = 1601`   
`assignment_branch = '11-static-pages'`   
`assignment_commit_link = 'https://https://github.com/devonbahary/bloccit/tree/11-static-pages'`   
`comment = 'i submit now dis'`

`kele_client.create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment)`