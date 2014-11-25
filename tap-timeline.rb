#!/usr/bin/env ruby

# tap-timeline.rb - returns a timeline of grades for a given style

require 'json'

# Lookup table for float grade to letter grade
# Involves some guesswork but I think it's pretty close
def gradeLookup(grade)
  if grade <= 0
    return "Not graded"
  elsif grade >= 3.8
    return "A+"
  elsif grade >= 3.47
    return "A"
  elsif grade >= 3.14
    return "A-"
  elsif grade >= 2.81
    return "B+"
  elsif grade >= 2.48
    return "B"
  elsif grade >= 2.15
    return "B-"
  elsif grade >= 1.82
    return "C+"
  elsif grade >= 1.49
    return "C"
  elsif grade >= 1.18
    return "C-"
  elsif grade >= 0.83
    return "D+"
  elsif grade >= 0.50
    return "D"
  elsif grade >= 0.17
    return "D-"
  else
    return "F"
  end
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
        grade_date = beer_record["tastings"][0]["timestamp"]
      else
        grade_date = beer_record["editdate"]
      end

      grade_data = gradeLookup(grade)

      beerGrades << [grade_date, grade_data]
    end

  end
end

puts beerGrades