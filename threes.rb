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
  As well you can "Shoot the Moon!"
  and win automatically by keeping all 6's
  
  Got it? (ENTER)
INFO
    puts info
    STDIN.gets
  end

  def purse(p_num)
    if p_num == 1 || p_num == 3
      @purse = $purseP1
    elsif p_num == 2 || p_num == 4
      @purse = $purseP2
    end
    @keepers = []
    @remaining = 5 - @keepers.length
    @tally = 0
    bet_once_after_last_dice = 0
  end

  def roll(p_num, p_name)
    @remaining = 5 - @keepers.length
    if @remaining == 0
      check_for_a_winner(p_num, p_name)
      puts " \s #{p_name}, it looks like you've picked all five so you're done rolling"
    elsif @remaining == 1
      puts "\n", "#{p_name}, it's your last roll make \
it a good one!  ---  Hit (ENTER) to Roll"
      STDIN.gets
      $val = []
      r = rand(6) + 1
      $val.push(r)
      show(p_num, p_name)
    elsif @remaining > 1
      puts "\n", "#{p_name} Hit (ENTER) to Roll"
      STDIN.gets
      $val = []
      @remaining = 5 - @keepers.length
      while $val.length < @remaining
        r = rand(6) + 1
        $val.push(r)
      end
      show(p_num, p_name)    
    end
  end

  def computer_roll(p_num, p_name)
    puts "#{p_name}, Hit <ENTER> to let the computer take its turn"
    STDIN.gets
    
    @remaining = 5 - @keepers.length
    if @remaining == 0
      check_for_a_winner(p_num, p_name)
      puts "The Computer, picked all five so its done rolling"
    elsif @remaining > 1
      $val = []
      @remaining = 5 - @keepers.length
      while $val.length < @remaining
        r = rand(6) + 1
        $val.push(r)
      end
      computer_show(p_num, p_name)    
    end
  end

  def show(p_num, p_name)
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
    if p_num < 4
      pick(p_num, p_name)
    elsif p_num == 4
      computer_pick(p_num, p_name)
    end
  end

