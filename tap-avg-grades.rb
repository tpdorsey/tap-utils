require 'json'
require 'optparse'

ARGV << '-h' if ARGV.empty?

# Lookup table for float grade to letter grade
# Return array includes:
# - Letter grade
# - Index
# - 0 to 5 scale raw
# - 0 to 5 stars scale rounded to .5
# - 0 to 100 integer scale
def gradeLookup(grade)
  if grade <= 0
    return ["Not graded", -1]
  elsif grade >= 3.8
    return ["A+", 13, 5.00, 5.0, 100]
  elsif grade >= 3.47
    return ["A", 12,  4.58, 4.5, 92]
  elsif grade >= 3.14
    return ["A-", 11, 4.17, 4.0, 83]
  elsif grade >= 2.81
    return ["B+", 10, 3.75, 4.0, 75]
  elsif grade >= 2.48
    return ["B", 9, 3.33, 3.5, 67]
  elsif grade >= 2.15
    return ["B-", 8, 2.92, 3.0, 58]
  elsif grade >= 1.82
    return ["C+", 7, 2.50, 2.5, 50]
  elsif grade >= 1.49
    return ["C", 6, 2.08, 2.0, 42]
  elsif grade >= 1.16
    return ["C-", 5, 1.67, 1.5, 33]
  elsif grade >= 0.83
    return ["D+", 4, 1.25, 1.5, 25]
  elsif grade >= 0.50
    return ["D", 3, 0.83, 1.0, 17]
  elsif grade >= 0.17
    return ["D-", 2, 0.42, 0.5, 8]
  else
    return ["F", 1, 0.00, 0.0, 0]
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

options = {}
OptionParser.new do |opts|
  opts.banner = "Returns a table of average grades for each style in a TapCellar backup.\nUsage: tap-avg-grades.rb [options] [file to parse]"
  options[:csv] = false
  options[:filename] = ""

  opts.on("-c", "--csv", "Output CSV") do
    options[:csv] = true
  end

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

if options[:csv]
  puts "Style,Avg Grade,Grade Value,Rated Beers,Std Deviation"
else
  puts ""
  puts "Style".rjust(width) + "  Avg Grade  Rated  Std Deviation"
end

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
  if options[:csv]
    puts style + "," + letter_grade[0] + "," + letter_grade[1].to_s + "," + beerGrades.length.to_s + "," + std_dev.to_s
  else
    puts style.rjust(width) + "  " + letter_grade.ljust(11) + beerGrades.length.to_s.ljust(7) + std_dev.to_s
  end

  beerGrades.clear
end
