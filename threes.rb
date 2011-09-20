# def get_name
#   puts "Hey you, wanna play a game of dice?"
#   puts "write down your name and you can join"
#   @name = gets.chomp
# end

class DiceGame
  def intro
    info = <<INFO
  
  The game is called "Threes."  
  The goal is to have the lowest total
  You start by rolling 5 dice,
  you put 1 or more aside,
  you roll the remaining dice.
  Repeat until you have no dice.
  Players can beat each turn.
  
  The catch, is 3 is worth 0!

  Got it? (ENTER)
INFO
    puts info
    STDIN.gets
  end

  def purse(p_num)
    if p_num == 1
      @purse = $purseP1
    elsif p_num == 2
      @purse = $purseP2
    end
    @keepers = []
    @remaining = 5 - @keepers.length
    @tally = 0
    bet_once_after_last_dice = 0
  end

  def roll(p_num)
    @remaining = 5 - @keepers.length
    if @remaining == 0
      check_for_a_winner(p_num)
      puts " \s Player #{p_num}, it looks like you've picked all five so you're done rolling"
    elsif @remaining == 1
      puts "\n", "Player #{p_num} it's your last roll make \
it a good one!  ---  Hit (ENTER) to Roll"
      STDIN.gets
      $val = []
      r = rand(6) + 1
      $val.push(r)
      show(p_num)
    elsif @remaining > 1
      puts "\n", "Player #{p_num} Hit (ENTER) to Roll"
      STDIN.gets
      $val = []
      @remaining = 5 - @keepers.length
      while $val.length < @remaining
        r = rand(6) + 1
        $val.push(r)
      end
      show(p_num)    
    end
  end

  def show(p_num)
    num = 1
    $val.each do |v|
    six = <<SIX
                             _______
                            |  o  o |
                         #{num}. |  o  o |
                            |  o  o |
                            |_______|
SIX

      five = <<FIVE
                         _______
                        | o   o |
                     #{num}. |   o   |
                        | o   o |
                        |_______|
FIVE

      four = <<FOUR                                    
                     _______
                    | o   o |
                 #{num}. |       |
                    | o   o |
                    |_______|
FOUR

      three = <<THREE
      _______
     | o     |
  #{num}. |   o   |
     |     o |
     |_______|
THREE

      two = <<TWO
               _______
              | o     |
           #{num}. |       |
              |     o |
              |_______|
TWO

      one = <<ONE
           _______
          |       |
       #{num}. |   o   |
          |       |
          |_______|
