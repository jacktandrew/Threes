class Tourney
  def initialize()
    setup_players()
    create_game()
    play_it()
  end
  
  def setup_players()
    puts "How many player will join?"
    x = gets.chomp.to_i
    @players = []
    x.times do |counter|
      puts "Enter the name of player #{counter + 1}"
      name = gets.chomp
      @players.push(Player.new(name))
    end
  end

  def create_game()
    @game = Game.new(@players)
  end
  
  def play_it()
    while true
      break if tourney_over?() == true
      create_game()
    end
    taunts()
  end

  def tourney_over?()
    @players.select { |p| p.purse == 0 }.length == @players.length - 1
    # All the players with zero in the purse are selected
    # If the number of select players is one less than the total
    # One player remains with all the money and the tourney is over
  end

  def taunts()
    @players.each do |player|
      if player.purse == 0
        puts "#{player.name} you've disappointed your family..........."
      else
        puts "#{player.name}, you vanquished your opponent!"
      end
    end
  end
  
end

class Game
  def initialize(players)
    @players = players
    @ante = 1
    @bet = 0
    @pot = 0
    @round_over = false
    start_game()
  end
  
  def round_over()
    @round_over
  end
  
  def start_game()
    @players = @players.select do |player|
      did_ante = player.ante_up?(@ante) 
      if did_ante == true 
        @pot += @ante
      end
      did_ante
    end
  end
  
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

  def dice_remaining()
    # @remaining = 5 - @keepers.length    (Should be able to be deleted)

    if @remaining == 0
      check_for_a_winner()
      puts "\n", " \s #{@player.name}, picked all five and is done rolling"
    elsif @remaining == 1
      puts "\n", " \s #{@player.name}, last roll make it a good one!  ---  Hit <ENTER> to Roll"
    elsif @remaining > 1
      puts "\n", " \s #{@player.name}, Hit <ENTER> to Roll" 
    end
    roll()
  end  
    
  def roll()
    STDIN.gets
    @val = []
    # @remaining = 5 - @keepers.length    (Should be able to be deleted)
    while @val.length < @remaining
      r = rand(6) + 1
      @val.push(r)
    end
    show()    
  end

  def show()
    num = 1
    @val.each do |v|
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
    if player.is_human? == true
      pick(p_num, p_name)
    else
      computer_pick(p_num, p_name)
    end
  end

  def get_word_commands()
    if @input == 'quit'
      quit(p_num, p_name)
    elsif @input == 'fold'
      fold(p_num, p_name)
    elsif @input == 'help'
      intro()
    end
  end
  
  def pick()
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
              value = @val[@in_digit]
              @keepers.push(value)
              if value == 3
                # 3 counts as 0 so @tally is not increased
              else
                @tally += value
              end # value == 3
              @remaining -= 1
            end # if remaining
          end # for loop
          break
        end
      end
    end
    report_choices(p_num, p_name)
  end

  def computer_pick()
    picked = 0
    @val.each do |value|
      if value == 1 || value == 3
        @keepers.push(value)
        picked += 1
        if value == 3
        else
          @tally += value
        end
        @remaining -= 1
      end
    end

    if picked == 0
      value = @val.sort.slice(0)
      @keepers.push(value)      
      @tally += value
      @remaining -= 1
    end
    report_choices(p_num, p_name)
  end
    
  def report_choices()
    # @remaining = 5 - @keepers.length    (Should be able to be deleted)
    update_purse(p_num)
    puts "\n"  
    if @remaining == 0
      if @times_bet_after_last_dice == 0
        puts " \s That was the last dice!"
      end
      check_for_a_winner(p_num, p_name)
    end
    puts " \s #{@player.name}, kept #{@keepers}, for a total of #{@tally}."
  end

  def get_betting_input()
    while true
      print "\n", "The bet stands at #{$the_bet} #{@player.name} has #{@player.purse} in the purse, what's your bet?  "
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
      elsif @bet > @player.purse
        puts " \s No way pal, you've only got #{@player.purse} left"
      elsif @bet == $the_bet
        break
        update_purse(p_num)
        remarks_for_calling(p_num)
      elsif @bet > $the_bet
        break
      end
    end
  end

  def remarks_for_raising()
    puts "\n"
    if @bet == @player.purse
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

  def remarks_for_calling()
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

  def get_first_bet()
    if @times_bet_after_last_dice == 0
      if player.purse == 0
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
          @times_bet_after_last_dice +=1
        end
      end
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
    puts "#{$name1} $purseP1 #{$purseP1}"
    puts "#{$name2} $purseP2 #{$purseP2}"
    puts "Should be 100 = #{$purseP1 + $purseP2 + $pot}"
    puts "$pot #{$pot}"

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
  
  def fold_or_call(p_num, p_name)
    # puts "  def fold_or_call(p_num, p_name)"
    # puts "\t $the_bet = #{$the_bet}"
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

  def quit(p_num, p_name)
    puts "Better luck next time..."
    puts "Player #{p_name} lost.."
    Process.exit!(0)
  end

  def fold(p_num, p_name)
    puts "#{p_name} folded and so lost the game", "\n"
    if p_num.odd?
      # $purseP2 = @purse
      $purseP2 += $pot
      puts " \s #{$name2} you WON!!!!! and took home a pot of #{$pot}"
    elsif p_num.even?
      # $purseP1 = @purse
      $purseP1 += $pot
      puts " \s #{$name1} you WON!!!!! and took home a pot of #{$pot}"
    end
    $pot = 0
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
    if $purseP1 + $purseP2 + $pot != 100
      puts "Error!"
      STDIN.gets
    end
    # puts "$purseP1 #{$purseP1}"
    # puts "$purseP2 #{$purseP2}"
    # puts "$pot #{$pot}"
    # puts "Should be 100 = #{$purseP1 + $purseP2 + $pot}"

 
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
      $purseP1 += $pot
      check_if_bankrupt(p_num, $name1)
    elsif $remainingP2 == 0 && $tallyP1 > $tallyP2
      $purseP2 += $pot
      check_if_bankrupt(p_num, $name2)
    end
  end
  
  def check_if_bankrupt(p_num, p_name)
    if @purse == 60 || @purse == 0
      puts " \s #{p_name} you bankrupted your opponent and are the overall CHAMPION!"
      Process.exit!(0)
    else
      puts " \s #{p_name} with a tally of #{@tally}........ you WON and took away a pot of #{$pot}!!!!!"
      puts " \s but the loser escaped to fight another day"
      want_to_play_again(p_num)
    end
  end
  
  def want_to_play_again(p_num)
    puts "Want to play again? Hit <ENTER> or type 'quit'"
    
    puts "@purse #{@purse}"
    puts "#{$name1} $purseP1 #{$purseP1}"
    puts "#{$name2} $purseP2 #{$purseP2}"
    puts "Should be 100 = #{$purseP1 + $purseP2 + $pot}"
    puts "$pot #{$pot}"
    
    
    # input = gets.chomp
    # if input == "quit"
    #   puts "Later!"
    #   Process.exit!(0)    
    # elsif p_num <= 2
    #   play_2_player_game()
    # elsif p_num >= 3
    #   play_2_computer_game()
    # end
    
    play_2_computer_game()
  end
end

class Player
  def initialize(name)
    @name = name
    @human = true # human || false
    @purse = 50   # purse || 50
  end

  def name()
    @name
  end
  
  def purse()
    @purse
  end
  
  def is_human?()
    @human
  end
  
  def ante_up?(ante)
    if @purse < ante
      puts "Too bad you're too poor to play this round your purse is #{@purse} and the ante is #{ante}"
      return false
    end
    
    if @human == true
      puts "The ante is #{ante} this round, are you in? [Y/n]"
      input = gets.chomp
      if input == 'n'
        return false
      else
        return anteing(ante)
      end
    elsif @human == false
      random = rand(10)
      if random == 1
        return false
      else
        return anteing(ante)
      end
    end
  end
  
  def anteing(ante)
    print "#{@name} is in the round \t"
    @purse -= ante
    return true
  end
  
  def ask_for_name
    print "Player name > "
    @name = gets.chomp.capitalize
    if @name.length == 0 
      puts "I didn't catch that can you repeat it"
      get_name()
    else
    end
  end
end

@tourney = Tourney.new
