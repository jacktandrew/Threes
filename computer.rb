class Computer
  def computer_pick()
    picked = 0
    @val.each do |value|
      if value == 1 || value == 3
        @keepers.push(value)
        picked += 1
        if value == 3
          # 3 counts are zero
        else
          @tally += value
        end
      end
    end

    if picked == 0
      value = @val.sort.slice(0)
      @keepers.push(value)      
      @tally += value
    end
  end

  def computer_get_first_bet()
    puts "\n"
    if player.purse == 0
      puts " \s Looks like your all in, so we'll skip betting"
    elsif $purseP1 == 0 || $purseP2 == 0
      puts " \s Looks like your opponent is all in, so we'll skip betting"
    elsif @purse > 0
      computer_determine_lead(p_num, p_name)
      update_purse(p_num)
    end
  end

  def computer_determine_lead(p_num, p_name)
    @ratio = @remaining * 2 + @tally
  
    if p_num.odd?
      $ratioP1 = @ratio
      @foe_purse = $purseP2
      @foe_ratio = $ratioP2
      @foe_remaining = $remainingP2
    elsif p_num.even?
      $ratioP2 = @ratio
      @foe_purse = $purseP1
      @foe_ratio = $ratioP1
      @foe_remaining = $remainingP1
    end

    # puts "ratio = #{@ratio}"
    # puts "foe_ratio = #{@foe_ratio}"
  
    if @ratio <= @foe_ratio
      computer_ahead(p_num, p_name)
    elsif @ratio > @foe_ratio
      computer_behind(p_num, p_name)
    end
    puts "\n"
  end

  def computer_ahead(p_num, p_name)
    if @foe_ratio - @ratio >= 3.0   # Ahead by more than 2
      if @foe_purse <= 7
        @bet = $the_bet + @foe_purse
        puts "#{p_name} is going for the throat!  It's putting you all in by betting #{@bet}"
      elsif @purse <= 7 
        @bet = $the_bet + @purse
        puts "This is for the match people..... #{p_name} put himself ALL IN!!!!"
      elsif @foe_purse > 7
        @bet = $the_bet + 4
        computer_exude_confidence(p_num, p_name)
      end
    elsif @foe_ratio - @ratio < 3.0 # Ahead by less than 2
      if @foe_remaining == 5
        @bet = 1
        computer_exude_caution(p_num, p_name)
      elsif @foe_purse <= 3
        @bet = $the_bet + @foe_purse
        puts "#{p_name} is going for the throat!  It's putting you all in by betting #{@bet}"
      elsif @foe_purse >= 3
        @bet = $the_bet + 1
        computer_exude_caution(p_num, p_name)
      end
    end
  end

  def computer_behind(p_num, p_name)
    # puts " computer_behind(p_num, p_name)"
    if @ratio - @foe_ratio >= 4.0
      fold(p_num, p_name)
    elsif @ratio - @foe_ratio == 3.0
      if $the_bet == 0
        puts "#{p_name} thinks you have the edge... it's passing on betting"
      elsif $the_bet < 5
        @bet = $the_bet
        computer_exude_caution(p_num, p_name)
      elsif $the_bet >= 5
        fold(p_num, p_name)
      end
    elsif @ratio - @foe_ratio <= 2.0
      if @foe_purse <= 3
        @bet = $the_bet + @foe_purse
        puts "#{p_name} is going for the throat!  It's putting you all in by betting #{@bet} "
      elsif @foe_purse >= 3
        @bet = $the_bet
        computer_exude_caution(p_num, p_name)
      end
    end
  end

  def computer_exude_confidence(p_num, p_name)
    random = rand(3)
    if random == 0
      puts "#{p_name} doesn't think you've got what it takes... it put in #{@bet}"
    elsif random == 1
      puts "#{p_name} wants to see how easily you break... it put in #{@bet}"
    elsif random == 2
      puts "#{p_name} thinks he can scare you off by betting #{@bet}"
    elsif random == 2
      puts "#{p_name} wants to see what your made of... it bet #{@bet}"
    end
  end

  def computer_exude_caution(p_num, p_name)
    random = rand(3)
    if random == 0
      puts "#{p_name} thinks it's an even match... it put in #{@bet}"
    elsif random == 1
      puts "#{p_name} is just bidding it's time... it put in #{@bet}"
    elsif random == 2
      puts "#{p_name} ain't in no hurry... it put in #{@bet}"
    end
  end

  def computer_call_or_raise(p_num, p_name)
    # puts " computer_call_or_raise(p_num, p_name)"
    # puts "@purse #{@purse}"
    # puts "$purseP1 #{$purseP1}"
    # puts "$purseP2 #{$purseP2}"
    # puts "$pot #{$pot}"
  
    if $the_bet > 0
      computer_determine_lead(p_num, p_name)
      update_purse(p_num)
    end
  end

  def computer_fold_or_call(p_num, p_name)
    if $the_bet > 0
      if @ratio - @foe_ratio >= 4.0
        fold(p_num, p_name)
      elsif @ratio - @foe_ratio == 3.0 && $the_bet >= 5
        fold(p_num, p_name)
      else
        @bet = $the_bet - @bet
        computer_exude_caution(p_num, p_name)
      end
      update_purse(p_num)
    end
  end
end

