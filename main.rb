require_relative "lib/order"

order = Order.new

menu = [
  { "name" => "burger", "price" => 500 },
  { "name" => "pizza", "price" => 700 },
  { "name" => "pasta", "price" => 600 },
  { "name" => "curry", "price" => 550 },
  { "name" => "fajitas", "price" => 650 }
]

order.load(menu)

puts order.menu
puts order.help

until order.complete?
  input = gets.chomp.downcase.split
  method = input.shift.to_sym
  argument = input.join(" ")
  method = :undefined unless %i[help menu basket add remove checkout].include? method
  method = [method, argument] if %i[add remove].include? method
  puts order.send(*method)
end