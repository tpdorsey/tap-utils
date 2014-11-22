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

# Math stuff for standard deviation
def sum(a)
  a.inject(0){ |accum, i| accum + i }
end

def mean(a)
  sum(a) / a.length.to_f
end

def sample_variance(a)
  m = mean(a)
  sum1 = a.inject(0){ |accum, i| accum + (i - m) ** 2 }
  sum1 / (a.length - 1).to_f
end

def standard_deviation(a)
  Math.sqrt(sample_variance(a))
end

# First argument is the file to read
# At this time we assume JSON
file_to_read = ARGV[0]

# Read and hash JSON
file_raw = File.open(file_to_read, 'r')
file_read = file_raw.read
file_hash = JSON.parse(file_read, :max_nesting => 100)

# Keep a list of style encountered as we read through records
beerStyles = Array.new

# We'll keep data for each grade in this array
beerGrades = Array.new

# Read through each record in the JSON and do stuff
file_hash["tapcellarbeers"].each do |beer_record|

  # Only process records with valid grades
  if beer_record["grade"].to_f > 0

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

# Filter just unique beer styles and sort
uniqueBeerStyles = beerStyles.uniq
uniqueBeerStyles.sort!

# Get the longest style name and save that for formatting later
longest_style = uniqueBeerStyles.max_by { |x| x.length }
width = longest_style.length

# Print header
puts ""
puts "Style".rjust(width) + "  Avg Grade  Rated  Std Deviation"

# For each style, pull grades from records with that style
uniqueBeerStyles.each do |style|
  file_hash["tapcellarbeers"].each do |beer_record|
    grade = beer_record["grade"].to_f.round(3)

    # Only process records with valid grades
    if grade > 0
      if beer_record["bdb_style"].to_s == style or beer_record["style"].to_s == style
        beerGrades << grade
      end
    end
  end

  # Process raw grades to get avg score and letter grade for avg score
  avg_grade = mean(beerGrades)
  letter_grade = gradeLookup(avg_grade)

  # Calculate standard deviation
  if beerGrades.length > 1
    std_dev = standard_deviation(beerGrades).round(3)
  else
    std_dev = ""
  end

  # Print line for style
  puts style.rjust(width) + "  " + letter_grade.ljust(11) + beerGrades.length.to_s.ljust(7) + std_dev.to_s

  beerGrades.clear
end

puts ""
