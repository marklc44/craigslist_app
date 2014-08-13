# scrapper.rb
require 'nokogiri'
require 'open-uri'
require 'awesome_print'


REGEX = "/Dog|dog|Puppies|puppies|puppy|Puppy|pup|Pup/"

# add pics to get_todays_rows
def filter_links(rows, regex)
  pupRows = rows.select do |row|
    row.css(".hdrlnk").text.downcase.match(regex)
  end
end

def get_todays_rows(doc, date_str)
  rows = doc.css('.row')
  todayRows = rows.select do |row|
    row.css("span.date").text == date_str
  end
  filter_links(todayRows, REGEX)
end

def get_page_results(date_str)
  url = "today.html"
  doc = Nokogiri::HTML(open(url))
  get_todays_rows(doc, date_str)
end

def search(date_str)
  results = get_page_results(date_str)
  rows = results.map do |result|

    {
      title: result.css(".hdrlnk").text,
      date: result.css(".date").text,
      link: result.css(".pl a").first["href"]
    }
  end
  rows
end

# want to learn more about
# Time in ruby??
#   http://www.ruby-doc.org/stdlib-1.9.3/libdoc/date/rdoc/Date.html#strftime-method
today = Time.now.strftime("%b %d")

results = search(today)
ap results
puts results.length





