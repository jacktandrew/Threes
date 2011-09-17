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

  def still_going
    @still_going = true
  end

  def tally
    @tally = 0
  end

  def purse
    @purse = 30
    @aside = 0
    @keepers = []
    @remaining = 5 - @keepers.length
  end

  def roll(p_num)
    if @aside == 5
      @still_going = false
    elsif @aside < 5
     puts "Player #{p_num} Hit (ENTER) to Roll"
     STDIN.gets
      $val = []
      while $val.length < 5 - @aside
        r = rand(6) + 1
        $val.push(r)
      end
      return $val
    end
  end

  def show(p_num)
    if @aside < 5
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
    elsif @aside == 5
      puts "Player #{p_num}, it looks like you've picked all five so you're done rolling"
    end
  end
    
  def pick(p_num)
    if @aside < 5
        print "Which ones do you Player #{p_num} wanna keep? "
      input = nil
      input_array = nil
      input = gets.chomp
      
      if input == 'out'
        puts "Better luck next time..."
        puts "Player #{p_num} lost.."
        Process.exit!(0)
      elsif input == 'end'
        if $tallyP1 < $tallyP2
          puts "Player 1........ you WON!!!!!"
        elsif @first_player.tally > @second_player.tally
          puts "Player 2........ you WON!!!!!"
        elsif @first_player.tally == @second_player.tally
          puts "I do not believe this...... you TIED!!!!!"
        end
      elsif input.empty?
        puts "You may not like your choices but you've got to pick something"
        input = nil
        pick(p_num)
      elsif input.to_i == 0
        puts "The choices go 1-5! Symbols or the ABC's are not goin' to cut it"
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
            @in_digit -= 1
            value = $val[@in_digit]
            @keepers.push(value)
            if value == 3
              value = 0
              @aside += 1
            else
              if p_num == 1
                @tally += value
                @aside += 1
                $tallyP1 += 1
              elsif p_num == 2
                @tally += value
                @aside += 1
                $tallyP2 += 1
              end
            end
          end
        end
      end
    elsif @aside == 5
    end
  end
    
  def report_choices(p_num)
    if @aside < 5
    results = <<RESULTS 

    Player #{p_num} kept #{@keepers}, making his total is #{@tally}.

