def calculate_score(cards)
    return 0 if cards.empty?
  
    values = cards.map(&:value)
    suits = cards.map(&:suit)
    value_counts = values.tally
    sorted_values = values.sort
    calculation_details = ""  # 計算プロセスの保存
    score = 0  # 初期化スコア
  
    # 1. 同じ数字の札があるかどうかをチェック
    if value_counts.values.include?(2)
      pair_value = value_counts.key(2)
      score = (10 + pair_value * 2) * 2
      calculation_details = "(10 + #{pair_value}*2) * 2 = #{score}"
    end
  
    # 2. 同じ数字の札が2組あるかどうかをチェック
    pairs = value_counts.select { |_, count| count == 2 }
    if pairs.size == 2
      score = (20 + pairs.keys.sum { |key| key * 2 }) * 2
      calculation_details = "(20 + #{pairs.keys.map { |key| "#{key}*2" }.join(' + ')}) * 2 = #{score}"
    end
  
    # 3.同じ積分数の札が3枚あるかチェック
    if value_counts.values.include?(3)
      three_of_a_kind_value = value_counts.key(3)
      score = (30 + three_of_a_kind_value * 3) * 3
      calculation_details = "(30 + #{three_of_a_kind_value}*3) * 3 = #{score}"
    end
  
    # 4. 5枚のカードが連続した数字であるかどうかをチェック
    if sorted_values.size == 5 && sorted_values.each_cons(2).all? { |a, b| b == a + 1 }
      if suits.uniq.size == 1
        # 5. 同花順かどうかをチェック
        score = (100 + sorted_values.sum) * 8
        calculation_details = "(100 + #{sorted_values.join(' + ')}) * 8 = #{score}"
      else
        # 仅順子になる
        score = (30 + sorted_values.sum) * 4
        calculation_details = "(30 + #{sorted_values.join(' + ')}) * 4 = #{score}"
      end
    end
  
    # 6. 同じポイントのカードが4枚あるかチェック
    if value_counts.values.include?(4)
      four_of_a_kind_value = value_counts.key(4)
      score = (40 + four_of_a_kind_value * 4) * 5
      calculation_details = "(40 + #{four_of_a_kind_value}*4) * 5 = #{score}"
    end
  
    # 7.条件を満たす組合せがない場合は、最大積分数を戻します
    if score == 0  
      score = values.max
      calculation_details = "Max value: #{score}"
    end
  
    return score, calculation_details  # 戻りスコアと計算プロセス
  end
  