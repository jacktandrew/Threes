class DiceGame
  def help
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
    if p_num.odd?
      @purse = $purseP1
    elsif p_num.even?
      @purse = $purseP2
    end
    @keepers = []
    @remaining = 5 - @keepers.length
    @tally = 0
    @bet = 0
    @bet_once_after_last_dice = 0
    $the_bet = 0
    $remainingP1 = 5
    $remainingP2 = 5
    $tallyP1 = 0
    $tallyP2 = 0
    $ratioP1 = @remaining + @tally
    $ratioP2 = @remaining + @tally
  end

  def roll(p_num, p_name)
    $the_bet = 0
    @bet = 0
    @remaining = 5 - @keepers.length
    if @remaining == 0
      check_for_a_winner(p_num, p_name)
      if p_num < 4
        puts " \s #{p_name}, it looks like you've picked all five so you're done rolling"
      elsif p_num >= 4
        puts "The Computer, picked all five so its done rolling"
      end
    elsif @remaining >= 1
      if @remaining == 1
        if p_num < 4
          puts "\n", "#{p_name}, it's your last roll make it a good one!  ---  Hit (ENTER) to Roll"
        elsif p_num >= 4
          puts "\n", "Hit <ENTER> to let the computer take its last turn"
        end
      elsif @remaining > 1
        if p_num < 4
          puts "\n", "#{p_name} Hit <ENTER> to Roll" 
        elsif p_num >= 4
          puts "\n", "Hit <ENTER> to let the computer take its turn"
        end
      end
