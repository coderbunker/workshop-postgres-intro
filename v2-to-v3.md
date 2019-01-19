# How to go from v2 to v3

* We want to add users
* Store when record were created
* We want to add automatic slug creation

# Solution

* Add a title and procedure for auto-generated slug using trigger
* Add created_at/updated_at

* Comments is a problem because:
  * post_id refers to an inheritance parent table id, that won't work and questions and answers won't be referenced
  * if comments are only texts we can use arrays of text
  * we have to separate the 2 tables
