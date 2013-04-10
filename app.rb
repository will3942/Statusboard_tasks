require 'sinatra'
require 'data_mapper'
require 'bcrypt'
require 'securerandom'

class Admin
		include DataMapper::Resource

		attr_accessor :password

		property :id, Serial
		property :username, String, :required => true, :unique => true
		property :password_hash, Text
		property :password_salt, Text
		property :token, String

		after :create do
		self.token = SecureRandom.hex
		end
end
class Project
	include DataMapper::Resource

	property :id, Serial
	property :name, String

	has n, :tasks
end
class Task
	include DataMapper::Resource

	property :id, Serial
	property :status, String
	property :name, Text

	belongs_to :project
end

class App < Sinatra::Base
	configure do 
    	enable :sessions
    	set :session_secret, "vOLpM7pUR/0Cl06LktU2t/M8q5nz48DX2XSlB"
  	end

	DataMapper.setup(:default, 'postgres://localhost/statusboard-tasks')

	DataMapper.finalize
  	DataMapper.auto_upgrade!

  	get '/' do
  		@message = "Navigate to the <a href='/admin'>admin</a> panel."
  	end
  	get '/:project/tasks' do
  		@project = Project.get(params[:project].to_i)
  		@tasks = @project.tasks
  		erb :index
  	end
	get '/admin' do
		redirect '/admin/login' unless logged_in
		@projects = Project.all()
		erb :"admin/index"
	end
	get '/admin/project/:project/view' do
		redirect '/admin/login' unless logged_in
		@project = Project.get(params[:project].to_i)
		@tasks = @project.tasks
		erb :"admin/project"
	end
	get '/admin/project/:project/delete' do
		redirect '/admin/login' unless logged_in
		project = Project.get(params[:project].to_i)
		if project.tasks.destroy and project.destroy
			redirect '/admin'
		else
			@message = "Error deleting project. <a href='/admin'>Admin</a>"
		end
	end
	get '/admin/task/:task/delete' do
		redirect '/admin/login' unless logged_in
		task = Task.get(params[:task].to_i)
		if task.destroy
			@message = "Task successfully deleted. <a href='/admin'>Admin</a>"
		else
			@message = "Error deleting task. <a href='/admin'>Admin</a>"
		end
	end
	get '/admin/task/:task' do
		redirect '/admin/login' unless logged_in
		@task = Task.get(params[:task].to_i)
		erb :"admin/task"
	end
	get '/admin/:project/task/create' do
		redirect '/admin/login' unless logged_in
		@project = Project.get(params[:project].to_i)
		erb :"admin/create-task"
	end
	post '/admin/:project/task/create' do
		redirect '/admin/login' unless logged_in
		project = Project.get(params[:project].to_i)
		task = project.tasks.new
		task.name = params[:task_name]
		case params[:task_status]
		when "done"
			task.status = "value8"
		when "progress"
			task.status = "value4"
		when "no"
			task.status = "value1"
		end
		if task.save
			@message = "Task successfully created. <a href='/admin/project/#{params[:project]}/view'>Admin</a>"
		else
			@message = "Error creating task. <a href='/admin/project/#{params[:project]}/view'>Admin</a>"
		end
	end
	post '/admin/task/:task/update' do
		redirect '/admin/login' unless logged_in
		task = Task.get(params[:task].to_i)
		task.name = params[:task_name]
		case params[:task_status]
		when "done"
			task.status = "value8"
		when "progress"
			task.status = "value4"
		when "no"
			task.status = "value1"
		end
		if task.save
			@message = "Task successfully updated. <a href='/admin'>Admin</a>"
		else
			@message = "Error updating task. <a href='/admin'>Admin</a>"
		end
	end
	get '/admin/project/create' do
		redirect '/admin/login' unless logged_in
		erb :"admin/create-project"
	end
	post '/admin/project/create' do
		redirect '/admin/login' unless logged_in
		project = Project.new
		project.name = params[:project_name]
		if project.save
			redirect '/admin'
		else
			@message = "Error creating project. <a href='/admin'>Admin</a>"
		end
	end
	get '/admin/login' do
    	erb :"admin/login"
  	end
  	post '/admin/login' do
	    if admin = Admin.first(:username => params[:username])
	      if admin.password_hash == BCrypt::Engine.hash_secret(params[:password], admin.password_salt)
	        session[:admin] = admin.token
	        redirect '/admin'
	      else
	      	@message = 'Incorrect password, please try again.'
	      	erb :"admin/login"
	      end
	    else
	      @message = 'Incorrect username or password, please try again.'
	      erb :"admin/login"
	    end
  	end
  	get '/admin/logout' do
    	session[:admin] = nil
    	redirect '/admin/login'
  	end

	helpers do
    	def logged_in
      		@logged_in = Admin.first(:token => session[:admin]) if session[:admin]
    	end
	end
end