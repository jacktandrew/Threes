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
    @bet_once_after_last_dice = 0
    $the_bet = 0
    $remainingP1 = 5
    $remainingP2 = 5
    $tallyP1 = 0
    $tallyP2 = 0
    $ratioCPU = 10
  end

  def roll(p_num, p_name)
    puts "You've got #{@purse} left in your purse" 
    
    @remaining = 5 - @keepers.length
    if @remaining == 0
      check_for_a_winner(p_num, p_name)
      if p_num < 4
        puts " \s #{p_name}, it looks like you've picked all five so you're done rolling"
      elsif p_num == 4
        puts "The Computer, picked all five so its done rolling"
      end
    elsif @remaining >= 1
      if @remaining == 1
        if p_num < 4
          puts "\n", "#{p_name}, it's your last roll make it a good one!  ---  Hit (ENTER) to Roll"
        elsif p_num == 4
          puts "\n", "Hit <ENTER> to let the computer take its last turn"
        end
      elsif @remaining > 1
        if p_num < 4
          puts "\n", "#{p_name} Hit <ENTER> to Roll" 
        elsif p_num == 4
          puts "\n", "Hit <ENTER> to let the computer take its turn"
        end
      end
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
      puts "You may not like your choices but you've got to pick something"
      input = nil
      pick(p_num, p_name)
    elsif input.to_i == 0
      puts "The choices go 1-5! Symbols or the ABC's are not goin' to cut it"
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
    @remaining = 5 - @keepers.length
    $ratioP1 = @remaining + @tally * 2
    report_choices(p_num, p_name)
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
    @remaining = 5 - @keepers.length
    $ratioCPU = @remaining + @tally * 2
    report_choices(p_num, p_name)
  end
    
  def report_choices(p_num, p_name)
    @remaining = 5 - @keepers.length

    if p_num < 4 && @bet_once_after_last_dice == 0
      puts " \s #{p_name}, you kept #{@keepers}, making your total #{@tally}."
    elsif p_num == 4 && @bet_once_after_last_dice == 0
      puts " \s The Computer kept #{@keepers}, making its total #{@tally}."
    end

    if @remaining == 0 && @bet_once_after_last_dice >= 1
      @bet = 0
      $the_bet = 0
    elsif @remaining == 0 && @bet_once_after_last_dice == 0
      puts " \s That was the last dice!"
    end
    
    if @remaining == 0
      check_for_a_winner(p_num, p_name)
    end
    
    if p_num == 1 || p_num == 3
      $purseP1 = @purse
      $tallyP1 = @tally
      $remainingP1 = 5 - @keepers.length
    elsif p_num == 2 || p_num == 4
      $purseP2 = @purse
      $tallyP2 = @tally
      $remainingP2 = 5 - @keepers.length
    end
  end

  def get_betting_input(p_num, p_name)
    @bet = ""
    input = gets.chomp
    @bet = input.to_i
    if input == 'quit'
      quit(p_num, p_name)
    elsif input == 'fold'
      fold(p_num, p_name)
    elsif input == 'intro'
      intro()
      get_betting_input(p_num, p_name)
    elsif input.empty?
      puts " \s You can bet 0 if you'd like but you've got to enter something..."
      get_betting_input(p_num, p_name)
    elsif @bet == @purse
      puts " \s DAMN! all in, you don't mess around"
    elsif @bet > @purse
      puts " \s No way pal, you've only got #{@purse} left"
      get_betting_input(p_num, p_name)
    elsif @bet > $purseP1 || @bet > $purseP2  
      puts " \s That's more than your opponent has left, are you just trying to humiliate him?"
      get_betting_input(p_num, p_name)
    elsif @bet < 0
      puts " \s Betting a negative number isn't going to fly..."
      get_betting_input(p_num, p_name)
    elsif @bet < $the_bet
      puts " \s #{input}! That's not enough to keep you in the game"
      get_betting_input(p_num, p_name)
    elsif input.length == 0
      puts " \s Nothing?!?, you can 'fold' or 'quit' but you've got to put something"
      get_betting_input(p_num, p_name)
    
    end
  end

  def remarks_for_raising(p_num)
    random = rand(5)
    if random == 0
      puts " \s Ok, that's a solid bet"
    elsif random == 1
      puts " \s That's what I like to see!"
    elsif random == 2
      puts " \s Keeping the game moving, good work"
    elsif random == 3
      puts " \s Keeping the pressure on, nice"
    elsif random == 4
      puts " \s This isn't your first rodeo"
    end        
  end

  def remarks_for_calling(p_num)
    random = rand(4)
    if random == 0
      puts " \s Ok, that's all you need to stay in"
    elsif random == 1
      puts " \s Conservative play but your hanging in"
    elsif random == 2
      puts " \s I see your not scared off that easily"
    elsif random == 3
      puts " \s Glad to see you're still in the game"
    end
  end

  def get_first_bet(p_num, p_name)
    if @bet_once_after_last_dice == 0
      if @purse == 0
        puts " \s Looks like your all in, so we'll skip betting"
      elsif $purseP1 == 0 || $purseP2 == 0
        puts " \s Looks like your opponent is all in, so we'll skip betting"
      elsif @purse > 0
        print "\n", "#{p_name}, you've got #{@purse} in your purse, what do wanna bet?  "
        
        get_betting_input(p_num, p_name)
        
        if input == '0'
          puts " \s Playing it safe I see..."
        elsif @bet >= 1
          remarks_for_raising(p_num)
        else
          puts " \s #{input.upcase}, you want to bet #{input.upcase}! Give me a break..."
          get_first_bet(p_num, p_name)
        end      
        
        @purse -= @bet
        $pot += @bet
        $the_bet = @bet
        if @remaining == 0
          @bet_once_after_last_dice +=1
        end
      end
    elsif @bet_once_after_last_dice > 0
    end
  end

  def computer_ahead()
    if $ratioP1 - $ratioCPU >= 2.0  # Ahead by more than 2
      if $purseP1 <= 7 || $purseP2 <= 7
        if $purseP1 < $purseP2
          @bet = $purseP1
          puts "The computer is going for the throat!  It's putting you all in by betting #{@bet}"
        elsif $purseP1 > $purseP2
          @bet = $purseP2
          puts "This is for the match people.....the Computer is ALL IN!!!!"
        end
      elsif $purseP1 > 7
        @bet = $the_bet + 4 + rand(2)
        puts "The computer thinks its got a edge on you... it put in #{@bet}"
      end
    elsif $ratioP1 - $ratioCPU < 2.0 # Ahead by less than 2
      if $purseP1 <= 3
        @bet = $purseP1
        puts "The computer is going for the throat!  It's putting you all in by betting #{@bet}"
      elsif $purseP1 >= 3
        @bet = $the_bet + rand(2) + 1
        puts "The computer thinks it's an even match... it put in #{@bet}"
      end
    end
    @purse -= @bet
    $pot += @bet
    $the_bet = @bet - $the_bet
    puts "pot = #{$pot}"
    puts "$the_bet = #{$the_bet}"
  end
  
  def computer_behind()
    if $ratioCPU - $ratioP1 < 2.0
      if $purseP1 <= 3
        @bet = $purseP1
        puts "The computer is going for the throat!  It's putting you all in by betting #{@bet} "
      elsif $purseP1 >= 3
        @bet = $the_bet
        puts "The computer thinks it's an even match... it put in #{@bet}"
      end
    elsif $ratioCPU - $ratioP1 >= 2.0
      @bet = $the_bet
      if @bet == 0
        puts "The computer thinks you have the edge... it's passing on betting"
      elsif @bet > 0
        @bet = $the_bet
        puts "The computer thinks you have the edge... but it's hanging in by betting #{@bet}"
      end
    end
  end

  def computer_tied()
    @bet = 0 + rand(3)
    puts "The computer thinks it's an even match... it put in #{@bet}"
  end

  def computer_get_first_bet(p_num, p_name)
    puts "\n"
    if @purse == 0
      puts " \s Looks like your all in, so we'll skip betting"
    elsif $purseP1 == 0 || $purseP2 == 0
      puts " \s Looks like your opponent is all in, so we'll skip betting"
    elsif @purse > 0      
      if $ratioP1 > $ratioCPU
        computer_ahead()
      elsif $ratioP1 < $ratioCPU 
        computer_behind()
      else
        computer_tied()
      end
      @purse -= @bet
      $pot += @bet
      $the_bet = @bet
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
    if $the_bet > 0
      @remaining = (5 - @keepers.length)
      print "#{p_name}, what are you in for?  "
      
      get_betting_input(p_num, p_name)
      
      if @bet > $the_bet
        remarks_for_raising(p_num)
        @purse -= @bet
        $pot += @bet
        $the_bet = @bet - $the_bet
      elsif @bet == $the_bet
        remarks_for_calling(p_num)
        @purse -= @bet
        $pot += @bet
        $the_bet = @bet - $the_bet
            end 
    end
  end 

  def computer_call_or_raise(p_num, p_name)
    if $the_bet > 0
      puts "\n"
      if $ratioCPU - $ratioP1 >= 7.0
        fold(p_num, p_name)
      elsif $the_bet > 0 && $ratioP1 >= $ratioCPU
        computer_ahead()
      elsif $the_bet > 0 && $ratioP1 < $ratioCPU 
        computer_behind()
      else
        computer_tied()
      end
      @purse -= @bet
      $pot += @bet
      $the_bet = @bet - $the_bet
    end
  end
  
  def fold_or_call(p_num, p_name)
    if $the_bet > 0
      @remaining = (5 - @keepers.length)
      print "#{p_name}, will ya match his bet or 'fold'  ?  "
      # input = gets.chomp.downcase
      #       @bet = input.to_i
      #       
      #       puts "\n"
            
      get_betting_input(p_num, p_name)
      
      # if input == 'quit'
      #   quit(p_num, p_name)
      # elsif input == 'fold'
      #   fold(p_num, p_name)
      # elsif input == 'intro'
      #   intro()
      #   fold_or_call(p_num, p_name)
      if @bet > $the_bet
        puts " \s Sorry, you already had your turn to raise"
        fold_or_call(p_num, p_name)
      elsif @bet == $the_bet  
        @purse -= @bet
        $pot += @bet

        # random = rand(3)
        # if random == 0
        #   puts " \s This isn't your first rodeo"
        # elsif random == 1
        #   puts " \s Oh damn, it's on!"
        # elsif random == 2
        #   puts " \s I see your not scared off that easily"
        # elsif random == 3
        #   puts " \s Glad to see you're still in the game"
        # end

        $the_bet = @bet - $the_bet
      elsif input.length == 0
        puts " \s Nothing?!?, you can 'fold' or 'quit' but you've got to put something"
      elsif @bet < $the_bet
        puts " \s #{input}! That's not enough to keep you in the game"
        fold_or_call(p_num, p_name)
      end
    end
  end

  def computer_fold_or_call(p_num, p_name)
    puts "\n"
    if $the_bet > 0
      if $ratioP1 > $ratioCPU || $ratioCPU - $ratioP1 < 7
        @bet = $the_bet
        puts "\n", "The Computer called your bet of #{@bet}", "\n"
      elsif $ratioCPU - $ratioP1 >= 7    
        fold(p_num, p_name)
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

  def fold(p_num, p_name)
    print "Leaving so soon? I guess this means............."
    if p_num == 1 || p_num == 3
      $purseP2 = @purse
      $purseP2 += $pot
      puts " \s #{$name2} you WON!!!!!"
    elsif p_num == 2 || p_num == 4
      $purseP1 = @purse
      $purseP1 += $pot
      puts " \s #{$name1} you WON!!!!!"
    end
    want_to_play_again(p_num)
  end

  def check_for_a_winner(p_num, p_name)
    puts "  def check_for_a_winner(p_num, p_name)"

    if p_num == 1 || p_num == 3
      $purseP1 = @purse
      $tallyP1 = @tally
      $remainingP1 = 5 - @keepers.length
    elsif p_num == 2 || p_num == 4
      $purseP2 = @purse
      $tallyP2 = @tally
      $remainingP2 = 5 - @keepers.length
    end
    puts "\t p_name = #{p_name}"
    # puts "\t $remainingP1 #{$remainingP1}"
    # puts "\t $remainingP2 #{$remainingP2} "
    # puts "\t $tallyP1 #{$tallyP1}"
    # puts "\t $tallyP2 #{$tallyP2}"
    puts "\t the pot = #{$pot}"
    puts "\t @purse = #{@purse}"
    puts "\t $purseP1 = #{$purseP1}"
    puts "\t $purseP2 = #{$purseP2}"
    puts "\t player 1 ratio is #{$ratioP1}"
    puts "\t computer's ratio is #{$ratioCPU}"
        
    
    if @remaining == 0    
      if @tally == 30
        puts " \s I do not believe this...... "
        puts " \s #{p_name}, you 'Shot The MOON'......"
        puts " \s and secured yourself the win! "
        check_if_bankrupt(p_num, p_name)
      elsif $remainingP1 == 0 && $remainingP2 == 0 && $tallyP1 == $tallyP2
        puts " \s I do not believe this...... you TIED!!!!!"
        puts " \s The money will stay in the pot for next time!"
        want_to_play_again(p_num)
      elsif $remainingP1 == 0 && $tallyP1 < $tallyP2
        $purseP1 = @purse
        $purseP1 += $pot
        check_if_bankrupt(p_num, $name1)
      elsif $remainingP2 == 0 && $tallyP1 > $tallyP2
        $purseP2 = @purse
        $purseP2 += $pot
        check_if_bankrupt(p_num, $name2)
      end
    end
  end
  
  def check_if_bankrupt(p_num, p_name)
    if @purse == 60 || @purse == 0
      puts " \s #{p_name} you bankrupted your opponent and are the overall CHAMPION!"
      Process.exit!(0)
    else
      puts " \s #{p_name}........ you WON!!!!!"
      puts " \s but the loser escaped to fight another day"
      want_to_play_again(p_num)
    end
  end
  
  def want_to_play_again(p_num)
    puts "Want to play again? (y/n)"
    input = gets.chomp
    if input == "y" && p_num <= 2
      play_2_player_game()
    elsif input == "y" && p_num >= 3
      vs_computer_game()
    elsif input == "n"
      puts "Later!"
      Process.exit!(0)
    else
      puts "I didn't understand"
      want_to_play_again(p_num)
    end
  end
