require 'open-uri'
require 'pry'



class Scraper

  def self.scrape_index_page(index_url)
    index_url = Nokogiri::HTML(open("https://learn-co-curriculum.github.io/student-scraper-test-page/index.html"))
    index_url.css(".student-card").collect do |profile|
      hash =
        {name: profile.css("h4").text,
        location: profile.css("p").text,
        profile_url: profile.css("a").first["href"]
      }
    end
  end

  def self.scrape_profile_page(profile_url)
    profile_url = Nokogiri::HTML(open(profile_url))
    links = profile_url.css(".social-icon-container").children.css("a").map do |link|
      link.attribute("href").value
    end
    student_profile = {}

    links.map do |link|
      if link.include?("twitter")
      student_profile[:twitter] = link
      elsif
        link.include?("linkedin")
        student_profile[:linked] = link
      elsif
        link.include?("github")
        student_profile[:github] = link
      elsif
        link.include?("blog")
        student_profile[:blog] = link
      end
    end

    student_profile[:profile_quote] = profile_url.css(".vitals-container .vitals-text-container .profile-quote").text
    student_profile[:bio] = profile_url.css(".bio-block.details-block .bio-content.content-holder .description-holder p").text

    student_profile
  end
end