RESULTS
    print results
    elsif @aside == 5
    end
  end
  
  def get_first_bet(p_num)
    if @purse > 0
      if @still_going == true
        print "Hey Player #{p_num}, what do wanna bet?  "
        @bet = ""
        input = gets.chomp
        @bet = input.to_i
        if input == 'out'
          puts "Better luck next time..."
          puts "Player #{p_num} lost.."
          Process.exit!(0)
        elsif input == 'end'
          if $tallyP1 < $tallyP2
            puts "Player 1........ you WON!!!!!"
          elsif $tallyP1 > $tallyP2
            puts "Player 2........ you WON!!!!!"
          elsif $tallyP1 == $tallyP2
            puts "I do not believe this...... you TIED!!!!!"
          end
          Process.exit!(0)
        elsif @bet == nil  
          puts "\n", " \s You can bet 0 if you'd like but you've got to enter something...", "\n"
          get_first_bet(p_num)
        elsif @bet == @purse
          puts "\n", " \s DAMN! all, you don't mess around", "\n"
        elsif @bet < 0
          puts "\n", " \s Betting a negative number isn't going to fly...", "\n"
          get_first_bet(p_num)
        elsif @bet > @purse
          puts "\n", " \s No way pal, you've only got #{@purse} left", "\n"
          get_first_bet(p_num)
        elsif input == '0'
          puts "\n", " \s Playing it safe I see...", "\n"
        elsif @bet >= 1
          puts "\n", " \s Ok, that's a solid bet", "\n"
        else
          puts "\n", " \s #{input.upcase}, you want to bet #{input.upcase}! Give me a break...", "\n"
          get_first_bet(p_num)
        end
      elsif @still_going == false
        # puts "\n", " \s Since you're done rolling we'll skip to the other guys turn", "\n"
      end
    elsif @purse == 0
      puts "\n", " \s Looks like your bust, so we'll skip betting", "\n"
    end
  end
  
  def process_bet(p_num)
    if @still_going == true
      if @purse > 0
            @purse -= @bet
        $pot += @bet
        puts "The pot is #{$pot} and you have #{@purse} left in your purse"
        $the_bet = @bet
      elsif @purse == 0
      end
    elsif @still_going == false
          if $tallyP1 < $tallyP2
            puts "Player 1........ you WON!!!!!"
          elsif $tallyP1 > $tallyP2
            puts "Player 2........ you WON!!!!!"
          elsif $tallyP1 == $tallyP2
            puts "I do not believe this...... you TIED!!!!!"
          end
      Process.exit!(0)
    end
  end

  def call_or_raise(p_num)
    if $the_bet > 0
      @remaining = (5 - @keepers.length)
      puts "\n", "Ok Player #{p_num}, the bet stands at #{$the_bet}, your total is #{@tally}, and you've got #{@remaining} dice left", "\n"
      print "so Player #{p_num}, what are you in for?  "
      input = gets.chomp
      @bet = input.to_i
      if input == 'out'
        puts "Better luck next time..."
        puts "Player #{p_num} lost.."
        Process.exit!(0)
      elsif input == 'end'
        if $tallyP1 < $tallyP2
          puts "Player 1........ you WON!!!!!"
        elsif $tallyP1 > $tallyP2
          puts "Player 2........ you WON!!!!!"
        elsif $tallyP1 == $tallyP2
          puts "I do not believe this...... you TIED!!!!!"
        end
        Process.exit!(0)
      elsif @bet > @purse
        puts "\n", " \s #{@bet}! No way pal, you've only got #{@purse} left"
        call_or_raise(p_num)
      elsif @bet > $the_bet
        @purse -= @bet
        $pot += @bet
        puts "\n", " \s Raisin' eh? Bold Move", "\n"
        $the_bet = @bet - $the_bet
      elsif @bet == $the_bet  
        @purse -= @bet
        $pot += @bet
        puts "\n", " \s Callin' eh? It's good to play it safe now and then", "\n"
        $the_bet = @bet - $the_bet
          elsif @bet == @purse
        puts "\n", " \s so it looks like you're all in, I guess we'll just see where the dice land"
      elsif @bet < $the_bet
        puts "\n", " \s #{input}! That's not enough to keep you in the game"
        call_or_raise(p_num)
      end
    end
  end
  
  def fold_or_call(p_num)
    if $the_bet > 0
      puts "\n", "Ok Player #{p_num}, the bet stands at #{$the_bet}, your total is #{@tally}, and you've got #{@remaining} dice left", "\n"
      print "Player #{p_num}, will ya match his bet or are you  'out'  ?  "
      input = gets.chomp
      @bet = input.to_i
      if input == 'out'
        puts "Better luck next time..."
        puts "Player #{p_num} lost.."
        Process.exit!(0)
      elsif input == 'end'
        if $tallyP1 < $tallyP2
          puts "Player 1........ you WON!!!!!"
        elsif $tallyP1 > $tallyP2
          puts "Player 2........ you WON!!!!!"
        elsif $tallyP1 == $tallyP2
          puts "I do not believe this...... you TIED!!!!!"
        end
        Process.exit!(0)
      elsif @bet > $the_bet
        puts "\n", " \s Sorry, you already had your turn to raise", "\n"
        fold_or_call(p_num)
      elsif @bet == $the_bet  
        @purse -= @bet
        $pot += @bet
        puts "\n", " \s Glad to see you're still in the game", "\n"
        $the_bet = @bet - $the_bet
          elsif @bet < $the_bet
        puts "\n", " \s #{input}! That's not enough to keep you in the game"
        fold_or_call(p_num)
      end
    end
  end
end

def player_1_roll
  @first_player.roll(1)
  @first_player.show(1)
  @first_player.pick(1)
  @first_player.report_choices(1)
  @first_player.get_first_bet(1)
  @first_player.process_bet(1)
  @second_player.call_or_raise(2)
  @first_player.fold_or_call(1)
  player_2_roll()
end

def player_2_roll
  @second_player.roll(2)
  @second_player.show(2)
  @second_player.pick(2)
  @second_player.report_choices(2)
  @second_player.get_first_bet(2)
  @second_player.process_bet(2)
  @first_player.call_or_raise(1)
  @second_player.fold_or_call(2)
  player_1_roll()
end

@first_player = DiceGame.new
@first_player.still_going
@first_player.purse
@first_player.tally

@second_player = DiceGame.new
@second_player.still_going
@second_player.purse
@second_player.tally

$pot = 0
$the_bet = 0
$tallyP1 = 0
$tallyP2 = 0

player_1_roll()


# def determine_the_winner        
#   if @first_player.tally < @second_player.tally
#     puts "Player 1........ you WON!!!!!"
#   elsif @first_player.tally > @second_player.tally
#     puts "Player 2........ you WON!!!!!"
#   elsif @first_player.tally == @second_player.tally
#     puts "I do not believe this...... you TIED!!!!!"
#   end
# end