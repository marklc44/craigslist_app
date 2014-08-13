require "./scrapper"

describe "scrapper" do

  before(:each) do
    # use @doc in your tests to avoid hitting the
    #   craigslist url, which would be slow and
    #   problematic if you were blocked
    @doc = Nokogiri::HTML(open("today.html"))
    @today = "Aug 12"
  end

  describe "filter_links" do
    it "should here is an example of using the befor each data" do
      rows = @doc.css(".row")
      rows.each do |row|
        puts row.content
      end
      results = filter_links(rows, REGEX)
      expect(results).to be_a(Array)
    end

    it "you can also use a string" do
      # rowsString is contains one valid row
      rowsString =  '<p class="row" data-pid="4581207234"> <a href="/sfc/pet/4581207234.html" class="i" data-id="0:00F0F_kUje2CUzekG"></a> <span class="txt"> <span class="star"></span> <span class="pl"> <span class="date">Aug 12</span>  <a href="/sfc/pet/4581207234.html" data-id="4581207234" class="hdrlnk">$25/night In Home Dog Sitter! Small Dog Retreat &#9829;</a> </span> <span class="l2">   <span class="pnr"> <small> (Bay Area)</small> <span class="px"> <span class="p"> pic&nbsp;<span class="maptag" data-pid="4581207234">map</span></span></span> </span>  </span> </span> </p>'
      rows = Nokogiri::HTML(rowsString)
      expect(filter_links(rows, @today).length).to eql(1)
    end
  end

  describe "get_todays_rows" do
    it "can take Nokogiri object and date string and return an array" do
      expect(get_todays_rows(@doc, @today)).to be_a(Array)
    end
  end

  describe "get_page_results" do
    it "takes a date string and returns an array" do
      expect(get_page_results(@today)).to be_a(Array)
    end
    it "should contain an title with text" do
      expect(get_page_results(@today).first.css(".hdrlnk").text).to be_a(String)
    end
  end

  describe "search" do
    it "takes a date string and returns a hash" do
      expect(search(@today).first).to be_a(Hash)
    end
    it "should return an array of length 33" do
      expect(search(@today).length).to eql(33)
    end
  end
end