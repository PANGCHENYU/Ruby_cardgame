class ButtonHandler
    def initialize(game_window)
      @game_window = game_window
    end
  
    def handle_button_click(id)
      case id
      when Gosu::MsLeft
        if !@game_window.instance_variable_get(:@game_started)
          handle_start_button_click(@game_window.mouse_x, @game_window.mouse_y)
        else
          handle_mouse_click(@game_window.mouse_x, @game_window.mouse_y)
          handle_rules_button_click(@game_window.mouse_x, @game_window.mouse_y)
        end
      when Gosu::MsRight
        handle_exchange if @game_window.instance_variable_get(:@game_started)
      when Gosu::KbEscape
        @game_window.instance_variable_set(:@show_rules, false) if @game_window.instance_variable_get(:@show_rules)
      when Gosu::KbSpace
        @game_window.play_selected_cards if @game_window.instance_variable_get(:@game_started)
      end
    end
  
    private
  
    def handle_start_button_click(x, y)
      if x >= (@game_window.class::WIDTH - @game_window.instance_variable_get(:@start_button).width) / 2 &&
         x <= (@game_window.class::WIDTH + @game_window.instance_variable_get(:@start_button).width) / 2 &&
         y >= (@game_window.class::HEIGHT - @game_window.instance_variable_get(:@start_button).height) / 2 &&
         y <= (@game_window.class::HEIGHT + @game_window.instance_variable_get(:@start_button).height) / 2
        @game_window.instance_variable_set(:@game_started, true)
      end
    end
  
    def handle_rules_button_click(x, y)
      if x >= 20 && x <= 20 + @game_window.instance_variable_get(:@rules_button).width &&
         y >= 60 && y <= 60 + @game_window.instance_variable_get(:@rules_button).height
        @game_window.instance_variable_set(:@show_rules, true)
      end
    end
  
    def handle_mouse_click(x, y)
      @game_window.instance_variable_get(:@player).hand.each_with_index do |card, index|
        card_x, card_y = @game_window.instance_variable_get(:@player).hand_positions[index]
        if x >= card_x && x <= card_x + GameWindow::CARD_WIDTH &&
           y >= card_y && y <= card_y + GameWindow::CARD_HEIGHT
          if @game_window.instance_variable_get(:@selected_cards).include?(card)
            @game_window.instance_variable_get(:@selected_cards).delete(card)
          else
            if @game_window.instance_variable_get(:@selected_cards).size < 5
              @game_window.instance_variable_get(:@selected_cards) << card
            end
          end
          break
        end
      end
    end
  
    def handle_exchange
      return if @game_window.instance_variable_get(:@selected_cards).empty?
  
      @game_window.instance_variable_get(:@selected_cards).each do |card|
        @game_window.instance_variable_get(:@player).exchange_card(card)
      end
  
      @game_window.instance_variable_get(:@selected_cards).clear
    end
  end
  