#   def computer_show(p_num, p_name)
#     num = 1
#     $val.each do |v|
#     six = <<SIX
#                              _______
#                             |  o  o |
#                          #{num}. |  o  o |
#                             |  o  o |
#                             |_______|
# SIX
# 
#       five = <<FIVE
#                          _______
#                         | o   o |
#                      #{num}. |   o   |
#                         | o   o |
#                         |_______|
# FIVE
# 
#       four = <<FOUR                                    
#                      _______
#                     | o   o |
#                  #{num}. |       |
#                     | o   o |
#                     |_______|
# FOUR
# 
#       three = <<THREE
#       _______
#      | o     |
#   #{num}. |   o   |
#      |     o |
#      |_______|
# THREE
# 
#       two = <<TWO
#                _______
#               | o     |
#            #{num}. |       |
#               |     o |
#               |_______|
# TWO
# 
#       one = <<ONE
#            _______
#           |       |
#        #{num}. |   o   |
#           |       |
#           |_______|
# ONE
# 
#       num += 1
#       if v == 1
#         puts one
#       elsif v == 2
#         puts two
#       elsif v == 3
#         puts three
#       elsif v == 4
#         puts four
#       elsif v == 5
#         puts five
#       elsif v == 6
#         puts six
#       end
#     end
#     computer_pick(p_num, p_name)
#   end    
# 
  def pick(p_num, p_name)
    print "\n", "Which ones do you wanna keep? "
    input = nil
    input_array = nil
    input = gets.chomp
    @remaining = 5 - @keepers.length
    
    if input == 'quit'
      quit()
    elsif input == 'end'
      check_for_a_winner()
    elsif input == 'intro'
      intro()
    elsif input.empty?
      puts "You may not like your choices but \
you've got to pick something"
      input = nil
      pick(p_num, p_name)
    elsif input.to_i == 0
      puts "The choices go 1-5! Symbols or \
the ABC's are not goin' to cut it"
      input = nil
      pick(p_num, p_name)
    else
      array = input.split('') 
      array = array.delete_if {|x| x > '5' || x < '1' }
      input_array = array.uniq
      if input_array.length == 0
        puts "None of your answers made any sense..."
        input = nil
        pick(p_num, p_name)
      elsif input_array.length >= 1
        input_array.each do |inp|
          @in_digit = inp.to_i 
          if @in_digit > @remaining
            puts "That's choice isn't available to you..."
            pick(p_num, p_name)
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
  end

  def computer_pick(p_num, p_name)
    picked = 0
    $val.each do |value|
      if value == 1 || value == 3
        @keepers.push(value)
        picked += 1
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

    if picked == 0
      value = $val.sort.slice(0)
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
    
  def report_choices(p_num, p_name)
    puts "\n", " \s #{p_name}, you kept #{@keepers}, \
making your total #{@tally}."
    @remaining = 5 - @keepers.length
    bet_once_after_last_dice = 0
    
    if @remaining == 0 && bet_once_after_last_dice == 0
      puts "\n", " \s That was your last dice!"
      bet_once_after_last_dice += 1
    end
    
    if $remainingP1 == 0 || $remainingP2 == 0
      check_for_a_winner(p_num, p_name)
    end
    
    get_first_bet(p_num, p_name) 
  
  end

  def computer_report_choices(p_num, p_name)
    puts "def computer_report_choices(p_num, p_name)"
    
    puts "\n", " \s The Computer kept #{@keepers}, \
making its total #{@tally}."
    @remaining = 5 - @keepers.length
    bet_once_after_last_dice = 0
    if @remaining == 0 && bet_once_after_last_dice == 0
      puts "\n", " \s That was the Computer's  last dice!"
      bet_once_after_last_dice += 1
    end

    if $remainingP1 == 0 || $remainingP2 == 0
      check_for_a_winner(p_num, p_name)
    end
    
    computer_get_first_bet(p_num, p_name)
    
  end

  def get_first_bet(p_num, p_name)
    puts "   def get_first_bet(p_num, p_name)"
    if @purse == 0
      puts "\n", " \s Looks like your all in, so we'll skip betting"
    elsif $purseP1 == 0 || $purseP2 == 0
      puts "\n", " \s Looks like your opponent is all in, so we'll skip betting"
    elsif @purse > 0
      print "\n", "#{p_name}, you've got #{@purse} in your purse, what do wanna bet?  "
      @bet = ""
      input = gets.chomp
      @bet = input.to_i
      if input == 'quit'
        quit(p_num, p_name)
      elsif input == 'fold'
        @input = input
        check_for_a_winner(p_num, p_name)
      elsif input == 'intro'
        intro()
        get_first_bet(p_num, p_name)
      elsif input.empty?
        puts "\n", " \s You can bet 0 if you'd like \
but you've got to enter something..."
        get_first_bet(p_num, p_name)\
      elsif @bet == @purse
        puts "\n", " \s DAMN! all in, you don't mess around"
      elsif @bet > @purse
        puts "\n", " \s No way pal, you've only got #{@purse} left"
        get_first_bet(p_num, p_name)
      elsif @bet > $purseP1 || @bet > $purseP2  
        puts "\n", " \s That's more than your opponent has left, are you just trying to humiliate him?"
        get_first_bet(p_num, p_name)
      elsif @bet < 0
        puts "\n", " \s Betting a negative \
number isn't going to fly..."
        get_first_bet(p_num, p_name)
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
          puts "\n", " \s #{p_name} keeping the pressure on, nice"
        end
      else
        puts "\n", " \s #{input.upcase}, you want to bet \
#{input.upcase}! Give me a break..."
        get_first_bet(p_num, p_name)
      end
      @purse -= @bet
      $pot += @bet
      $the_bet = @bet
    end
  end

  def computer_get_first_bet(p_num, p_name)
    puts "  def computer_get_first_bet(p_num, p_name)"
    if @purse == 0
      puts "\n", " \s Looks like your all in, so we'll skip betting"
    elsif $purseP1 == 0 || $purseP2 == 0
      puts "\n", " \s Looks like your opponent is all in, so we'll skip betting"
    elsif @purse > 0
      ratioP1 = ($remainingP1 * 1.5) + $tallyP1
      ratioCPU = ($remainingP2 * 1.5) + $tallyP2
      puts "player 1 ratio is #{ratioP1}"
      puts "computer's ratio is #{ratioCPU}"
      if ratioP1 > ratioCPU
        if ratioP1 - ratioCPU >= 2.0
          @bet = 5
          puts "The computer thinks he's got a edge on you... it put in #{@bet}"
        elsif ratioP1 - ratioCPU < 2.0
          @bet = 1
          puts "The computer thinks it's an even match... it put in #{@bet}"
        end
      elsif ratioP1 < ratioCPU 
        if ratioCPU - ratioP1 < 2.0
          @bet = 1
          puts "The computer thinks it's an even match... it put in #{@bet}"
        elsif ratioCPU - ratioP1 >= 2.0
          @bet = 0
          puts "The computer thinks you have the edge... it passed on betting"
        end
      end
      @purse -= @bet
      $pot += @bet
      $the_bet = @bet
      puts "\n", "The Computer bet #{@bet}", "\n"
    end
    
  end

  def run_down(p_num, p_name)
    if @purse > 0 && @purse != 30 && $the_bet > 0
    puts "\n", "Ok #{p_name}, here's the run down

    <> The initial bet stands at #{$the_bet}
    <> You've set aside #{@keepers} for a total of #{@tally}
    <> You've got #{@purse} left in your purse and the pot stands at #{$pot}",
    "\n"
    else
      puts
    end
  end

  def call_or_raise(p_num, p_name)
    puts "def call_or_raise(p_num, p_name)"
    if $the_bet > 0
      @remaining = (5 - @keepers.length)
      print "#{p_name}, what are you in for?  "
      input = gets.chomp.downcase
      @bet = input.to_i
      if input == 'quit'
        quit(p_num, p_name)
      elsif input == 'fold'
        @input = input
        check_for_a_winner(p_num, p_name)
      elsif input == 'intro'
        intro()
        call_or_raise(p_num, p_name)
      elsif @bet == @purse
        @purse -= @bet
        $pot += @bet
        $the_bet = @bet - $the_bet
        puts "\n", " \s so it looks like you're all in, \
I guess we'll just see where the dice land"
      elsif @bet > @purse
        puts "\n", " \s #{@bet}! No way pal, you've only got #{@purse} left"
        call_or_raise(p_num, p_name)
      elsif (@bet - $the_bet) > $purseP1 || (@bet -$the_bet) > $purseP2  
        puts "\n", " \s That's more than your opponent has left, are you just trying to humiliate him?"
        call_or_raise(p_num, p_name)
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
          puts "\n", " \s #{p_name} keeping the pressure on, nice"
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
      elsif input.length == 0
        puts "\n", "Nothing?!?, you can 'fold' or 'quit' but you've got to put something"
        call_or_raise(p_num, p_name)
      elsif @bet < $the_bet
        puts "\n", " \s #{input}! That's not enough to keep you in the game"
        call_or_raise(p_num, p_name)
      end 
    end
  end 

  def computer_call_or_raise(p_num, p_name)
    puts "  def computer_call_or_raise(p_num, p_name)"

    ratioP1 = ($remainingP1 * 1.5) + $tallyP1
    ratioCPU = ($remainingP2 * 1.5) + $tallyP2
    puts "player 1 ratio is #{ratioP1}"
    puts "computer's ratio is #{ratioCPU}"
    if $the_bet == 0
      puts "Skipping betting, that means it's the computer's turn"
    elsif $the_bet > 0 && ratioP1 >= ratioCPU
      if (ratioP1 - ratioCPU) >= 2.0
        @bet = $the_bet + 5
        puts "\n", "The Computer thinks it's got an edge, it puts in #{@bet} you'll need to put in 5 more to stay in", "\n"
        @purse -= @bet
        $pot += @bet
        $the_bet = @bet - $the_bet
      elsif (ratioP1 - ratioCPU) < 2.0
        @bet = $the_bet
        puts "\n", "The Computer called your bet of #{@bet}", "\n"
        @purse -= @bet
        $pot += @bet
        $the_bet = @bet - $the_bet
      end
    elsif $the_bet > 0 && ratioP1 < ratioCPU 
      if (ratioCPU - ratioP1) <= 2.0
        @bet = $the_bet
        puts "\n", "The Computer called your bet of #{@bet}", "\n"
        @purse -= @bet
        $pot += @bet
        $the_bet = @bet - $the_bet
      elsif (ratioCPU - ratioP1) > 2.0
        @input == 'fold'
        check_for_a_winner(p_num, p_name)
      end
    end    
    puts "purse = #{@purse}"
    puts "bet = #{@bet}"
  end
  
  def fold_or_call(p_num, p_name)
    puts "  def fold_or_call(p_num, p_name)"
    if $the_bet > 0
      @remaining = (5 - @keepers.length)
      print "#{p_name}, will ya match his bet or 'fold'  ?  "
      input = gets.chomp.downcase
      @bet = input.to_i
      if input == 'quit'
        quit(p_num, p_name)
      elsif input == 'fold'
        @input = input
        check_for_a_winner(p_num, p_name)
      elsif input == 'intro'
        intro()
        fold_or_call(p_num, p_name)
      elsif @bet > $the_bet
        puts "\n", " \s Sorry, you already had your turn to raise"
        fold_or_call(p_num, p_name)
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
      elsif input.length == 0
        puts "\n", "Nothing?!?, you can 'fold' or 'quit' but you've got to put something"
      elsif @bet < $the_bet
        puts "\n", " \s #{input}! That's not enough to keep you in the game"
        fold_or_call(p_num, p_name)
      end
    end
  end

  def computer_fold_or_call(p_num, p_name)
    if $the_bet > 0
      puts "  def computer_fold_or_call(p_num, p_name)"
      ratioP1 = ($remainingP1 * 1.5) + $tallyP1
      ratioCPU = ($remainingP2 * 1.5) + $tallyP2
      if ratioP1 > ratioCPU           # Player one is behind
        @bet = $the_bet
        puts "\n", "The Computer called your bet of #{@bet}", "\n"
      elsif ratioP1 < ratioCPU        # Player one is ahead
        if ratioCPU - ratioP1 >= 3    
          @input == 'fold'
          check_for_a_winner(p_num, p_name)
        elsif ratioCPU - ratioP1 < 3
          @bet = $the_bet
          puts "\n", "The Computer called your bet of #{@bet}", "\n"
        end
      end
      @purse -= @bet
      $pot += @bet
      $the_bet = @bet
    end
  end

  def quit(p_num, p_name)
    puts "Better luck next time..."
    puts "Player #{p_name} lost.."
    Process.exit!(0)
  end

  def check_for_a_winner(p_num, p_name)
    puts "  def check_for_a_winner(p_num, p_name)"
  
    if p_num == 1
      $purseP1 = @purse
    elsif p_num == 2
      $purseP2 = @purse
    end
    
    if @input == 'fold'
      print "Leaving so soon? I guess this means............."
      if p_num == 1
        $purseP2 = @purse
        $purseP2 += $pot
        puts " \s #{$name2} you WON!!!!!"
      elsif p_num == 2
        $purseP1 = @purse
        $purseP1 += $pot
        puts " \s #{$name1} you WON!!!!!"
      end
      want_to_play_again()
    elsif $tallyP1 == 30
      puts " \s I do not believe this...... "
      puts " \s #{$name1}, you 'Shot The MOON'......"
      puts " \s and secured yourself the win! "
      check_if_player2_is_bankrupt()
    elsif $tallyP2 == 30
      puts " \s I do not believe this...... "
      puts " \s #{$name2}, you 'Shot The MOON'......"
      puts " \s and secured yourself the win! "
      check_if_player1_is_bankrupt()
    elsif $remainingP1 == 0 && $remainingP2 == 0 && $tallyP1 == $tallyP2
      puts " \s I do not believe this...... you TIED!!!!!"
      puts " \s The money will stay in the pot for next time!"
      want_to_play_again()
    elsif $remainingP1 == 0 && $tallyP1 < $tallyP2
      $purseP1 = @purse
      $purseP1 += $pot
      check_if_player2_is_bankrupt()
    elsif $remainingP2 == 0 && $tallyP1 > $tallyP2
      $purseP2 = @purse
      $purseP2 += $pot
      check_if_player1_is_bankrupt()
    end
  end
  
  def check_if_player2_is_bankrupt
    if @purse == 60 || @purse == 0
      puts " \s #{$name1} you bankrupted your opponent and are the overall CHAMPION!"
      Process.exit!(0)
    else
      puts " \s #{$name1}........ you WON!!!!!"
      puts " \s but #{$name2} still has enough money to continue"
      want_to_play_again()
    end
  end
  
  def check_if_player1_is_bankrupt
    if @purse == 60 || @purse == 0
      puts " \s #{$name2} you bankrupted #{$name1} and are the overall CHAMPION!"
      Process.exit!(0)
    else
      puts " \s #{$name2}........ you WON!!!!!"
      puts " \s but #{$name1} still has enough money to continue"
      want_to_play_again()
    end
  end
  
  def want_to_play_again
    puts "Want to play again? (y/n)"
    input = gets.chomp
    if input == "y"
      play_2_player_game()
    elsif input == "n"
      puts "Later!"
      Process.exit!(0)
    else
      puts "I didn't understand"
      want_to_play_again()
    end
  end
