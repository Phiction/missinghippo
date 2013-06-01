class Layout
  include DataMapper::Resource

  property :id,        Serial
  property :name,      String
  property :file_name, String

  belongs_to :poster
end