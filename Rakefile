require 'data_mapper'
require 'bcrypt'
require 'securerandom'

task :migrate do
  DataMapper.setup(:default, 'postgres://localhost/statusboard-tasks')
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
    property :worker, Text

    belongs_to :project
  end
  DataMapper.auto_migrate!
end

task :create_admin, :user, :password do |t, args|
  DataMapper.setup(:default, 'postgres://localhost/statusboard-tasks')
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
  DataMapper.finalize
  DataMapper.auto_upgrade!
  admin = Admin.create(:username => args[:user], :password => args[:password])
  admin.password_salt = BCrypt::Engine.generate_salt
  admin.password_hash = BCrypt::Engine.hash_secret(args[:password], admin.password_salt)
  if admin.save
    puts 'Admin created!'
  else
    puts 'Admin was unable to be created, does the username already exist?'
  end
end