end

def get_mode()
  puts "Do you want to play (1) player or (2) player mode?"
  # input = gets.chomp
  input = '1'
  if input == '1'
    puts "Type in your name(s) and you can join the game"
    # get_name_1()
    $name2 = "Computer"
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
  
  while true
    @human.roll(3, $name1) # roll > show > pick > report
    @computer.check_for_a_winner(4, $name2)
    @human.get_first_bet(3, $name1)
    break if $remainingP1 == 0 && $remainingP2 == 0
    break if $remainingP1 == 0 && $tallyP1 < $tallyP2
    break if $remainingP2 == 0 && $tallyP1 > $tallyP2
    @computer.computer_call_or_raise(4, $name2)  
    @human.fold_or_call(3, $name1)
    
    @computer.roll(4, $name2) # roll > show > pick >report
    @human.check_for_a_winner(3, $name1)
    @computer.computer_get_first_bet(4, $name2)
    break if $remainingP1 == 0 && $remainingP2 == 0
    break if $remainingP1 == 0 && $tallyP1 < $tallyP2
    break if $remainingP2 == 0 && $tallyP1 > $tallyP2
    @human.call_or_raise(3, $name1)
    @computer.computer_fold_or_call(4, $name2)    
  end
end

setup_purse()
get_mode()