ONE

      num += 1
      if v == 1
        puts one
      elsif v == 2
        puts two
      elsif v == 3
        puts three
      elsif v == 4
        puts four
      elsif v == 5
        puts five
      elsif v == 6
        puts six
      end
    end
    pick(p_num)
  end
    
  def pick(p_num)
    print "\n", "Which ones do you Player #{p_num} wanna keep? "
    input = nil
    input_array = nil
    input = gets.chomp
    @remaining = 5 - @keepers.length
    
    if input == 'quit'
      quit()
    elsif input == 'end'
      check_for_a_winner()
    elsif input.empty?
      puts "You may not like your choices but \
you've got to pick something"
      input = nil
      pick(p_num)
    elsif input.to_i == 0
      puts "The choices go 1-5! Symbols or \
the ABC's are not goin' to cut it"
      input = nil
      pick(p_num)
    else
      array = input.split('') 
      array = array.delete_if {|x| x > '5' || x < '1' }
      input_array = array.uniq
      if input_array.length == 0
        puts "None of your answers made any sense..."
        input = nil
        pick(p_num)
      elsif input_array.length >= 1
        input_array.each do |inp|
          @in_digit = inp.to_i 
          if @in_digit > @remaining
            puts "That's choice isn't available to you..."
            pick(p_num)
          end
          @in_digit -= 1
          value = $val[@in_digit]
          @keepers.push(value)
          if value == 3
            value = 0
            if p_num == 1
              $remainingP1 -= 1
            elsif p_num == 2
              $remainingP2 -= 1
            end
          else
            @tally += value
            if p_num == 1
              $tallyP1 += value
              $remainingP1 -= 1
            elsif p_num == 2
              $tallyP2 += value
              $remainingP2 -= 1
            end
          end
        end
      end
    end
    check_for_a_winner(p_num)
  #  report_choices(p_num)
  end
    
  def report_choices(p_num)
    puts "\n", " \s You, Player #{p_num} kept #{@keepers}, \
making your total #{@tally}."
    @remaining = 5 - @keepers.length
    bet_once_after_last_dice = 0
    if @remaining == 0 && bet_once_after_last_dice == 0
      puts "\n", " \s That was your last dice!"
      bet_once_after_last_dice += 1
      check_for_a_winner(p_num)
      get_first_bet(p_num)
    elsif @remaining > 0
      check_for_a_winner(p_num)
      get_first_bet(p_num) 
    end
  end

  def get_first_bet(p_num)  
    
    if @purse == 0
      puts "\n", " \s Looks like your all in, so we'll skip betting"
    elsif $purseP1 == 0 || $purseP2 == 0
      puts "\n", " \s Looks like your opponent is all in, so we'll skip betting"
    elsif @purse > 0
      print "\n", "Player #{p_num}, you've got #{@purse} in your purse, what do wanna bet?  "
      @bet = ""
      input = gets.chomp
      @bet = input.to_i
      if input == 'quit'
        quit()
      elsif input == 'end'
        check_for_a_winner(p_num)
      elsif input.empty?
        puts "\n", " \s You can bet 0 if you'd like \
but you've got to enter something..."
        get_first_bet(p_num)
      elsif @bet > $purseP1 || @bet > $purseP2  
        puts "\n", " \s That's more than your opponent has left, are you just trying to humiliate him?"
        get_first_bet(p_num)
      elsif @bet == @purse
        puts "\n", " \s DAMN! all in, you don't mess around"
      elsif @bet < 0
        puts "\n", " \s Betting a negative \
number isn't going to fly..."
        get_first_bet(p_num)
      elsif @bet > @purse
        puts "\n", " \s No way pal, you've only got #{@purse} left"
        get_first_bet(p_num)
      elsif input == '0'
        puts "\n", " \s Playing it safe I see..."
      elsif @bet >= 1
        random = rand(3)
        if random == 0
          puts "\n", " \s Ok, that's a solid bet"
        elsif random == 1
          puts "\n", " \s That's what I like to see!"
        elsif random == 2
          puts "\n", " \s Keeping the game moving, good work"
        elsif random == 3
          puts "\n", " \s Player #{p_num} Keeping the pressure on, nice"
        end
      else
        puts "\n", " \s #{input.upcase}, you want to bet \
#{input.upcase}! Give me a break..."
        get_first_bet(p_num)
      end
      process_bet(p_num)
    end
  end
  
  def process_bet(p_num)
    if @purse > 0
      @purse -= @bet
      $pot += @bet
      $the_bet = @bet
    elsif @purse == 0
    end
  end

  def call_or_raise(p_num)
    if $the_bet > 0
      @remaining = (5 - @keepers.length)
      puts "\n", "Ok Player #{p_num}, here's the run down
  <> The initial bet stands at #{$the_bet}
  <> You've set aside #{@keepers}
  <> You have #{@remaining} remaining for a total of #{@tally}
  <> You've got #{@purse} left in your purse and the pot stands at #{$pot}"
      print "Player #{p_num}, what are you in for?  "
      input = gets.chomp
      @bet = input.to_i
      if input == 'quit'
        quit()
      elsif input == 'end'
        check_for_a_winner()
      elsif @bet == @purse
        @purse -= @bet
        $pot += @bet
        $the_bet = @bet - $the_bet
        puts "\n", " \s so it looks like you're all in, \
I guess we'll just see where the dice land"
      elsif @bet > @purse
        puts "\n", " \s #{@bet}! No way pal, you've only got #{@purse} left"
        call_or_raise(p_num)
      elsif @bet > $purseP1 || @bet > $purseP2  
        puts "\n", " \s That's more than your opponent has left, are you just trying to humiliate him?"
        call_or_raise(p_num)
      elsif @bet > $the_bet
        @purse -= @bet
        $pot += @bet
        random = rand(4)
        if random == 0
          puts "\n", " \s Ok, that's a solid bet"
        elsif random == 1
          puts "\n", " \s That's what I like to see!"
        elsif random == 2
          puts "\n", " \s Keeping the game moving, good work"
        elsif random == 3
          puts "\n", " \s Player #{p_num} Keeping the pressure on, nice"
        elsif random == 4
          puts "\n", " \s This isn't your first rodeo"
        end
        $the_bet = @bet - $the_bet
      elsif @bet == $the_bet
        @purse -= @bet
        $pot += @bet
        random = rand(3)
        if random == 0
          puts "\n", " \s Ok, that's all you need to stay in"
        elsif random == 1
          puts "\n", " \s Conservative play but your hanging in"
        elsif random == 2
          puts "\n", " \s I see your not scared off that easily"
        elsif random == 3
          puts "\n", " \s Glad to see you're still in the game"
        end
        $the_bet = @bet - $the_bet
      elsif @bet < $the_bet
        puts "\n", " \s #{input}! That's not enough to keep you in the game"
        call_or_raise(p_num)
      end 
    end
  end 
  
  def fold_or_call(p_num)
    if $the_bet > 0
      @remaining = (5 - @keepers.length)
      puts "\n", "Ok Player #{p_num}, here's the run down
 <> The other guy raise so you'll need to put in #{$the_bet} to stay in the game
 <> You've set aside #{@keepers}
 <> You have #{@remaining} remaining for a total of #{@tally}
 <> You've got #{@purse} left in your purse and the pot stands at #{$pot}"
      print "Player #{p_num}, will ya match his bet or are you  'out'  ?  "
      input = gets.chomp
      @bet = input.to_i
      if input == 'quit'
        quit()
      elsif input == 'end'
        check_for_a_winner()
      elsif @bet > $the_bet
        puts "\n", " \s Sorry, you already had your turn to raise"
        fold_or_call(p_num)
      elsif @bet == $the_bet  
        @purse -= @bet
        $pot += @bet
        random = rand(3)
        if random == 0
          puts "\n", " \s Ok, that's all you need to stay in"
        elsif random == 1
          puts "\n", " \s Conservative play but your hanging in"
        elsif random == 2
          puts "\n", " \s I see your not scared off that easily"
        elsif random == 3
          puts "\n", " \s Glad to see you're still in the game"
        end
        $the_bet = @bet - $the_bet
      elsif @bet < $the_bet
        puts "\n", " \s #{input}! That's not enough to keep you in the game"
        fold_or_call(p_num)
      end
    end
  end

  def quit()
    puts "Better luck next time..."
    puts "Player #{p_num} lost.."
    Process.exit!(0)
  end

  def check_for_a_winner(p_num)
    if p_num == 1
      $purseP1 = @purse
    elsif p_num == 2
      $purseP2 = @purse
    end

    if $remainingP1 == 0 && $remainingP2 == 0 && $tallyP1 == $tallyP2
      puts " \s I do not believe this...... you TIED!!!!!"
      puts " \s The money will stay in the pot for next time!"
      puts "the @purse is #{@purse}"
      puts "the $purseP1 is #{$purseP1}"
      puts "the $purseP2 is #{$purseP2}"
      want_to_play_again()
    elsif $remainingP1 == 0 && $tallyP1 < $tallyP2
      $purseP1 = @purse
      $purseP1 += $pot
      puts "p_num is equal to #{p_num}"
      if @purse == 60 || @purse == 0
        puts " \s Player 1 you bankrupted your opponent and are the overall CHAMPION!"
      else
        puts " \s Player 1........ you WON!!!!!"
        puts " \s but the other guy still has enough money to continue"
      end
        
      puts "The pot was #{$pot} you now have #{$purseP1} in your purse"
      puts "the @purse is #{@purse}"
      puts "the $purseP1 is #{$purseP1}"
      puts "the $purseP2 is #{$purseP2}"
        #
      want_to_play_again()
    elsif $remainingP2 == 0 && $tallyP1 > $tallyP2
      $purseP2 = @purse
      $purseP2 += $pot
      puts "p_num is equal to #{p_num}"
      if @purse == 60 || @purse == 0
        puts " \s Player 2 you bankrupted your opponent and are the overall CHAMPION!"
      else
        puts " \s Player 2........ you WON!!!!!"
        puts " \s but the other guy still has enough money to continue"
      end
        
      puts "The pot was #{$pot} you now have #{$purseP2} in your purse"
      puts "the @purse is #{@purse}"
      puts "the $purseP1 is #{$purseP1}"
      puts "the $purseP2 is #{$purseP2}"
        #
      want_to_play_again()
    end
  end
  
  def want_to_play_again
    puts "Want to play again? (y/n)"
    input = gets.chomp
    if input == "y"
      play_game()
    elsif input == "n"
      puts "Later!"
      Process.exit!(0)
    else
      puts "I didn't understand"
      want_to_play_again()
    end
  end
