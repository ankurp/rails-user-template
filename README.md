# Rails User Template

This is a rails template that generate a barebones rails new application with User model and authentication system. All of the code for user mode, controller and view templates is copied from the template giving developer full control over the authentication logic without any magic or surprises. This is a simple authentication system that can be extended if you do not want to use devise or other authentication gems like clearance.

## Getting Started

This project is a Rails template, so you pass it in as an option when creating a new app and it will generate a new rails application with user model and authentication logic that you can view and override as needed.

### Requirements

This template make use of `has_secure_password` available in Rails 7.1 to create a `User` model, so you will needed minimum rails version `7.1` to create a new rails app.

```
rails new AwesomeApp -m https://raw.githubusercontent.com/ankurp/rails-user-template/main/template.rb
```

You can also fork the repo and make changes and point to your own template or download the template and run it locally as well as such

```
rails new AwesomeApp -m ./rails-user-template/template.rb
```
