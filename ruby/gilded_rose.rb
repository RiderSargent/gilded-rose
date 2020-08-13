class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      case item.name
      when "Aged Brie"
        return update_quality_brie(item)
      when "Sulfuras, Hand of Ragnaros"
        return update_quality_sulfuras(item)
      when "Backstage passes to a TAFKAL80ETC concert"
        return update_quality_backstage_passes(item)
      else
        return update_quality_normal(item)
      end
    end
  end

  private

  def update_quality_normal(item)
    item.sell_in -= 1

    return if item.quality <= 0

    item.quality -= 1
    item.quality -= 1 if item.sell_in <= 0
  end

  def update_quality_brie(item)
    item.sell_in -= 1

    item.quality += 1 if item.quality < 50
    item.quality += 1 if item.sell_in <= 0 && item.quality < 50
  end

  def update_quality_sulfuras(item)
  end

  def update_quality_backstage_passes(item)
    item.sell_in -= 1

    return if item.quality >= 50
    return item.quality = 0 if item.sell_in < 0

    item.quality += 1
    item.quality += 1 if item.sell_in < 10
    item.quality += 1 if item.sell_in < 5
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end