end

def setup_purse
  $purseP1 = 30
  $purseP2 = 30
end

def play_game()
  @first_player = DiceGame.new
  @first_player.purse(1)
  @second_player = DiceGame.new
  @second_player.purse(2)
  
  $pot = 0
  $the_bet = 0
  $tallyP1 = 0
  $tallyP2 = 0
  $remainingP1 = 5
  $remainingP2 = 5
  
  while true
    @first_player.roll(1) # roll > show > pick
    @first_player.report_choices(1) # report > get_first_bet
    break if $remainingP1 == 0 && $remainingP2 == 0
    break if $remainingP1 == 0 && $tallyP1 < $tallyP2
    break if $remainingP2 == 0 && $tallyP1 > $tallyP2
    @first_player.check_for_a_winner(1)
    # @first_player.get_first_bet(1)
    @second_player.call_or_raise(2)
    @first_player.fold_or_call(1)
  
    @second_player.roll(2) # roll > show > pick
    @second_player.report_choices(2) # report > get_first_bet
    break if $remainingP1 == 0 && $remainingP2 == 0
    break if $remainingP1 == 0 && $tallyP1 < $tallyP2
    break if $remainingP2 == 0 && $tallyP1 > $tallyP2
    @second_player.check_for_a_winner(2)
    # @second_player.get_first_bet(2)
    @first_player.call_or_raise(1)
    @second_player.fold_or_call(2)  
  end
end

setup_purse()
play_game()

