#!/usr/bin/env ruby

# tap-timeline.rb - returns a timeline of grades for a given style

require 'json'
require 'date'
require 'optparse'

# Lookup table for float grade to letter grade
# Return array includes:
# - Letter grade
# - Index
# - 0 to 5 scale raw
# - 0 to 5 stars scale rounded to .5
# - 60 to 100 scale similar to BeerAdvocate
# - 0 to 4 scale
def gradeLookup(grade)
  if grade <= 0
    return ["Not graded", -1]
  elsif grade >= 3.8
    return ["A+", 12, 5.00, 5.0, 100, 4.0]
  elsif grade >= 3.47
    return ["A", 11,  4.58, 4.5, 97, 3.67]
  elsif grade >= 3.14
    return ["A-", 10, 4.17, 4.0, 93, 3.33]
  elsif grade >= 2.81
    return ["B+", 9, 3.75, 4.0, 90, 3.0]
  elsif grade >= 2.48
    return ["B", 8, 3.33, 3.5, 87, 2.67]
  elsif grade >= 2.15
    return ["B-", 7, 2.92, 3.0, 83, 2.33]
  elsif grade >= 1.82
    return ["C+", 6, 2.50, 2.5, 80, 2.0]
  elsif grade >= 1.49
    return ["C", 5, 2.08, 2.0, 77, 1.67]
  elsif grade >= 1.16
    return ["C-", 4, 1.67, 1.5, 73, 1.33]
  elsif grade >= 0.83
    return ["D+", 3, 1.25, 1.5, 70, 1.0]
  elsif grade >= 0.50
    return ["D", 2, 0.83, 1.0, 67, 0.67]
  elsif grade >= 0.17
    return ["D-", 1, 0.42, 0.5, 63, 0.33]
  else
    return ["F", 0, 0.00, 0.0, 60, 0.0]
  end
end

def parse_timestamp(date)
  return DateTime.strptime(date, "%Y-%m-%d %H:%M:%S %Z")
end

# Math stuff for avg grade
def sum(a)
  a.inject(0){ |accum, i| accum + i }
end

def mean(a)
  sum(a) / a.length.to_f
end

ARGV << '-h' if ARGV.length < 2

options = {}
OptionParser.new do |opts|
  opts.banner = "Returns a timeline of grades for a given keyword in a TapCellar backup.\n"\
                "Default filter (no options) is on style.\n"\
                "Usage: tap-timeline.rb [options] [style_keyword] [file to parse]"
  options[:csv] = false
  options[:filename] = ""
  options[:keyword] = ""
  options[:filter] = "style"

  opts.on("-s", "--style", "Filter on style") do
    options[:filter] = "style"
  end

  opts.on("-b", "--brewery", "Filter on brewery") do
    options[:filter] = "breweryname"
  end

  opts.on("-n", "--name", "Filter on name") do
    options[:filter] = "beername"
  end

  opts.on("-c", "--csv", "Output CSV") do
    options[:csv] = true
  end

  opts.on('-h', '--help', 'Display help for options' ) do
    puts opts
    exit
  end
end.parse!

options[:filename] = ARGV[ARGV.length - 1]
options[:keyword] = ARGV[ARGV.length - 2].downcase

if File.exists?(options[:filename])
  file_hash = JSON.parse(File.open(options[:filename], 'r').read, :max_nesting => 100)
else
  puts "Error: File " + options[:filename] + " does not exist."
  exit
end

# We'll keep data for each grade in this array
beerGrades = Array.new

# Read through each record in the JSON and do stuff
file_hash["tapcellarbeers"].each do |beer_record|

  # Only process records with valid grades
  grade = beer_record["grade"].to_f.round(3)
  if grade > 0

    if beer_record[options[:filter]].to_s.downcase.include? options[:keyword]

      if beer_record.has_key?("tastings")
        timestamp = parse_timestamp(beer_record["tastings"][0]["timestamp"])
      else
        timestamp = parse_timestamp(beer_record["editdate"])
      end

      grade_data = gradeLookup(grade)

      beerGrades << [timestamp, grade_data[0], grade_data[1], beer_record["beername"], grade_data[2], grade_data[3], grade_data[4], grade_data[5]]
    end

  end
end

beerGrades.sort! { |a, b| a[0] <=> b[0] }

if options[:csv]
  puts "Date, Grade, 0-4, 0-5, Stars, 100, Name"

  beerGrades.each do |beer|
    puts beer[0].strftime("%Y-%m-%d") + "," + beer[1] + "," + beer[7].to_s + "," + beer[4].to_s + "," + beer[5].to_s + "," + beer[6].to_s + "," + beer[3]
  end

  exit
end

grades_array = Array.new

puts ""
puts "Grade timeline for " + options[:filter] + " containing: " + options[:keyword].split.map(&:capitalize).join(' ')
puts ""
puts "Date".ljust(12) + "Grade F" + "A+".rjust(12) + "  Name"
beerGrades.each do |beer|
  puts beer[0].strftime("%Y-%m-%d") + "  " + beer[1].ljust(5) + (' ' * beer[2]) + "*" + (' ' * (15 - beer[2])) + beer[3]

  grades_array << beer[7]
end
puts ""

# Process raw grades to get avg score and letter grade for avg score
avg_grade = mean(grades_array)
letter_grade = gradeLookup(avg_grade)

puts "Mean Grade: " + letter_grade[0].ljust(5) + (' ' * letter_grade[1]) + "*"