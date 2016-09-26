require 'rss'
require 'open-uri'
require 'pry'
require 'yaml'
require 'yaml/store'

class Scraper
  def initialize(url, name)
    @url = url
    @name = name
    @date_created = Time.now
    @rss = self.scrape url
    @titles = []
    @descriptions = []
  end

  def created_when?
     d = @date_created
    "#{d.month}/#{d.day}/#{d.year} #{d.hour}:#{d.min}:#{d.sec}"
  end

  def get_titles
    if @titles.empty?
      @rss.items.each do |item|
        @titles.push item.title
      end
    else
      @titles
    end
  end

  def get_descriptions
    if @descriptions.empty?
      @rss.items.each do |item|
        @descriptions.push item.description
      end
    else
      @descriptions
    end
  end

  def print_titles
    @titles.each {|title| puts "Title: #{title}\n\n"}
  end

  def print_descriptions
    if @descriptions
      @descriptions.each {|desc| puts "Desc: #{desc}\n\n"}
    else
      print 'No descriptions found'
    end
  end

  def print_feed
    @rss.items.each {|item| puts "Title: #{item.title}\nDesc: #{item.description}\n"}
  end

  def scrape(url)
    open(url) do |rss|
      @rss = RSS::Parser.parse(rss)
    end
  end

  def save_feed
    store = YAML::Store.new "#{@name}.store"
    store.transaction do
      store['name']         = @name
      store['titles']       = @titles
      store['descriptions'] = @descriptions
      store['time_created'] = @time_created
      store['last_saved']   = Time.now
    end
  end

  def load_feed
    puts 'Feed name: '
    fname = gets.chomp
    fname + ".store"
    begin
      f = File.open(fname, 'r')
      store = YAML.load(f)
      @name         = store['name']
      @titles       = store['titles']
      @descriptions = store['descriptions']
      @time_created = store['time_created']
      @last_saved   = store['last_saved']
      self
    rescue Exception => msg
      puts msg
      puts 'Exiting...'
    ensure
      f.close
    end
  end
end
