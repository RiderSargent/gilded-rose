require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  describe "#update_quality" do
    let(:items) { [ Item.new("foo", 0, 0) ] }

    subject { GildedRose.new(items).update_quality }

    it "does not change the name" do
      expect { subject }.to_not change { items.first.name }
    end

    context "normal items" do
      let(:items) { [ Item.new("Elixir of the Mongoose", sell_in, quality) ] }
      let(:quality) { 7 }

      context "before sell date" do
        let(:sell_in) { 10 }

        it "reduces sell_in by 1" do
          expect { subject }.to change { items.first.sell_in }.by(-1)
        end

        it "reduces quality by 1" do
          expect { subject }.to change { items.first.quality }.by(-1)
        end

        context "of zero quality" do
          let(:quality) { 0 }

          it "reduces sell_in by 1" do
            expect { subject }.to change { items.first.sell_in }.by(-1)
          end

          it "does not reduce quality beyond the minimum value" do
            expect { subject }.to_not change { items.first.quality }
          end
        end
      end

      context "on sell date" do
        let(:sell_in) { 0 }

        it "reduces sell_in by 1" do
          expect { subject }.to change { items.first.sell_in }.by(-1)
        end

        it "reduces quality by 2" do
          expect { subject }.to change { items.first.quality }.by(-2)
        end

        context "of zero quality" do
          let(:quality) { 0 }

          it "reduces sell_in by 1" do
            expect { subject }.to change { items.first.sell_in }.by(-1)
          end

          it "does not reduce quality beyond the minimum value" do
            expect { subject }.to_not change { items.first.quality }
          end
        end
      end

      context "after sell date" do
        let(:sell_in) { -10 }

        it "reduces sell_in by 1" do
          expect { subject }.to change { items.first.sell_in }.by(-1)
        end

        it "reduces quality by 2" do
          expect { subject }.to change { items.first.quality }.by(-2)
        end

        context "of zero quality" do
          let(:quality) { 0 }

          it "reduces sell_in by 1" do
            expect { subject }.to change { items.first.sell_in }.by(-1)
          end

          it "does not reduce quality beyond the minimum value" do
            expect { subject }.to_not change { items.first.quality }
          end
        end
      end
    end

    context "Aged Brie" do
      let(:items) { [ Item.new("Aged Brie", sell_in, quality) ] }
      let(:quality) { 7 }

      context "before sell date" do
        let(:sell_in) { 10 }

        it "reduces sell_in by 1" do
          expect { subject }.to change { items.first.sell_in }.by(-1)
        end

        it "increases quality by 1" do
          expect { subject }.to change { items.first.quality }.by(1)
        end

        context "at max quality" do
          let(:quality) { 50 }

          it "reduces sell_in by 1" do
            expect { subject }.to change { items.first.sell_in }.by(-1)
          end

          it "does not increase quality beyond the maximum value" do
            expect { subject }.to_not change { items.first.quality }
          end
        end
      end

      context "on sell date" do
        let(:sell_in) { 0 }

        it "reduces sell_in by 1" do
          expect { subject }.to change { items.first.sell_in }.by(-1)
        end

        it "increases quality by 2" do
          expect { subject }.to change { items.first.quality }.by(2)
        end

        context "near max quality" do
          let(:quality) { 49 }

          it "reduces sell_in by 1" do
            expect { subject }.to change { items.first.sell_in }.by(-1)
          end

          it "increases quality to the maximum value"  do
            expect { subject }.to change { items.first.quality }.to(50)
          end
        end

        context "at max quality" do
          let(:quality) { 50 }

          it "reduces sell_in by 1" do
            expect { subject }.to change { items.first.sell_in }.by(-1)
          end

          it "does not increase quality beyond the maximum value" do
            expect { subject }.to_not change { items.first.quality }
          end
        end
      end

      context "after sell date" do
        let(:sell_in) { -10 }

        it "reduces sell_in by 1" do
          expect { subject }.to change { items.first.sell_in }.by(-1)
        end

        it "increases quality by 2" do
          expect { subject }.to change { items.first.quality }.by(2)
        end

        context "near max quality" do
          let(:quality) { 49 }

          it "reduces sell_in by 1" do
            expect { subject }.to change { items.first.sell_in }.by(-1)
          end

          it "increases quality to the maximum value"  do
            expect { subject }.to change { items.first.quality }.to(50)
          end
        end

        context "at max quality" do
          let(:quality) { 50 }

          it "reduces sell_in by 1" do
            expect { subject }.to change { items.first.sell_in }.by(-1)
          end

          it "does not increase quality beyond the maximum value" do
            expect { subject }.to_not change { items.first.quality }
          end
        end
      end
    end

    context "Sulfuras, Hand of Ragnaros" do
      let(:items) { [ Item.new("Sulfuras, Hand of Ragnaros", sell_in, quality) ] }
      let(:quality) { 80 }

      context "before sell date" do
        let(:sell_in) { 10 }

        it "does not change sell_in" do
          expect { subject }.to_not change { items.first.sell_in }
        end

        it "does not change quality" do
          expect { subject }.to_not change { items.first.quality }
        end
      end

      context "on sell date" do
        let(:sell_in) { 0 }

        it "does not change sell_in" do
          expect { subject }.to_not change { items.first.sell_in }
        end

        it "does not change quality" do
          expect { subject }.to_not change { items.first.quality }
        end
      end

      context "after sell date" do
        let(:sell_in) { -10 }

        it "does not change sell_in" do
          expect { subject }.to_not change { items.first.sell_in }
        end

        it "does not change quality" do
          expect { subject }.to_not change { items.first.quality }
        end
      end
    end

    context "Backstage passes to a TAFKAL80ETC concert" do
      let(:items) { [ Item.new("Backstage passes to a TAFKAL80ETC concert", sell_in, quality) ] }
      let(:quality) { 10 }

      context "more than ten days before sell date" do
        let(:sell_in) { 15 }

        it "reduces sell_in by 1" do
          expect { subject }.to change { items.first.sell_in }.by(-1)
        end

        it "increases quality by 1" do
          expect { subject }.to change { items.first.quality }.by(1)
        end

        context "at max quality" do
          let(:quality) { 50 }

          it "reduces sell_in by 1" do
            expect { subject }.to change { items.first.sell_in }.by(-1)
          end

          it "does not increase quality beyond the maximum value" do
            expect { subject }.to_not change { items.first.quality }
          end
        end
      end

      context "ten days before sell date" do
        let(:sell_in) { 10 }

        it "reduces sell_in by 1" do
          expect { subject }.to change { items.first.sell_in }.by(-1)
        end

        it "increases quality by 2" do
          expect { subject }.to change { items.first.quality }.by(2)
        end

        context "at max quality" do
          let(:quality) { 50 }

          it "reduces sell_in by 1" do
            expect { subject }.to change { items.first.sell_in }.by(-1)
          end

          it "does not increase quality beyond the maximum value" do
            expect { subject }.to_not change { items.first.quality }
          end
        end
      end

      context "six days before sell date" do
        let(:sell_in) { 6 }

        it "reduces sell_in by 1" do
          expect { subject }.to change { items.first.sell_in }.by(-1)
        end

        it "increases quality by 2" do
          expect { subject }.to change { items.first.quality }.by(2)
        end

        context "at max quality" do
          let(:quality) { 50 }

          it "reduces sell_in by 1" do
            expect { subject }.to change { items.first.sell_in }.by(-1)
          end

          it "does not increase quality beyond the maximum value" do
            expect { subject }.to_not change { items.first.quality }
          end
        end
      end

      context "five days before sell date" do
        let(:sell_in) { 5 }

        it "reduces sell_in by 1" do
          expect { subject }.to change { items.first.sell_in }.by(-1)
        end

        it "increases quality by 3" do
          expect { subject }.to change { items.first.quality }.by(3)
        end

        context "at max quality" do
          let(:quality) { 50 }

          it "reduces sell_in by 1" do
            expect { subject }.to change { items.first.sell_in }.by(-1)
          end

          it "does not increase quality beyond the maximum value" do
            expect { subject }.to_not change { items.first.quality }
          end
        end
      end

      context "one day before sell date" do
        let(:sell_in) { 1 }

        it "reduces sell_in by 1" do
          expect { subject }.to change { items.first.sell_in }.by(-1)
        end

        it "increases quality by 3" do
          expect { subject }.to change { items.first.quality }.by(3)
        end

        context "at max quality" do
          let(:quality) { 50 }

          it "reduces sell_in by 1" do
            expect { subject }.to change { items.first.sell_in }.by(-1)
          end

          it "does not increase quality beyond the maximum value" do
            expect { subject }.to_not change { items.first.quality }
          end
        end
      end

      context "on sell date" do
        let(:sell_in) { 0 }

        it "reduces sell_in by 1" do
          expect { subject }.to change { items.first.sell_in }.by(-1)
        end

        it "reduces quality to 0" do
          expect { subject }.to change { items.first.quality }.to(0)
        end
      end

      context "after sell date" do
        let(:sell_in) { -10 }

        it "reduces sell_in by 1" do
          expect { subject }.to change { items.first.sell_in }.by(-1)
        end

        it "reduces quality to 0" do
          expect { subject }.to change { items.first.quality }.to(0)
        end
      end
    end

    context "Conjured" do
      let(:items) { [ Item.new("Conjured", sell_in, quality) ] }
      let(:quality) { 7 }

      context "before sell date" do
        let(:sell_in) { 10 }

        it "reduces sell_in by 1" do
          expect { subject }.to change { items.first.sell_in }.by(-1)
        end

        it "reduces quality by 2" do
          expect { subject }.to change { items.first.quality }.by(-2)
        end

        context "of zero quality" do
          let(:quality) { 0 }

          it "reduces sell_in by 1" do
            expect { subject }.to change { items.first.sell_in }.by(-1)
          end

          it "does not reduce quality beyond the minimum value" do
            expect { subject }.to_not change { items.first.quality }
          end
        end
      end

      context "on sell date" do
        let(:sell_in) { 0 }

        it "reduces sell_in by 1" do
          expect { subject }.to change { items.first.sell_in }.by(-1)
        end

        it "reduces quality by 4" do
          expect { subject }.to change { items.first.quality }.by(-4)
        end

        context "of zero quality" do
          let(:quality) { 0 }

          it "reduces sell_in by 1" do
            expect { subject }.to change { items.first.sell_in }.by(-1)
          end

          it "does not reduce quality beyond the minimum value" do
            expect { subject }.to_not change { items.first.quality }
          end
        end
      end

      context "after sell date" do
        let(:sell_in) { -10 }

        it "reduces sell_in by 1" do
          expect { subject }.to change { items.first.sell_in }.by(-1)
        end

        it "reduces quality by 4" do
          expect { subject }.to change { items.first.quality }.by(-4)
        end

        context "of zero quality" do
          let(:quality) { 0 }

          it "reduces sell_in by 1" do
            expect { subject }.to change { items.first.sell_in }.by(-1)
          end

          it "does not reduce quality beyond the minimum value" do
            expect { subject }.to_not change { items.first.quality }
          end
        end
      end
    end
  end
end
