# tap-timeline.rb - returns a timeline of grades for a given style

require 'json'

# First argument is the file to read
file_to_read = ARGV[0]

# To Do: filter by style?

# Read and hash JSON
file_hash = JSON.parse(File.open(file_to_read, 'r').read, :max_nesting => 100)

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
    beer_wishlist << [beer_record["beername"], beer_record["breweryname"], beer_style]
  end

end

# Sort list - could be expanded to sort by brewery or style
beer_wishlist.sort! { |a, b| a[0] <=> b[0] }

puts ""
puts "TapCellar Shopping List"
puts ""

beer_wishlist.each do |beer|
  puts beer[0].to_s + " (" + beer[1].to_s + ")"
  puts (" " * 4) + beer[2]
  puts ""
end

puts ""