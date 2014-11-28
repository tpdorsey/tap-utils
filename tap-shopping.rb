# tap-shopping.rb - returns a shopping list from your TapCellar backup

require 'json'
require 'optparse'

ARGV << '-h' if ARGV.empty?

options = {}
OptionParser.new do |opts|
  options[:banner] = "Usage: example.rb [options] [file to parse]"
  options[:filter] = ""
  options[:filename] = ""
  options[:sort] = 0

  # opts.on("-f", "--filter STRING", String, "Filter results by [STRING]") do |filter_string|
  #   options[:filter] = filter_string
  # end

  opts.on("-n", "--name", "Sort results by name") do
    options[:sort] = 0
  end

  opts.on("-b", "--brewery", "Sort results by brewery") do
    options[:sort] = 3
  end

  opts.on("-s", "--style", "Sort results by style") do
    options[:sort] = 2
  end

  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end.parse!

options[:filename] = ARGV[ARGV.length - 1]

# Read and hash JSON
if File.exists?(options[:filename])
  file_hash = JSON.parse(File.open(options[:filename], 'r').read, :max_nesting => 100)
else
  puts "Error: File " + options[:filename] + " does not exist."
  exit
end

# Array for shopping list
beer_wishlist = Array.new

# Read through each record in the JSON and do stuff
file_hash["tapcellarbeers"].each do |beer_record|

  if beer_record["shoppingcart"].to_i > 0

    # Find the style
    if beer_record["bdb_style"].to_s != ""
      beer_style = beer_record["bdb_style"]
    elsif beer_record["style"].to_s != ""
      beer_style = beer_record["style"]
    else
      beer_style = ""
    end

    if beer_record["breweryname"].start_with?("The ")
      brewery_sort_name = beer_record["breweryname"].slice(4..-1)
    else
      brewery_sort_name = beer_record["breweryname"]
    end

    beer_wishlist << [beer_record["beername"], beer_record["breweryname"], beer_style, brewery_sort_name]
  end

end

# Sort list - could be expanded to sort by brewery or style
beer_wishlist.sort! { |a, b| a[options[:sort]] <=> b[options[:sort]] }

puts ""
puts "# TapCellar Shopping List #"
puts ""

beer_wishlist.each do |beer|
  puts beer[0].to_s + " [" + beer[2] + "]"
  puts beer[1].to_s
  puts ""
end

puts ""


