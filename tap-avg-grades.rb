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

# First argument is the file to read
# At this time we assume JSON
file_to_read = ARGV[0]

# Read and hash JSON
file_raw = File.open(file_to_read, 'r')
file_read = file_raw.read
file_hash = JSON.parse(file_read, :max_nesting => 100)

# Keep a list of style encountered as we read through records
beerStyles = Array.new
beerGrades = Array.new

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
    beerGrades << [beer_style, grade]
  end
end

# Hash to hold counts for styles
style_counts = Hash.new 0

# Counts for each unique style
beerStyles.each do |style|
  style_counts[style] += 1
end

# Hash to hold counts for grades
style_grades = Hash.new 0

# Counts for each unique style
beerGrades.each do |grade|
  style_grades[grade[0]] += grade[1]
end

sorted_styles = style_counts.sort_by { |style, count| style }

longest_style = sorted_styles.max_by { |x| x[0].length }
width = longest_style[0].length

# sorted_styles.each do |style|
#   puts style[0] + ", " + style[1].to_s
# end

puts ""

puts "Style".rjust(width) + "  Avg Grade"
sorted_styles.each do |style|
  avg_grade = style_grades[style[0]] / style[1]
  letter_grade = gradeLookup(avg_grade)

  puts style[0].rjust(width) + "  " + letter_grade.ljust(3) + " (" + avg_grade.round(3).to_s + ")"
end

puts ""