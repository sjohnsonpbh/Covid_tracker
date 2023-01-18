require 'pry'
require 'nokogiri'
require 'open-uri'
require_relative "printable.rb"
require_relative "country.rb"
require_relative "state.rb"

class Scraper
  extend Printable::Format
  SCRAPE_URL = "https://www.worldometers.info/coronavirus/country/us"

  def self.scrape_usa 
    puts "Scraping US Information"
    doc =  Nokogiri::HTML(URI.open("https://www.worldometers.info/coronavirus/country/us"))
    usa_confirmed_cases = text_to_integer(doc.css(".maincounter-number")[0].text)
    usa_overall_deaths = text_to_integer(doc.css(".maincounter-number")[1].text)
    usa_recoveries = text_to_integer(doc.css(".maincounter-number")[2].text)

    Country.new("USA", usa_confirmed_cases, usa_overall_deaths, usa_recoveries)
  end

  def self.scrape_states
    puts "Scraping U.S. State information..."
    doc = Nokogiri::HTML(URI.open(SCRAPE_URL))

    doc.css('tbody tr')[1..51].each do |state_row|
      row = state_row.css("td")
      name = row[1].text.split(" ").join(" ")
      cases = text_to_integer(row[2].text)
      deaths = text_to_integer(row[4].text)
      recoveries = text_to_integer(row[6].text)
      if name != "District Of Columbia" 
        State.new(name, cases, deaths, recoveries)
      end
    end
  end

  def self.scrape_information 
    # call scrape_usa for scrape us information
    scrape_usa
    # call scrape_states for scrape state information
    scrape_states 
  end
end
