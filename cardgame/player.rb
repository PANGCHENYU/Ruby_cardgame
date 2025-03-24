class Player
    attr_reader :hand, :score, :exchange_count
  
    def initialize(deck)
      @deck = deck
      @hand = []
      7.times { @hand << @deck.draw_card }
      @score = 0
      @exchange_count = 10  # 残りのカードを何枚交換できるかチェック
    end
  
    def draw_cards(num)
      num.times { @hand << @deck.draw_card }
    end
  
    def play_cards(cards)
      @hand -= cards
      @deck.discard(cards)
    end
  
    def exchange_card(card)
      return if @exchange_count <= 0  # 残りの交換回数の確認
  
      @hand.delete(card)
      @deck.return_to_deck([card])  # 選択したカードをカードライブラリに戻す
      new_card = @deck.draw_card
      @hand << new_card
  
      @exchange_count -= 1  # 交換ごとに交換回数を1回減らす
      return @exchange_count
    end
  
    def add_to_score(points)
      @score += points
    end
  
    def hand_images
      @hand.map(&:image)
    end
  
    def hand_positions
      @hand.each_index.map do |i|
        x = 50 + i * 100
        y = GameWindow::HEIGHT - 150
        [x, y]
      end
    end
  
    def reset_exchange_count
      @exchange_count = 10
    end
    
  end
  