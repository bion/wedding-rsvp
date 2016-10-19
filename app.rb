require 'rubygems'
require 'sinatra/base'
require 'active_record'

ActiveRecord::Base.establish_connection \
  adapter: 'sqlite3',
  database: '/var/www/wedding-rsvp/database.db',
  timeout: 1000

ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.data_sources.include? 'rsvps'
    create_table :rsvps do |table|
      table.column :name,             :string
      table.column :email,            :string
      table.column :number_attending, :integer
      table.column :message,          :text
      table.column :everything_else,  :text
    end
  end
end

class RSVP < ActiveRecord::Base; end

class App < Sinatra::Base
  post '/rsvp' do
    puts "Received rsvp at #{Time.now} with params #{params}"

    RSVP.create \
      name: params[:name],
      email: params[:_replyto],
      number_attending: params[:attending],
      message: params[:message]

    redirect "http://www.johnxin.party/rsvp-confirmation"
  end
end
