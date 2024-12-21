class Url < ApplicationRecord
    validates :original_url, presence: true, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
  
    before_create :generate_short_url
  
    def generate_short_url
      self.short_url = SecureRandom.alphanumeric(6)
    end
end
