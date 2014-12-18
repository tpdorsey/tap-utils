require 'json'
require 'optparse'

ARGV << '-h' if ARGV.empty?

options = {}
OptionParser.new do |opts|
  opts.banner = "Returns counts of each style in a TapCellar backup.\nUsage: tap-styles.rb [options] [file to parse]"
  options[:csv] = false
  options[:filename] = ""
  # options[:filter] = false

  opts.on("-c", "--csv", "Output CSV") do
    options[:csv] = true
  end

  # opts.on("-f", "--filter STRING", String, "Filter results by [STRING]") do |filter_string|
  #   options[:filter] = true
  #   options[:filter_string] = filter_string
  # end

  opts.on('-h', '--help', 'Display help for options' ) do
    puts opts
    exit
  end
end.parse!

options[:filename] = ARGV[ARGV.length - 1]

if File.exists?(options[:filename])
  file_hash = JSON.parse(File.open(options[:filename], 'r').read, :max_nesting => 100)
else
  puts "Error: File " + options[:filename] + " does not exist."
  exit
end

# Keep a list of style encountered as we read through records
beerStyles = Array.new

# Read through each record in the JSON and do stuff
file_hash["tapcellarbeers"].each do |beer_record|
  grade = beer_record["grade"].to_f.round(3)

  # Only process records with valid grades
  if grade > 0

    # Stash that style away
    if beer_record["bdb_style"].to_s != ""
      beer_style = beer_record["bdb_style"]
    elsif beer_record["style"].to_s != ""
      beer_style = beer_record["style"]
    else
      beer_style = "None"
    end

    beerStyles << beer_style
  end
end

# Hash to hold counts for styles
style_counts = Hash.new 0

# Counts for each unique style
beerStyles.each do |style|
  style_counts[style] += 1
end

sorted_styles = style_counts.sort_by { |style, count| style }

longest_style = sorted_styles.max_by { |x| x[0].length }
width = longest_style[0].length

# sorted_styles.each do |style|
#   puts style[0] + ", " + style[1].to_s
# end

puts ""

puts "Style".rjust(width) + "  Rated Beers"
sorted_styles.each do |style|
  puts style[0].rjust(width) + "  " + ('|' * style[1])
end

puts ""

belgians = 0
ipas = 0
stouts = 0
wheats = 0

sorted_styles.each do |style|
  if style[0].include?("Belgian")
    belgians += style[1]
  end

  if style[0].include?("India Pale Ale")
    ipas += style[1]
  end

  if style[0].include?("Stout") || style[0].include?("Porter")
    stouts += style[1]
  end

  if style[0].include?("Wit") || style[0].include?("Wheat")
    wheats += style[1]
  end
end

puts "Belgians".rjust(width) + "  " + ('|' * belgians)
puts "India Pale Ales".rjust(width) + "  " + ('|' * ipas)
puts "Stouts and Porters".rjust(width) + "  " + ('|' * stouts)
puts "Wheat and Wit".rjust(width) + "  " + ('|' * wheats)

puts ""