require 'pry'
require "nokogiri"

describe "#create_project_hash" do

  # This just opens a file and reads it into a variable
  html = File.read('fixtures/kickstarter.html')

  kickstarter = Nokogiri::HTML(html)

  it "can be called on with no errors" do
    expect {create_project_hash}.to_not raise_error
  end

  it "returns a hash" do
    expect(create_project_hash.class).to eq(Hash)
  end

  it "includes at least five projects" do
    expect(create_project_hash.length).to be >= 5
  end

  it "project titles point to a hash of info" do
    create_project_hash.each do |project_title, info_hash|
      expect(info_hash.class).to eq(Hash)
    end
  end

  it "each project has an image link hosted on AmazonAWS" do
    create_project_hash.each do |project_title, info_hash|
      regex = /https:\/\/s3.amazonaws.com\//
      expect(regex.match(info_hash[:image_link])).to_not be_nil
    end
  end

  it "each project has a description which is a string" do
    create_project_hash.each do |project_title, info_hash|
      expect(info_hash[:description].class).to eq(String)
    end
  end

  it "each project has a location which is a string" do
    create_project_hash.each do |project_title, info_hash|
      expect(info_hash[:location].class).to eq(String)
    end
  end

  it "each project has percentage funded listed which is an integer" do
    create_project_hash.each do |project_title, info_hash|
      expect(info_hash[:percent_funded].class).to eq(Fixnum)
    end
  end


end

# projects: kickstarter.css("li.project.grid_4")
# title: project.css("h2.bbcard_name strong a").text
# image link: project.css("div.project-thumbnail a img").attribute("src").value
#project.css("p.bbcard_blurb").text
# location: project.css("ul.project-meta span.location-name").text
# percent_funded: project.css("ul.project-stats li.first.funded strong").text.gsub("%","").to_i

# create_project_hash
def create_project_hash
  html = File.read('fixtures/kickstarter.html')
  kickstarter = Nokogiri::HTML(html)

  projects = {}

  kickstarter.css("li.project.grid_4").each do |project|
    title = project.css("h2.bbcard_name strong a").text
    projects[title.to_sym] = {
      :image_link => project.css("div.project-thumbnail a img").attribute("src").value,
      :description => project.css("p.bbcard_blurb").text,
      :location => project.css("ul.project-meta span.location-name").text,
      :percent_funded => project.css("ul.project-stats li.first.funded strong").text.gsub("%","").to_i
    }
  end

  # return the projects hash
  projects
end
