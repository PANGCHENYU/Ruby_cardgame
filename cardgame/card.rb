class Card
    attr_reader :suit, :rank, :value, :image
  
    SUITS = %w[hearts diamonds clubs spades].freeze
    RANKS = %w[1 2 3 4 5 6 7 8 9 10].freeze
  
    def initialize(suit, rank)
      @suit = suit
      @rank = rank
      @value = RANKS.index(rank) + 1
      @image = Gosu::Image.new("#{suit}_#{rank}.png")
    end
  end
  