end

def get_mode()
  puts "Do you want to play (1) player or (2) player mode?"
  input = gets.chomp
  if input == '1'
    puts "Type in your name(s) and you can join the game"
    get_name_1()
    vs_computer_game()
  elsif input == '2'
    get_name_1()
    get_name_2()
    setup_purse()
    play_2_player_game()
  else
    puts "I didn't understand"
    get_mode()
  end
end


  
def get_name_1()
  print "Player 1 > "
  $name1 = gets.chomp.capitalize
  if $name1.length == 0 
    puts "I didn't catch that can you repeat it"
    get_name_1()
  else
  end
end
#  get_name_1()
$name1 = "Jack"

def get_name_2()
  print "Player 2 > "
  $name2 = gets.chomp.capitalize
  if $name2.length == 0
    puts "I didn't catch that can you repeat it"
    get_name_2()
  else
  end
end
#  get_name_2()
$name2 = "Andrew"

def setup_purse()
  $purseP1 = 30
  $purseP2 = 30
end

def play_2_player_game()
  @first_player = DiceGame.new
  # @first_player.get_name(1)
  @first_player.purse(1)
  @second_player = DiceGame.new
  @second_player.purse(2)
  # @second_player.get_name(2)
  
  $pot = 0
  $the_bet = 0
  $tallyP1 = 0
  $tallyP2 = 0
  $remainingP1 = 5
  $remainingP2 = 5
  
  while true
    @first_player.roll(1, $name1) # roll > show > pick
    @first_player.report_choices(1, $name1) # report > get_first_bet
    break if $remainingP1 == 0 && $remainingP2 == 0
    break if $remainingP1 == 0 && $tallyP1 < $tallyP2
    break if $remainingP2 == 0 && $tallyP1 > $tallyP2
    @first_player.check_for_a_winner(1, $name1)
    # @first_player.get_first_bet(1)
    @second_player.run_down(2, $name2)
    @second_player.call_or_raise(2, $name2)
