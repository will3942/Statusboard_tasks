Tasks for Statusboard
========

Description
--------
A ruby application with an admin panel to create tasks which are then formatted into a table to be displayed in Panic's Statusboard app (http://panic.com/statusboard/)

Specifications
--------

Requires PostgreSQL with a database named ``` statusboard-tasks ```. User who is running the ruby application should have correct permissions to access the database (otherwise adjust the postgres URL in app.rb and Rakefile so it looks like this: postgres://USERNAME:PASSWORD@localhost/statusboard-tasks)

Installation
--------
1.  Install the required dependencies ``` bundle install ```
2.  Create required tables ``` rake migrate ```
3.  Create an admin user (change username and password) ``` rake 'create_admin[USERNAME, PASSWORD]' ```
4.  Run app, ``` bundle exec shotgun -O config.ru ```
5.  Navigate to http://localhost:9393/admin
6.  Login with your username and password
7.  Create a project and tasks, get the URL for the project e.g http://localhost:9393/1/tasks
8.  Make sure that URL is accessible from the iPad. If not run the application on a different IP with the following command ``` bundle exec shotgun -O config.ru -oIPADDRESS```
9.  Then replace localhost in the URL so it looks like http://IPADDRESS:9393/1/tasks, if a domain resolves to that IP then you can replace IPADDRESS with your domain name in the URL.
10.  Open Panic's statusboard on your iPad and add a table element, fill out the URL with the one you found earlier.
11.  Done and enjoy!

blah blah
--------
This was a quick hack for a simple tasks list on Statusboard. Feel free to fork the project, create a proper admin panel if you have frontend skills and time! Or add cool new features :-)  
Also this will work with multiple task lists, so statusboard can display multiple lists off this one Ruby application. Just adjust the number in the URL to reflect the ID of the project.

Contact
--------
Feel free to contact me @Will3942 or will@will3942.com  
  
  ~Will Evans