class ItemList
  attr_reader :items

  def initialize
    @items = []
  end

  def add(item)
    @items << item
  end

  def empty?
    @items.empty?
  end

  def total
    @items.sum(&:price)
  end

  def find(string)
    @items.find { _1.name == string }
  end

  def remove(string)
    @items.delete_at(@items.index { _1.name == string } || @items.length)
  end
end
