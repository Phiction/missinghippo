class Layout
  include DataMapper::Resource

  property :id,        Serial
  property :name,      String
  property :file_name, String

  belongs_to :poster

  validates_presence_of :name
  validates_presence_of :file_name
end