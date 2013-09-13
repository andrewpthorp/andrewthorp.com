# Public: The model that is used in the portfolio of the application.
class Project
  include DataMapper::Resource
  include Seedable

  property :id, Serial
  property :title, String, required: true, length: 255
  property :url, String, required: true
  property :body, Text, required: false
  property :image, String
  property :published, Boolean, required: true, default: true
  property :quote, String, length: 255
  property :created_at, DateTime
  property :updated_at, DateTime

  # Public: A scope that returns all Projects that have the Boolean published
  # set to true.
  #
  # Returns a DataMapper::Collection.
  def self.published
    all(published: true)
  end

  # Public: Get the URL to an image. All images are stored in the same bucket on
  # S3, so this method simply prepends the S3 URL to the :image.
  #
  # Returns a String.
  def full_image_url
    if image.blank?
      ''
    else
      "https://s3.amazonaws.com/andrewthorp-blog-pro/project-images/#{image}"
    end
  end

end
