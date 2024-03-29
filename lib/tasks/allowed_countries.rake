require "csv"

task allowed_countries: :environment do
  country_codes = CSV.read("lib/tasks/support/countries.csv").flatten

  redis = Redis.new
  existed_codes = redis.smembers("allowed_countries")
  new_codes = country_codes - existed_codes

  unless new_codes.empty?
    redis.sadd(:allowed_countries, new_codes)
    puts "Newly added country codes: #{new_codes.join(", ")}"
  end
end
