class Deck
    def initialize
      @cards = []
      Card::SUITS.each do |suit|
        Card::RANKS.each do |rank|
          @cards << Card.new(suit, rank)
        end
      end
      @discard_pile = []
      shuffle_deck
    end
  
    def shuffle_deck
      @cards.shuffle!
    end
  
    def draw_card
      @cards.pop
    end
  
    def return_to_deck(cards)
      @cards.unshift(*cards)
      shuffle_deck
    end
  
    def discard(cards)
      @discard_pile.push(*cards)
    end
  
    def cards_left
      @cards.size
    end
  end
  