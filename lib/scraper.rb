require 'open-uri'
require 'pry'

class Scraper

    attr_accessor :student
    @@all = []

    def self.scrape_index_page(index_url)
      html = open(index_url)
      doc = Nokogiri::HTML(html)
      students = []
      doc.css("div.student-card").each do |student|
        students << {
        :name => student.css("h4.student-name").text,
        :location => student.css("p.student-location").text,
        :profile_url => student.children[1].attributes["href"].value
        }
      end
      students
    end

    def self.scrape_profile_page(profile_url)
      html = open(profile_url)
      doc = Nokogiri::HTML(html)
      student_page = {}
      socials = doc.css(".social-icon-container").css('a').collect {|e| e.attributes["href"].value}
      socials.detect do |network|
        student_page[:twitter] = network if network.include?("twitter")
        student_page[:linkedin] = network if network.include?("linkedin")
        student_page[:github] = network if network.include?("github")
      end
      student_page[:blog] = socials[3] if socials[3] != nil
      student_page[:profile_quote] = doc.css(".profile-quote")[0].text
      student_page[:bio] = doc.css(".description-holder").css('p')[0].text
      student_page
    end
end

# learn spec/scraper_spec.rb