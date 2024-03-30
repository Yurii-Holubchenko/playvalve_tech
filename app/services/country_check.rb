class CountryCheck
  def initialize(country_code)
    @country_code = country_code
  end

  def valid?
    allowed_countries.include?(country_code)
  end

  private

  attr_reader :country_code

  def allowed_countries
    $redis.smembers("allowed_countries")
  end
end
