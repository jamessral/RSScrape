require_relative 'scrape'

def main
  start
end

def start
  puts "         Welcome to RSScrape           "
  puts "---------------------------------------"
  puts "         Enter Feed's URL              "
  puts "\n"
  url = gets.chomp
  puts "\n"
  puts "What would you like to call this feed?\n\n"
  name = gets.chomp
  puts "\n"

  begin
    scrape = Scraper.new(url,name)
    scrape.get_titles
    scrape.get_descriptions
    get_op scrape
  rescue Exception => msg
    puts msg
    puts "Invalid URL\n\nTry Again? (y/n)\n\n"
    again = gets.chomp.downcase
    puts "\n"
    if again == "y" or again == "yes"
      main
    else
      puts "Goodbye"
    end
  end
end

def get_op(scraper)
  scrape = scraper

  puts "\n"
  puts "          Choose an option             "
  puts "---------------------------------------"
  puts " 1) Print titles                       "
  puts " 2) Print descriptions                 "
  puts " 3) Print both                         "
  puts " 4) Save current feed                  "
  puts " 5) Load a feed                        "
  puts " 6) Scrape another feed                "
  puts " 7) Exit                               "
  puts "\n"

  option = gets.chomp
  puts "\n"

  case option
  when "1"
    scrape.print_titles
    puts "Press any key to continue"
    gets
    get_op scrape
  when "2"
    scrape.print_descriptions
    puts "Press any key to continue"
    gets
    get_op scrape
  when "3"
    scrape.print_feed
    puts "Press any key to continue"
    gets
    get_op scrape
  when "4"
    puts "Saving feed..."
    begin
      scrape.save_feed
      get_op scrape
    rescue Exception => msg
      puts "There was an error: "
      puts msg
      puts "\n\n"
      main
    end
  when "5"
    begin
      scrape = scrape.load_feed
      get_op scrape
    rescue NoMethodError
      puts "Feed not found"
      get_op scrape
    rescue Exception => msg
      puts "There was an error: "
      puts msg
      puts "\n\n"
      main
    end
  when "6"
    main
  when "7"
    puts "Goodbye"
  else
    puts "I don't Understand\n"
  end
end

main
