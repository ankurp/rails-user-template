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

### Features
The user model has the following functionality built out
1. New Signup
2. Login
3. Logout
4. Edit Password
5. Reset Password

## Screenshots

![Screenshot 2024-01-02 at 7 28 31 PM](https://github.com/ankurp/rails-user-template/assets/498669/74d867ed-4c73-417b-8dd9-8b32db29b581)
![Screenshot 2024-01-02 at 7 29 02 PM](https://github.com/ankurp/rails-user-template/assets/498669/fb3d69bf-73df-49cf-bd83-3249810a0ac1)
![Screenshot 2024-01-02 at 7 29 06 PM](https://github.com/ankurp/rails-user-template/assets/498669/c3550bde-1d8b-47ff-891a-49d1443b0c8d)