#    @first_player.run_down(1, $name1)
    @first_player.fold_or_call(1, $name1)
  
    @second_player.roll(2, $name2) # roll > show > pick
    @second_player.report_choices(2, $name2) # report > get_first_bet
    break if $remainingP1 == 0 && $remainingP2 == 0
    break if $remainingP1 == 0 && $tallyP1 < $tallyP2
    break if $remainingP2 == 0 && $tallyP1 > $tallyP2
    @second_player.check_for_a_winner(2, $name2)
    # @second_player.get_first_bet(2)
    @first_player.run_down(1, $name1)
    @first_player.call_or_raise(1, $name1)
#    @second_player.run_down(2, $name2)
    @second_player.fold_or_call(2, $name2)  
  end
end

def vs_computer_game()
  @human = DiceGame.new
  @human.purse(3)
  @computer = DiceGame.new
  @computer.purse(4)
  
  $pot = 0
  $the_bet = 0
  $tallyP1 = 0
  $tallyP2 = 0
  $remainingP1 = 5
  $remainingP2 = 5
  
  while true
    @human.roll(3, $name1) # roll > show > pick
    @human.report_choices(3, $name1) # report > get_first_bet
    break if $remainingP1 == 0 && $remainingP2 == 0
    break if $remainingP1 == 0 && $tallyP1 < $tallyP2
    break if $remainingP2 == 0 && $tallyP1 > $tallyP2
    @computer.computer_call_or_raise(4, computer)  
    @human.fold_or_call(3, $name1)
  
    @computer.computer_roll(4, computer) # roll > show > pick
    @computer.computer_report_choices(4, computer) # report > get_first_bet
    break if $remainingP1 == 0 && $remainingP2 == 0
    break if $remainingP1 == 0 && $tallyP1 < $tallyP2
    break if $remainingP2 == 0 && $tallyP1 > $tallyP2
    @human.call_or_raise(3, $name1)
    @computer.computer_fold_or_call(4, computer)  
  end
end

setup_purse()
get_mode()



