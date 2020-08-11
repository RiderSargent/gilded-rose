require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  # All items have a SellIn value which denotes the number of days we have to sell the item
  # All items have a Quality value which denotes how valuable the item is
  # At the end of each day our system lowers both values for every item

  # Once the sell by date has passed, Quality degrades twice as fast
  # The Quality of an item is never negative

  # "Aged Brie" actually increases in Quality the older it gets
  # The Quality of an item is never more than 50

  # "Sulfuras", being a legendary item, never has to be sold or decreases in Quality
  #   "Sulfuras" is a legendary item and as such its Quality is 80 and it never alters.

  # "Backstage passes", like aged brie, increases in Quality as its SellIn value approaches;
  #   Quality increases by 2 when there are 10 days or less and by 3 when there are 5 days or less but
  #   Quality drops to 0 after the concert

  # New Req: "Conjured" items degrade in Quality twice as fast as normal items

  describe "#update_quality" do
    let(:items) { [ Item.new("foo", 0, 0) ] }

    subject { GildedRose.new(items).update_quality() }

    it "does not change the name" do
      subject
      expect(items[0].name).to eq "foo"
    end

    context "normal items" do
      let(:items) { [ Item.new("Elixir of the Mongoose", sell_in, quality) ] }
      let(:quality) { 7 }

      context "before sell date" do
        let(:sell_in) { 10 }

        it "reduces sell_in by 1 and quality by 1", :aggregate_failures do
          subject

          expect(items.first.sell_in).to eq(sell_in - 1)
          expect(items.first.quality).to eq(quality - 1)
        end

        context "of zero quality" do
          let(:quality) { 0 }

          it "reduces sell_in by 1 and does not reduce quality beyond the minimum value", :aggregate_failures do
            subject

            expect(items.first.sell_in).to eq(sell_in - 1)
            expect(items.first.quality).to eq(quality)
          end
        end
      end

      context "on sell date" do
        let(:sell_in) { 0 }

        it "reduces sell_in by 1 and quality by 2", :aggregate_failures do
          subject

          expect(items.first.sell_in).to eq(sell_in - 1)
          expect(items.first.quality).to eq(quality - 2)
        end

        context "of zero quality" do
          let(:quality) { 0 }

          it "reduces sell_in by 1 and does not reduce quality beyond the minimum value", :aggregate_failures do
            subject

            expect(items.first.sell_in).to eq(sell_in - 1)
            expect(items.first.quality).to eq(quality)
          end
        end
      end

      context "after sell date" do
        let(:sell_in) { -10 }

        it "reduces sell_in by 1 and quality by 2", :aggregate_failures do
          subject

          expect(items.first.sell_in).to eq(sell_in - 1)
          expect(items.first.quality).to eq(quality - 2)
        end

        context "of zero quality" do
          let(:quality) { 0 }

          it "reduces sell_in by 1 and does not reduce quality beyond the minimum value", :aggregate_failures do
            subject

            expect(items.first.sell_in).to eq(sell_in - 1)
            expect(items.first.quality).to eq(quality)
          end
        end
      end
    end

    context "Aged Brie" do
      let(:items) { [ Item.new("Aged Brie", sell_in, quality) ] }
      let(:quality) { 7 }

      context "before sell date" do
        let(:sell_in) { 10 }

        it "reduces sell_in by 1 and increases quality by 1", :aggregate_failures do
          subject

          expect(items.first.sell_in).to eq(sell_in - 1)
          expect(items.first.quality).to eq(quality + 1)
        end

        context "at max quality" do
          let(:quality) { 50 }

          it "reduces sell_in by 1 and does not increase quality beyond the maximum value", :aggregate_failures do
            subject

            expect(items.first.sell_in).to eq(sell_in - 1)
            expect(items.first.quality).to eq(quality)
          end
        end
      end

      context "on sell date" do
        let(:sell_in) { 0 }

        it "reduces sell_in by 1 and increases quality by 2", :aggregate_failures do
          subject

          expect(items.first.sell_in).to eq(sell_in - 1)
          expect(items.first.quality).to eq(quality + 2)
        end

        context "near max quality" do
          let(:quality) { 49 }

          it "reduces sell_in by 1 and increases quality to the maximum value", :aggregate_failures do
            subject

            expect(items.first.sell_in).to eq(sell_in - 1)
            expect(items.first.quality).to eq(50)
          end
        end

        context "at max quality" do
          let(:quality) { 50 }

          it "reduces sell_in by 1 and does not increase quality beyond the maximum value", :aggregate_failures do
            subject

            expect(items.first.sell_in).to eq(sell_in - 1)
            expect(items.first.quality).to eq(50)
          end
        end
      end

      context "after sell date" do
        let(:sell_in) { -10 }

        it "reduces sell_in by 1 and increases quality by 2", :aggregate_failures do
          subject

          expect(items.first.sell_in).to eq(sell_in - 1)
          expect(items.first.quality).to eq(quality + 2)
        end

        context "near max quality" do
          let(:quality) { 49 }

          it "reduces sell_in by 1 and increases quality the maximum value", :aggregate_failures do
            subject

            expect(items.first.sell_in).to eq(sell_in - 1)
            expect(items.first.quality).to eq(50)
          end
        end

        context "at max quality" do
          let(:quality) { 50 }

          it "reduces sell_in by 1 and does not increase quality beyond the maximum value", :aggregate_failures do
            subject

            expect(items.first.sell_in).to eq(sell_in - 1)
            expect(items.first.quality).to eq(50)
          end
        end
      end
    end

    context "Sulfuras, Hand of Ragnaros" do
      let(:items) { [ Item.new("Sulfuras, Hand of Ragnaros", sell_in, quality) ] }
      let(:quality) { 80 }

      context "before sell date" do
        let(:sell_in) { 10 }

        it "does not change sell_in or quality", :aggregate_failures do
          subject

          expect(items.first.sell_in).to eq(sell_in)
          expect(items.first.quality).to eq(quality)
        end
      end

      context "on sell date" do
        let(:sell_in) { 0 }

        it "does not change sell_in or quality", :aggregate_failures do
          subject

          expect(items.first.sell_in).to eq(sell_in)
          expect(items.first.quality).to eq(quality)
        end
      end

      context "after sell date" do
        let(:sell_in) { -10 }

        it "does not change sell_in or quality", :aggregate_failures do
          subject

          expect(items.first.sell_in).to eq(sell_in)
          expect(items.first.quality).to eq(quality)
        end
      end
    end

    context "Backstage passes to a TAFKAL80ETC concert" do
      let(:items) { [ Item.new("Backstage passes to a TAFKAL80ETC concert", sell_in, quality) ] }
      let(:quality) { 10 }

      context "more than ten days before sell date" do
        let(:sell_in) { 15 }

        it "reduces sell_in by 1 and increases quality by 1", :aggregate_failures do
          subject

          expect(items.first.sell_in).to eq(sell_in - 1)
          expect(items.first.quality).to eq(quality + 1)
        end

        context "at max quality" do
          let(:quality) { 50 }

          it "reduces sell_in by 1 and does not increase quality beyond the maximum value", :aggregate_failures do
            subject

            expect(items.first.sell_in).to eq(sell_in - 1)
            expect(items.first.quality).to eq(quality)
          end
        end
      end

      context "ten days before sell date" do
        let(:sell_in) { 10 }

        it "reduces sell_in by 1 and increases quality by 2", :aggregate_failures do
          subject

          expect(items.first.sell_in).to eq(sell_in - 1)
          expect(items.first.quality).to eq(quality + 2)
        end

        context "at max quality" do
          let(:quality) { 50 }

          it "reduces sell_in by 1 and does not increase quality beyond the maximum value", :aggregate_failures do
            subject

            expect(items.first.sell_in).to eq(sell_in - 1)
            expect(items.first.quality).to eq(quality)
          end
        end
      end

      context "six days before sell date" do
        let(:sell_in) { 6 }

        it "reduces sell_in by 1 and increases quality by 2", :aggregate_failures do
          subject

          expect(items.first.sell_in).to eq(sell_in - 1)
          expect(items.first.quality).to eq(quality + 2)
        end

        context "at max quality" do
          let(:quality) { 50 }

          it "reduces sell_in by 1 and does not increase quality beyond the maximum value", :aggregate_failures do
            subject

            expect(items.first.sell_in).to eq(sell_in - 1)
            expect(items.first.quality).to eq(quality)
          end
        end
      end

      context "five days before sell date" do
        let(:sell_in) { 5 }

        it "reduces sell_in by 1 and increases quality by 3", :aggregate_failures do
          subject

          expect(items.first.sell_in).to eq(sell_in - 1)
          expect(items.first.quality).to eq(quality + 3)
        end

        context "at max quality" do
          let(:quality) { 50 }

          it "reduces sell_in by 1 and does not increase quality beyond the maximum value", :aggregate_failures do
            subject

            expect(items.first.sell_in).to eq(sell_in - 1)
            expect(items.first.quality).to eq(quality)
          end
        end
      end

      context "one day before sell date" do
        let(:sell_in) { 1 }

        it "reduces sell_in by 1 and increases quality by 3", :aggregate_failures do
          subject

          expect(items.first.sell_in).to eq(sell_in - 1)
          expect(items.first.quality).to eq(quality + 3)
        end

        context "at max quality" do
          let(:quality) { 50 }

          it "reduces sell_in by 1 and does not increase quality beyond the maximum value", :aggregate_failures do
            subject

            expect(items.first.sell_in).to eq(sell_in - 1)
            expect(items.first.quality).to eq(quality)
          end
        end
      end

      context "on sell date" do
        let(:sell_in) { 0 }

        it "reduces sell_in by 1 and reduces quality to 0", :aggregate_failures do
          subject

          expect(items.first.sell_in).to eq(sell_in - 1)
          expect(items.first.quality).to eq(0)
        end
      end

      context "after sell date" do
        let(:sell_in) { -10 }

        it "reduces sell_in by 1 and reduces quality to 0", :aggregate_failures do
          subject

          expect(items.first.sell_in).to eq(sell_in - 1)
          expect(items.first.quality).to eq(0)
        end
      end
    end
  end
end
