require_relative "../lib/item_list"

describe ItemList do
  before(:each) do
    @item_list = ItemList.new
  end

  context "initially" do
    it "returns an empty array" do
      expect(@item_list.items).to eq []
    end

    describe "#empty?" do
      it "returns true" do
        expect(@item_list.empty?).to be true
      end
    end

    describe "#total" do
      it "returns 0" do
        expect(@item_list.total).to eq 0
      end
    end

    describe "#find" do
      context "given an empty string" do
        it "returns nil" do
          expect(@item_list.find("")).to eq nil
        end
      end
    end

    describe "#remove" do
      context "given an empty string" do
        it "returns nil" do
          expect(@item_list.remove("")).to eq nil
        end
      end
    end
  end

  context "given items added" do
    before(:each) do
      @item_1 = double(name: "pizza", price: 500)
      @item_2 = double(name: "pasta", price: 600)
      @item_3 = double(name: "steak", price: 700)
      @item_list.add(@item_1)
      @item_list.add(@item_2)
      @item_list.add(@item_3)
    end

    it "returns array of added items" do
      expect(@item_list.items).to eq [@item_1, @item_2, @item_3]
    end

    describe "#empty?" do
      it "returns false" do
        expect(@item_list.empty?).to be false
      end
    end

    describe "#total" do
      it "returns sum of items price" do
        expect(@item_list.total).to eq 1800
      end
    end

    describe "#find" do
      context "given 'pasta'" do
        it "returns corresponding object" do
          expect(@item_list.find("pasta")).to eq @item_2
        end
      end
    end

    describe "#remove" do
      context "given 'pasta'" do
        it "returns deleted object and removed object from items" do
          expect(@item_list.remove("pasta")).to eq @item_2
          expect(@item_list.items).to eq [@item_1, @item_3]
        end
      end
    end
  end
end