#      STDIN.gets
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
    elsif p_num >= 4
      computer_pick(p_num, p_name)
    end
  end

  def get_word_commands(p_num, p_name)
    if @input == 'quit'
      quit(p_num, p_name)
    elsif @input == 'fold'
      fold(p_num, p_name)
    elsif @input == 'help'
      intro()
    end
  end
  
  def pick(p_num, p_name)
    while true
      print "\n", "Which ones do you wanna keep? "
      @input = gets.chomp
      @remaining = 5 - @keepers.length
      get_word_commands(p_num, p_name)
      if @input.empty?
        puts "You may not like your choices but you've got to pick something"
      elsif @input.to_i < 1
        puts "The choices go 1-5! Symbols or the ABC's are not goin' to cut it"
      else
        array = @input.split('') 
        array = array.delete_if {|x| x > '5' || x < '1' }
        input_array = array.uniq
        if input_array.length == 0
          puts "None of your answers made any sense..."
        elsif input_array.length > 0
          input_array.each do |inp|
            @in_digit = inp.to_i 
            if @in_digit > @remaining
              puts "#{@in_digit} wasn't available to you so we just excluded it..."
            else            
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
              end # value == 3
            end # if remaining
          end # for loop
          break
        end
      end
    end
    @remaining = 5 - @keepers.length
    $ratioP1 = @remaining + @tally
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
    if p_num.odd?
      $ratioP1 = @remaining * 1.5 + @tally
    elsif p_num.even?
      $ratioP2 = @remaining * 1.5 + @tally
    end
    report_choices(p_num, p_name)
  end
    
  def report_choices(p_num, p_name)
    @remaining = 5 - @keepers.length
    update_purse(p_num)
    puts "\n"
    if p_num < 4 && @bet_once_after_last_dice == 0
      puts " \s #{p_name}, you kept #{@keepers}, making your total #{@tally}."
    elsif p_num >= 4 && @bet_once_after_last_dice == 0
      puts " \s #{p_name} kept #{@keepers}, making its total #{@tally}."
    end

    if @remaining == 0 && @bet_once_after_last_dice >= 1
      @bet = 0
      $the_bet = 0
      check_for_a_winner(p_num, p_name)
    elsif @remaining == 0 && @bet_once_after_last_dice == 0
      puts " \s That was the last dice!"
      check_for_a_winner(p_num, p_name)
    end
  end

  def get_betting_input(p_num, p_name)
    while true
      print "\n", "#{p_name}, the bet stands at #{$the_bet} you've got #{@purse} in your purse, what's your bet?  "
      @input = gets.chomp
      @bet = @input.to_i
      get_word_commands(p_num, p_name)
      puts "\n"
      if @input.empty?
        puts " \s You can bet 0 if you'd like but you've got to enter something..."
      elsif @input =~ /[A-Za-z]+/
        puts " \s #{@input.upcase}, you want to bet #{@input.upcase}! Give me a break..."
      elsif @bet < 0
        puts " \s Betting a negative number isn't going to fly..."
      elsif @bet < $the_bet
        puts " \s #{@input.upcase}! That's not enough to keep you in the game"
      elsif @bet > @purse
        puts " \s No way pal, you've only got #{@purse} left"
      elsif @bet > $purseP1 || @bet > $purseP2 && @bet != $the_bet
        puts " \s That's more than your opponent has left, are you just trying to humiliate him?"
      elsif @bet == $the_bet
        break
        update_purse(p_num)
        remarks_for_calling(p_num)
      elsif @bet > $the_bet
        break
      end
    end
  end

  def remarks_for_raising(p_num)
    puts "\n"
    if @bet == @purse
      puts " \s DAMN! all in, you don't mess around"
    else
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
        get_betting_input(p_num, p_name)
        
        if @bet >= 1
          update_purse(p_num)
          remarks_for_raising(p_num)
        end      
        
        if @remaining == 0
          @bet_once_after_last_dice +=1
        end
      end
    end
  end

  def computer_ahead(p_num, p_name)
    if $ratioP1 - $ratioP2 >= 2.0  # Ahead by more than 2
      if $purseP1 <= 7 || $purseP2 <= 7 || $the_bet > $purseP1
        if $purseP1 < $purseP2
          @bet = $the_bet + $purseP1
          puts "#{p_name} is going for the throat!  It's putting you all in by betting #{@bet}"
        elsif $purseP1 > $purseP2
          @bet = $the_bet + $purseP2
          puts "This is for the match people..... #{p_name} is ALL IN!!!!"
        end
      elsif $purseP1 > 7
        @bet = $the_bet + 4 + rand(2)
        computer_exude_confidence(p_num, p_name)
      end
    elsif $ratioP1 - $ratioP2 < 2.0 # Ahead by less than 2
      if $purseP1 <= 3
        @bet = $the_bet + $purseP1
        puts "#{p_name} is going for the throat!  It's putting you all in by betting #{@bet}"
      elsif $purseP1 >= 3
        @bet = $the_bet + rand(2) + 1
        computer_exude_caution(p_num, p_name)
      end
    end
  end

  def computer_behind(p_num, p_name)
    if $ratioP2 - $ratioP1 < 2.0
      if $purseP1 <= 3
        @bet = $the_bet + $purseP1
        puts "#{p_name} is going for the throat!  It's putting you all in by betting #{@bet} "
      elsif $purseP1 >= 3
        @bet = $the_bet
        computer_exude_caution(p_num, p_name)
      end
    elsif $ratioP2 - $ratioP1 >= 2.0
      @bet = $the_bet
      if @bet == 0
        puts "#{p_name} thinks you have the edge... it's passing on betting"
      elsif @bet > 0
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

  def computer_get_first_bet(p_num, p_name)
    puts "\n"
    if @purse == 0
      puts " \s Looks like your all in, so we'll skip betting"
    elsif $purseP1 == 0 || $purseP2 == 0
      puts " \s Looks like your opponent is all in, so we'll skip betting"
    elsif @purse > 0      
      if $ratioP1 > $ratioP2
        computer_ahead(p_num, p_name)
      elsif $ratioP1 <= $ratioP2 
        computer_behind(p_num, p_name)
      end
      update_purse(p_num)
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
      get_betting_input(p_num, p_name)
      if @bet > $the_bet
        remarks_for_raising(p_num)
      elsif @bet == $the_bet
        remarks_for_calling(p_num)
      end
      update_purse(p_num)
    end
  end 

  def computer_call_or_raise(p_num, p_name)
    if $the_bet > 0
      puts "\n"
      if $ratioP2 - $ratioP1 >= 7.0
        fold(p_num, p_name)
      elsif $ratioP1 >= $ratioP2
        computer_ahead(p_num, p_name)
      elsif $ratioP1 < $ratioP2 
        computer_behind(p_num, p_name)
      end
      update_purse(p_num)
    end
  end
  
  def fold_or_call(p_num, p_name)
    puts "  def fold_or_call(p_num, p_name)"
    puts "\t $the_bet = #{$the_bet}"
    if $the_bet > 0
      @remaining = (5 - @keepers.length)
      get_betting_input(p_num, p_name)
      
      if @bet > $the_bet
        @bet = $the_bet
        puts " \s Sorry, you already had your turn to raise..."
        puts " \s We'll just put you in for #{@bet} since that's most you can bet until next turn"
      elsif @bet == $the_bet
        remarks_for_calling(p_num)
      end
      update_purse(p_num)
    end
  end

  def computer_fold_or_call(p_num, p_name)
    puts "\n"
    if $purseP1 > 0 && $purseP2 > 0
      if $the_bet > 0
        if $ratioP1 > $ratioP2 || $ratioP2 - $ratioP1 < 7
          @bet = $the_bet
          puts "\n", "#{p_name} called your bet of #{@bet}", "\n"
        elsif $ratioP2 - $ratioP1 >= 7    
          fold(p_num, p_name)
        end
        update_purse(p_num)
      end
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
    elsif p_num == 2 || p_num >= 4
      $purseP1 = @purse
      $purseP1 += $pot
      puts " \s #{$name1} you WON!!!!!"
    end
    want_to_play_again(p_num)
  end

  def update_purse(p_num)

    @purse -= @bet
    $pot += @bet
    $the_bet = @bet - $the_bet
    
    if p_num.odd?
      $purseP1 = @purse
      $tallyP1 = @tally
      $remainingP1 = 5 - @keepers.length
    elsif p_num.even?
      $purseP2 = @purse
      $tallyP2 = @tally
      $remainingP2 = 5 - @keepers.length
    end
  end

  def check_for_a_winner(p_num, p_name)
    
    puts "\s def update_purse(p_num)"
    puts "\t p_num = #{p_num}"
    puts "\t $remainingP1 #{$remainingP1}"
    puts "\t $remainingP2 #{$remainingP2} "
    puts "\t $tallyP1 #{$tallyP1}"
    puts "\t $tallyP2 #{$tallyP2}"
    puts "\t the pot = #{$pot}"
    puts "\t @bet = #{@bet}"
    puts "\t $the_bet = #{$the_bet}"
    puts "\t @purse = #{@purse}"
    puts "\t $purseP1 = #{$purseP1}"
    puts "\t $purseP2 = #{$purseP2}"
    puts "\t player 1 ratio is #{$ratioP1}"
    puts "\t plater 2 ratio is #{$ratioP2}"
    
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
        $pot = 0
        check_if_bankrupt(p_num, $name1)
      elsif $remainingP2 == 0 && $tallyP1 > $tallyP2
        $purseP2 = @purse
        $purseP2 += $pot
        $pot = 0
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
    
    puts "Want to play again? Hit <ENTER> or type 'quit'"
    input = gets.chomp

    if input == "quit"
      puts "Later!"
      Process.exit!(0)    
    elsif p_num <= 2
      play_2_player_game()
    elsif p_num >= 3
      play_2_computer_game()
    end
  end
