require_relative "item"
require_relative "item_list"
require_relative "message"

class Order
  def initialize(menu = ItemList.new, basket = ItemList.new)
    @menu = menu
    @basket = basket
    @complete = false
  end

  def load(hash)
    hash.each { @menu.add(Item.new(_1)) }
  end

  def complete?
    @complete
  end

  def help
    <<~COMMANDS
      Commands:
      help                    view commands
      menu                    view menu
      basket                  view basket
      add [item name]         add item to basket
      remove [item name]      remove item from basket
      checkout                complete order
    COMMANDS
  end

  def menu
    return "Menu not loaded" if @menu.empty?

    "---MENU---\n#{format_menu}\n----------"
  end

  def basket
    return "Your basket is empty" if @basket.empty?

    "--BASKET--\n#{format_basket}\n----------"
  end

  def add(input)
    item = @menu.find(input)
    return "Item not found in menu" if item.nil?

    @basket.add(item)
    "Added 1 x #{item.name.capitalize} to basket"
  end

  def remove(input)
    deleted = @basket.remove(input)
    return "Item not found in basket" if deleted.nil?

    "Removed 1 x #{deleted.name.capitalize} from basket"
  end

  def checkout(time = Time.now, message = Message.new)
    return "Cannot checkout an empty basket" if @basket.empty?

    delivery_time = (time + 3600).strftime("%R")
    body = "Thank you! Your order was placed and will be delivered before #{delivery_time}"
    message.dispatch(body)
    @complete = true
    body
  end

  def undefined
    "Command not found"
  end

  private

  def format_menu
    @menu.items.map do |item|
      name = item.name.capitalize
      price = money(item.price)
      "#{name} - £#{price}"
    end.join("\n")
  end

  def format_basket
    @basket.items.tally.map do |item, quantity|
      name = item.name.capitalize
      price = money(item.price * quantity)
      "#{quantity} x #{name} = £#{price}"
    end.push("Total = £#{money(@basket.total)}").join("\n")
  end

  def money(pennies)
    format("%.2f", pennies / 100.0)
  end
end
