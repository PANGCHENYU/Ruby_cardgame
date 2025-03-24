require 'gosu'
require_relative 'card'
require_relative 'deck'
require_relative 'player'
require_relative 'rule'

class GameWindow < Gosu::Window
  WIDTH = 800
  HEIGHT = 600

  CARD_WIDTH = 127
  CARD_HEIGHT = 163

  def initialize
    super WIDTH, HEIGHT
    self.caption = "Card Game"

    @background_color = Gosu::Color.new(0xff_006400)  # 深绿色背景
    @deck = Deck.new
    @player = Player.new(@deck)
    @turns_left = 5
    @total_score = 0
    @selected_cards = []
    @game_started = false
    @show_rules = false

     # 新增变量
     @show_score_process = false
     @score_display_start_time = 0
     @score_message = ""
     @calculation_details = ""  # 用于保存详细的计算过程
     @exchange_message = "Exchanges left: #{@player.exchange_count}"  # 用于显示剩余交换次数

    # 初始化按钮
    @start_button = Gosu::Image.from_text("Game Start", 40, font: Gosu.default_font_name, size: 40)
    @rules_button = Gosu::Image.from_text("Rules", 20, font: Gosu.default_font_name, size: 20)
  end

  def update
    if @game_started

      # 检查是否需要隐藏分数显示
      if @show_score_process && (Gosu.milliseconds - @score_display_start_time > 5000)
        @show_score_process = false
      end
    end
  end

  def update
    if @game_started
      # 游戏更新逻辑
    end
  end

  def draw
    draw_background
    if @show_rules
      draw_rules_screen
    elsif !@game_started
      draw_start_button
    else
      draw_game_info
      draw_player_hand

   

      # 显示分数计算过程
      draw_score_process if @show_score_process
    end
  end

  def button_down(id)
    case id
    when Gosu::MsLeft
      if !@game_started
        handle_start_button_click(mouse_x, mouse_y)
      else
        handle_mouse_click(mouse_x, mouse_y)
        handle_rules_button_click(mouse_x, mouse_y)
      end
    when Gosu::MsRight
      handle_exchange if @game_started  # 处理鼠标右键交换功能
    when Gosu::KbEscape
      @show_rules = false if @show_rules
    when Gosu::KbSpace
      play_selected_cards if @game_started
    end
  end

  def handle_exchange
    return if @selected_cards.empty?

    # 对选中的牌执行交换
    @selected_cards.each do |card|
      @player.exchange_card(card)
    end

    # 清空已选中的牌
    @selected_cards.clear
  end

  def draw_background
    draw_quad(0, 0, @background_color, WIDTH, 0, @background_color, WIDTH, HEIGHT, @background_color, 0, HEIGHT, @background_color)
  end

  def draw_start_button
    x = (WIDTH - @start_button.width) / 2
    y = (HEIGHT - @start_button.height) / 2
    @start_button.draw(x, y, 1)
  end

  def draw_game_info
    # 显示第几局
    round_text = "Round: #{6 - @turns_left}"
    draw_text(round_text, 20, 20)

    # 显示规则按钮
    @rules_button.draw(20, 60, 1)

    # 显示玩家现有分数
    score_text = "Score: #{@total_score}"
    draw_text(score_text, 20, 100)

    # 显示牌组剩余牌数
    remaining_text = "Cards Left: #{@deck.cards_left}"
    draw_text(remaining_text, 20, 140)

    # 显示剩余交换次数
    exchange_text = "exchange: #{@player.exchange_count}"
    draw_text(exchange_text, 20, 180)
  end

  def draw_player_hand
    @player.hand_images.each_with_index do |image, index|
      x, y = @player.hand_positions[index]
      if @selected_cards.include?(@player.hand[index])
        y -= 20 # 将选中的卡牌上移一格
      end
      image.draw(x, y, 1)
    end
  end

  def draw_rules_screen
    rules_text = <<~TEXT
     Rules:
      1. When there is only one pair of cards with the same score 
      among the cards played, (10+a+c) * 2 points are earned.
      2. When there are only two pairs of cards with the same score 
      among the cards played, (20+a+c+b+d) * 2 points are obtained.
      3. When there are only three cards with the same score among 
      the cards played, (30+a+b+c) * 3 points are earned.
      4. When only five of the cards played have consecutive points, 
      (30+a+b+c+d+e) * 4 points are obtained.
      5. When there are only four cards with the same score among the 
      cards played, (40+a+b+c) * 5 points are earned.
      6. When only five of the cards played have consecutive numbers 
      of points and have the same color, (100+a+b+c+d+e) * 8 points are obtained.
      7. When the played cards do not follow the above rules, obtain 
        the highest points among the played cards。
    TEXT

    draw_quad(50, 50, Gosu::Color::BLUE, WIDTH - 50, 50, Gosu::Color::BLUE, WIDTH - 50, HEIGHT - 50, Gosu::Color::BLUE, 50, HEIGHT - 50, Gosu::Color::WHITE)
    draw_text(rules_text, 60, 60, 20)
  end

  def handle_start_button_click(x, y)
    if x >= (WIDTH - @start_button.width) / 2 && x <= (WIDTH + @start_button.width) / 2 &&
       y >= (HEIGHT - @start_button.height) / 2 && y <= (HEIGHT + @start_button.height) / 2
      @game_started = true
    end
  end

  def handle_rules_button_click(x, y)
    if x >= 20 && x <= 20 + @rules_button.width && y >= 60 && y <= 60 + @rules_button.height
      @show_rules = true
    end
  end

  def handle_mouse_click(x, y)
    @player.hand.each_with_index do |card, index|
      card_x, card_y = @player.hand_positions[index]
      if x >= card_x && x <= card_x + CARD_WIDTH &&
         y >= card_y && y <= card_y + CARD_HEIGHT
        if @selected_cards.include?(card)
          @selected_cards.delete(card)
        else
          if @selected_cards.size < 5
            @selected_cards << card
          end
        end
        break
      end
    end
  end

  def play_selected_cards
    if @selected_cards.size > 0
      score, @calculation_details = calculate_score(@selected_cards)  # 获取分数和计算过程
      @player.add_to_score(score)
      @player.play_cards(@selected_cards)
      @total_score += score

      # 设置分数计算过程的显示
      @score_message = "Scoring: #{score} (#{@calculation_details})"
      @show_score_process = true
      @score_display_start_time = Gosu.milliseconds

      @selected_cards.clear
      next_turn
    end
  end

  # 绘制分数计算过程
  def draw_score_process
    draw_text(@score_message, WIDTH / 2 - 220, HEIGHT / 2 - 50, 30)
  end

  def next_turn
    if @turns_left > 0
      @turns_left -= 1
      @player.draw_cards(7 - @player.hand.size)
      @player.reset_exchange_count  # 每局重置交换次数
    else
      end_game
    end
  end

  def end_game
    if @total_score >= 1000
      puts "Game Clear! Total Score: #{@total_score}"
    else
      puts "Game Over! Total Score: #{@total_score}"
    end
    close
  end

  private

  def draw_text(text, x, y, size = 20)
    image = Gosu::Image.from_text(text, size, font: Gosu.default_font_name)
    image.draw(x, y, 1)
  end
end

window = GameWindow.new
window.show
