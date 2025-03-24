module UIHelpers
    def draw_start_button
      x = (WIDTH - @start_button.width) / 2
      y = (HEIGHT - @start_button.height) / 2
      @start_button.draw(x, y, 1)
    end
  
    def draw_game_info
      round_text = "Round: #{6 - @turns_left}"
      draw_text(round_text, 20, 20)
  
      @rules_button.draw(20, 60, 1)
  
      score_text = "Score: #{@total_score}"
      draw_text(score_text, 20, 100)
  
      remaining_text = "Cards Left: #{@deck.cards_left}"
      draw_text(remaining_text, 20, 140)
    end
  
    def draw_player_hand
      @player.hand_images.each_with_index do |image, index|
        x, y = @player.hand_positions[index]
        y -= 20 if @selected_cards.include?(@player.hand[index])
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
  
    def draw_text(text, x, y, size = 20)
      image = Gosu::Image.from_text(text, size, font: Gosu.default_font_name)
      image.draw(x, y, 1)
    end
  end
  