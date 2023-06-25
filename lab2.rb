require 'json'

# Database class to handle JSON file operations
class Database
  def initialize(filename)
    @filename = filename
    create_database_file unless File.exist?(@filename)
  end

  def create_database_file
    File.write(@filename, [].to_json)
  end

  def read_data
    JSON.parse(File.read(@filename))
  end

  def write_data(data)
    File.write(@filename, JSON.generate(data))
  end
end

# User class
class User
  attr_accessor :name, :email, :mobile

  def initialize(name, email, mobile)
    @name = name
    @email = email
    @mobile = mobile
  end

  def create
    if valid_name? && valid_mobile?
      all_users = Database.new('database.json').read_data
      all_users << { name: name, email: email, mobile: mobile }
      Database.new('database.json').write_data(all_users)
      puts "Welcome #{name}"
      self
    else
      puts "Sorry, invalid name or mobile number"
      false
    end
  end

  def valid_name?
    /^[a-zA-Z ]+$/.match?(name)
  end

  def valid_mobile?
    /^0\d{10}$/.match?(mobile)
  end

  def self.list(n = 0)
    all_users = Database.new('database.json').read_data
    users = n > 0 ? all_users.first(n) : all_users
    users.each do |user_data|
      user = User.new(user_data['name'], user_data['email'], user_data['mobile'])
      puts "#{user.name} : #{user.email} | #{user.mobile}"
    end
  end
end

# Prompt function
def prompt(message)
  print "#{message}: "
  gets.chomp
end

# User register function
def user_register
  name = prompt('Enter Your Name')
  email = prompt('Enter Your Email')
  mobile = prompt('Enter Your Mobile')

  user = User.new(name, email, mobile)
  user.create
end

# List users data
def list_users
  input = prompt("Enter (*) to list all registered users or the number of users you would like to list")
  if input == '*'
    User.list
  elsif input.to_i > 0
    User.list(input.to_i)
  else
    puts "Invalid input"
  end
end

# Calling functions

# Call register user function
user_register

# Call list user function
list_users
