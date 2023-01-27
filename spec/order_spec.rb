require_relative "../lib/order"

describe Order do
  context "initially" do
    describe "#complete?" do
      it "returns false" do
        order = Order.new(double, double)
        expect(order.complete?).to be(false)
      end
    end

    describe "#help" do
      it "returns commands list" do
        order = Order.new(double, double)
        expected = <<~COMMANDS
          Commands:
          help                    view commands
          menu                    view menu
          basket                  view basket
          add [item name]         add item to basket
          remove [item name]      remove item from basket
          checkout                complete order
        COMMANDS
        expect(order.help).to eq(expected)
      end
    end

    describe "#menu" do
      it "returns 'Menu not loaded'" do
        menu = double
        expect(menu).to receive(:empty?).and_return(true)
        order = Order.new(menu, double)
        expect(order.menu).to eq("Menu not loaded")
      end
    end

    describe "#basket" do
      it "returns 'Your basket is empty'" do
        basket = double
        expect(basket).to receive(:empty?).and_return(true)
        order = Order.new(double, basket)
        expect(order.basket).to eq("Your basket is empty")
      end
    end

    describe "#add" do
      context "given an empty string" do
        it "returns 'Item not found in menu'" do
          menu = double
          expect(menu).to receive(:find).and_return(nil)
          order = Order.new(menu, double)
          expect(order.add("")).to eq("Item not found in menu")
        end
      end
    end

    describe "#remove" do
      context "given an empty string" do
        it "returns 'Item not found in basket'" do
          basket = double
          expect(basket).to receive(:remove).and_return(nil)
          order = Order.new(double, basket)
          expect(order.remove("")).to eq("Item not found in basket")
        end
      end
    end

    describe "#checkout" do
      it "returns 'Cannot checkout an empty basket'" do
        basket = double
        expect(basket).to receive(:empty?).and_return(true)
        order = Order.new(double, basket)
        expect(order.checkout).to eq("Cannot checkout an empty basket")
      end
    end
  end

  context "given items added to menu" do
    describe "#menu" do
      it "returns a formatted menu" do
        menu = double
        item_1 = double(name: "pizza", price: 500)
        item_2 = double(name: "pasta", price: 600)
        expect(menu).to receive(:items).and_return([item_1, item_2])
        expect(menu).to receive(:empty?).and_return(false)
        order = Order.new(menu, double)
        expected = "---MENU---\nPizza - £5.00\nPasta - £6.00\n----------"
        expect(order.menu).to eq(expected)
      end
    end

    describe "#add" do
      it "adds item to basket" do
        menu = double
        basket = double
        item = double(name: "pizza", price: 500)
        expect(menu).to receive(:find).with("pizza").and_return(item)
        expect(basket).to receive(:add).with(item)
        order = Order.new(menu, basket)
        expect(order.add("pizza")).to eq("Added 1 x Pizza to basket")
      end
    end

    context "given unique items added to basket" do
      describe "#basket" do
        it "returns a formatted basket" do
          basket = double
          item_1 = double(name: "pizza", price: 500)
          item_2 = double(name: "pasta", price: 600)
          expect(basket).to receive(:items).and_return([item_1, item_2])
          expect(basket).to receive(:empty?).and_return(false)
          expect(basket).to receive(:total).and_return(1100)
          order = Order.new(double, basket)
          expected = "--BASKET--\n1 x Pizza = £5.00\n1 x Pasta = £6.00\nTotal = £11.00\n----------"
          expect(order.basket).to eq expected
        end
      end
    end

    context "given duplicate items added to basket" do
      describe "#basket" do
        it "returns a formatted basket" do
          basket = double
          item_1 = double(name: "pizza", price: 500)
          item_2 = double(name: "pasta", price: 600)
          item_3 = double(name: "steak", price: 700)
          expect(basket).to receive(:items).and_return([item_1, item_2, item_3, item_2])
          expect(basket).to receive(:empty?).and_return(false)
          expect(basket).to receive(:total).and_return(2400)
          order = Order.new(double, basket)
          expected = "--BASKET--\n1 x Pizza = £5.00\n2 x Pasta = £12.00\n1 x Steak = £7.00\nTotal = £24.00\n----------"
          expect(order.basket).to eq(expected)
        end
      end
    end

    context "given a single item added the basket" do
      describe "#remove" do
        it "returns item from basket" do
          basket = double
          item = double(name: "pizza", price: 500)
          expect(basket).to receive(:remove).with("pizza").and_return(item)
          order = Order.new(double, basket)
          expect(order.remove("pizza")).to eq("Removed 1 x Pizza from basket")
        end
      end

      describe "#checkout" do
        it "returns message string with delivery time 1 hour from now" do
          time = Time.new(2023, 1, 27, 10, 40, 10)
          basket = double
          expect(basket).to receive(:empty?).and_return(false)
          order = Order.new(double, basket)
          expect(order.complete?).to be(false)
          message = double
          body = "Thank you! Your order was placed and will be delivered before 11:40"
          expect(message).to receive(:dispatch).with(body)
          result = order.checkout(time, message)
          expect(result).to eq(body)
          expect(order.complete?).to be(true)
        end
      end
    end
  end
end
