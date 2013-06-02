require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'json'
require './config/database'

namespace :db do
  desc 'Load seed data'
  task :seed do
    DataMapper.repository(:default).adapter.execute("TRUNCATE layouts RESTART IDENTITY CASCADE;")
    #if DataMapper.finalize.auto_migrate!
    #  # puts "Removed all records from Fracture table"
    #  puts "Migrated Database"
    #end

    if Layout.create(:name => 'Original', :file_name => 'original')
      puts "Created Layout:Original"
    end
  end

  desc 'Migrate database'
  task :migrate do
    repository(:default).adapter.select('DROP TABLE posters;')
    repository(:default).adapter.select('DROP TABLE layouts;')
    repository(:default).adapter.select('DROP TABLE newsletters;')
    
    DataMapper.auto_migrate!
    puts "Migrated Database"
  end
end