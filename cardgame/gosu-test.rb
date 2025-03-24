require 'gosu'

class Card
  attr_reader :image, :x, :y

  def initialize(window, image_path, x, y)
    @image = Gosu::Image.new(window, image_path, false)
    @x = x
    @y = y
  end

  def draw
    @image.draw(@x, @y, 1)
  end

  def contains_point?(mouse_x, mouse_y)
    mouse_x >= @x && mouse_x <= @x + @image.width &&
    mouse_y >= @y && mouse_y <= @y + @image.height
  end

  def move_to(new_x, new_y)
    @x = new_x
    @y = new_y
  end
end

class GameWindow < Gosu::Window
  def initialize
    super 640, 480
    self.caption = "Simple Card Game"

    @cards = []
    @selected_card = nil

    # 加载一张卡牌图像并将其放置在窗口中央
    @cards << Card.new(self, "A.png", 270, 190)
  end

  def update
    if Gosu.button_down?(Gosu::MS_LEFT)
      if @selected_card.nil?
        @cards.each do |card|
          if card.contains_point?(mouse_x, mouse_y)
            @selected_card = card
            break
          end
        end
      else
        @selected_card.move_to(mouse_x - @selected_card.image.width / 2, mouse_y - @selected_card.image.height / 2)
      end
    else
      @selected_card = nil
    end
  end

  def draw
    @cards.each(&:draw)
  end
end

window = GameWindow.new
window.show
