#!/usr/bin/env ruby

# tap-archive.rb - create a portable beer archive from your backup

require 'json'
require 'date'
require 'optparse'

# Lookup table for float grade to letter grade
# Return array includes:
# - Letter grade
# - Index
# - 0 to 5 scale raw

def gradeLookup(grade)
  if grade <= 0
    return ["Not graded", -1]
  elsif grade >= 3.8
    return ["A+", 12, 5.00]
  elsif grade >= 3.47
    return ["A",  11, 4.58]
  elsif grade >= 3.14
    return ["A-", 10, 4.17]
  elsif grade >= 2.81
    return ["B+",  9, 3.75]
  elsif grade >= 2.48
    return ["B",   8, 3.33]
  elsif grade >= 2.15
    return ["B-",  7, 2.92]
  elsif grade >= 1.82
    return ["C+",  6, 2.50]
  elsif grade >= 1.49
    return ["C",   5, 2.08]
  elsif grade >= 1.16
    return ["C-",  4, 1.67]
  elsif grade >= 0.83
    return ["D+",  3, 1.25]
  elsif grade >= 0.50
    return ["D",   2, 0.83]
  elsif grade >= 0.17
    return ["D-",  1, 0.42]
  else
    return ["F",   0, 0.00]
  end
end

def parse_timestamp(date)
  return DateTime.strptime(date, "%Y-%m-%d %H:%M:%S %Z")
end


options = {}
OptionParser.new do |opts|
  opts.banner = "Returns a timeline of grades for a given keyword in a TapCellar backup.\n"\
                "Default filter (no options) is on style.\n"\
                "Usage: tap-timeline.rb [options] [style_keyword] [file to parse]"

  options[:filename] = ""

  opts.on('-h', '--help', 'Display help for options' ) do
    puts opts
    exit
  end
end.parse!

options[:filename] = ARGV[0]

if File.exists?(options[:filename])
  file_hash = JSON.parse(File.open(options[:filename], 'r').read, :max_nesting => 100)
else
  puts "Error: File " + options[:filename] + " does not exist."
  exit
end

puts "beercount = " + file_hash["beercount"]
puts "tapcellarbeers contains: " + file_hash["tapcellarbeers"].length.to_s

# We'll keep data for each grade in this array
beerGrades = Array.new

# Read through each record in the JSON and do stuff
file_hash["tapcellarbeers"].each do |beer_record|

  # Only process records with valid grades
  grade = beer_record["grade"].to_f.round(3)
  if grade > 0

    if beer_record.has_key?("tastings")
      timestamp = parse_timestamp(beer_record["tastings"][0]["timestamp"])
    else
      timestamp = parse_timestamp(beer_record["editdate"])
    end

    grade_data = gradeLookup(grade)

    beerGrades << [timestamp, grade_data[0], grade_data[1], beer_record["beername"], grade_data[2], grade_data[3], grade_data[4], grade_data[5]]

  end
end

# beerGrades.sort! { |a, b| a[0] <=> b[0] }

# if options[:csv]
#   puts "Date, Grade, 0-4, 0-5, Stars, 100, Name"

#   beerGrades.each do |beer|
#     puts beer[0].strftime("%Y-%m-%d") + "," + beer[1] + "," + beer[7].to_s + "," + beer[4].to_s + "," + beer[5].to_s + "," + beer[6].to_s + "," + beer[3]
#   end

#   exit
# end