end

def get_mode()
  puts "Do you want to play (1) player or (2) player mode?"
  # input = gets.chomp
  input = '0'
  if input == '0'
    play_2_computer_game()
  elsif input == '1'
    puts "Type in your name(s) and you can join the game"
    # get_name_1()
    # get_name_2()
    vs_computer_game()
  elsif input == '2'
    # get_name_1()
    # get_name_2()
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
  $pot = 0
end

def play_2_player_game()
  @first_player = DiceGame.new
  # @first_player.get_name(1)
  @first_player.purse(1)
  @second_player = DiceGame.new
  @second_player.purse(2)
  # @second_player.get_name(2)
  
  $the_bet = 0
  $tallyP1 = 0
  $tallyP2 = 0
  $remainingP1 = 5
  $remainingP2 = 5
  
  while true
    @first_player.roll(1, $name1) # roll > show > pick
    @first_player.report_choices(1, $name1) # report > get_first_bet
    # break if $remainingP1 == 0 && $remainingP2 == 0
    # break if $remainingP1 == 0 && $tallyP1 < $tallyP2
    # break if $remainingP2 == 0 && $tallyP1 > $tallyP2
    @first_player.check_for_a_winner(1, $name1)
    # @first_player.get_first_bet(1)
    @second_player.run_down(2, $name2)
    @second_player.call_or_raise(2, $name2)
#    @first_player.run_down(1, $name1)
    @first_player.fold_or_call(1, $name1)
  
    @second_player.roll(2, $name2) # roll > show > pick
    @second_player.report_choices(2, $name2) # report > get_first_bet
    # break if $remainingP1 == 0 && $remainingP2 == 0
    # break if $remainingP1 == 0 && $tallyP1 < $tallyP2
    # break if $remainingP2 == 0 && $tallyP1 > $tallyP2
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
  $the_bet = 0
  
  while true
    @human.roll(3, $name1) # roll > show > pick > report
    @computer.check_for_a_winner(4, $name2)
    @human.get_first_bet(3, $name1)
    @computer.computer_call_or_raise(4, $name2)  
    @human.fold_or_call(3, $name1)
    
    @computer.roll(4, $name2) # roll > show > pick >report
    @human.check_for_a_winner(3, $name1)
    @computer.computer_get_first_bet(4, $name2)
    @human.call_or_raise(3, $name1)
    @computer.computer_fold_or_call(4, $name2)    
  end
end

def play_2_computer_game()
  $name1 = "r2d2"
  $name2 = "hal"
  @hal = DiceGame.new
  @hal.purse(5)
  @r2d2 = DiceGame.new
  @r2d2.purse(4)
  $the_bet = 0
  
  while true
    @hal.roll(5, $name1) # roll > show > pick > report
    @r2d2.check_for_a_winner(4, $name2)
    @hal.computer_get_first_bet(5, $name1)
    @r2d2.computer_call_or_raise(4, $name2)  
    @hal.computer_fold_or_call(5, $name1)
    
    @r2d2.roll(4, $name2) # roll > show > pick >report
    @hal.check_for_a_winner(5, $name1)
    @r2d2.computer_get_first_bet(4, $name2)
    @hal.computer_call_or_raise(5, $name1)
    @r2d2.computer_fold_or_call(4, $name2)    
  end
end

setup_purse()
get_mode()
