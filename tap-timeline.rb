#!/usr/bin/env ruby

# tap-timeline.rb - returns a timeline of grades for a given style

require 'json'
require 'date'

# Lookup table for float grade to letter grade
# Involves some guesswork but I think it's pretty close
def gradeLookup(grade)
  if grade <= 0
    return ["Not graded", 0]
  elsif grade >= 3.8
    return ["A+", 13]
  elsif grade >= 3.47
    return ["A",  12]
  elsif grade >= 3.14
    return ["A-", 11]
  elsif grade >= 2.81
    return ["B+", 10]
  elsif grade >= 2.48
    return ["B",  9]
  elsif grade >= 2.15
    return ["B-", 8]
  elsif grade >= 1.82
    return ["C+", 7]
  elsif grade >= 1.49
    return ["C",  6]
  elsif grade >= 1.16
    return ["C-", 5]
  elsif grade >= 0.83
    return ["D+", 4]
  elsif grade >= 0.50
    return ["D",  3]
  elsif grade >= 0.17
    return ["D-", 2]
  else
    return ["F",  1]
  end
end

def parse_timestamp(date)
  return DateTime.strptime(date, "%Y-%m-%d %H:%M:%S %Z")
end

# Assume first argument is style, second is JSON
style_keyword = ARGV[0].downcase
file_to_read = ARGV[1]

# Read and hash JSON
file_hash = JSON.parse(File.open(file_to_read, 'r').read, :max_nesting => 100)

# We'll keep data for each grade in this array
beerGrades = Array.new

# Read through each record in the JSON and do stuff
file_hash["tapcellarbeers"].each do |beer_record|

  # Only process records with valid grades
  grade = beer_record["grade"].to_f.round(3)
  if grade > 0

    if beer_record["bdb_style"].to_s.downcase.include? style_keyword or beer_record["style"].to_s.downcase.include? style_keyword

      if beer_record.has_key?("tastings")
        timestamp = parse_timestamp(beer_record["tastings"][0]["timestamp"])
      else
        timestamp = parse_timestamp(beer_record["editdate"])
      end

      grade_data = gradeLookup(grade)

      beerGrades << [timestamp, grade_data[0], grade_data[1]]
    end

  end
end

beerGrades.sort! { |a, b| a[0] <=> b[0] }

puts "Grade timeline for styles containing: " + style_keyword.split.map(&:capitalize).join(' ')
puts ""
puts "Date".ljust(12) + "Grade F" + "A+".rjust(12)
beerGrades.each do |beer|
  puts beer[0].strftime("%Y-%m-%d") + "  " + beer[1].ljust(4) + (' ' * beer[2]) + "*"
end



