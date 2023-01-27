require_relative "../lib/order"
require_relative "../lib/item_list"
require_relative "../lib/message"

describe Order do
  before(:each) do
    @order = Order.new
  end
  
  context "initially" do
    describe "#complete?" do
      it "returns false" do
        expect(@order.complete?).to be(false)
      end
    end

    describe "#help" do
      it "returns commands list" do
        expected = <<~COMMANDS
          Commands:
          help                    view commands
          menu                    view menu
          basket                  view basket
          add [item name]         add item to basket
          remove [item name]      remove item from basket
          checkout                complete order
        COMMANDS
        expect(@order.help).to eq(expected)
      end
    end

    describe "#menu" do
      it "returns 'Menu not loaded'" do
        expect(@order.menu).to eq("Menu not loaded")
      end
    end

    describe "#basket" do
      it "returns 'Your basket is empty'" do
        expect(@order.basket).to eq("Your basket is empty")
      end
    end

    describe "#add" do
      context "given an empty string" do
        it "returns 'Item not found in menu'" do
          expect(@order.add("")).to eq("Item not found in menu")
        end
      end
    end

    describe "#remove" do
      context "given an empty string" do
        it "returns 'Item not found in basket'" do
          expect(@order.remove("")).to eq("Item not found in basket")
        end
      end
    end

    describe "#checkout" do
      it "returns 'Cannot checkout an empty basket'" do
        expect(@order.checkout).to eq("Cannot checkout an empty basket")
      end
    end
  end

  context "given items added to menu" do

    before(:each) do
      menu = [
        { "name" => "burger", "price" => 500 },
        { "name" => "pizza", "price" => 700 },
        { "name" => "pasta", "price" => 600 },
        { "name" => "curry", "price" => 550 },
        { "name" => "fajitas", "price" => 650 }
      ]

      @order.load(menu)
    end

    describe "#menu" do
      it "returns a formatted menu" do
        expected = "---MENU---\nBurger - £5.00\nPizza - £7.00\nPasta - £6.00\nCurry - £5.50\nFajitas - £6.50\n----------"
        expect(@order.menu).to eq(expected)
      end
    end

    describe "#add" do
      it "adds item to basket" do
        expect(@order.add("pizza")).to eq("Added 1 x Pizza to basket")
      end
    end

    context "given unique items added to basket" do
      describe "#basket" do
        it "returns a formatted basket" do
          @order.add("pizza")
          @order.add("pasta")
          expected = "--BASKET--\n1 x Pizza = £7.00\n1 x Pasta = £6.00\nTotal = £13.00\n----------"
          expect(@order.basket).to eq expected
        end
      end
    end

    context "given duplicate items added to basket" do
      describe "#basket" do
        it "returns a formatted basket" do
          @order.add("pizza")
          @order.add("pasta")
          @order.add("curry")
          @order.add("pasta")
          expected = "--BASKET--\n1 x Pizza = £7.00\n2 x Pasta = £12.00\n1 x Curry = £5.50\nTotal = £24.50\n----------"
          expect(@order.basket).to eq(expected)
        end
      end
    end

    context "given a single item added the basket" do
      describe "#remove" do
        it "returns item from basket" do
          @order.add("pizza")
          expect(@order.remove("pizza")).to eq("Removed 1 x Pizza from basket")
        end
      end

      describe "#checkout" do
        it "returns message string with delivery time 1 hour from now" do
          @order.add("pizza")
          time = Time.new(2023, 1, 27, 10, 40, 10)
          expect(@order.complete?).to be(false)
          message = double
          body = "Thank you! Your order was placed and will be delivered before 11:40"
          expect(message).to receive(:dispatch).with(body)
          result = @order.checkout(time, message)
          expect(result).to eq(body)
          expect(@order.complete?).to be(true)
        end
      end
    end
  end
end
