class Newsletter
  include DataMapper::Resource

  property :id,       Serial
  property :email,    String
  property :zip_code, Integer
end