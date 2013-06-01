class Newsletter
  include DataMapper::Resource

  property :id,       Serial
  property :email,    String
  property :zip_code, Integer

  validates_presence_of :email
  validates_presence_of :zip_code
end