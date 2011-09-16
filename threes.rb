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

  def remain
    @remain = 5 - @keepers.length
  end
  
  def purse
    @keepers = []
    @tally = 0
    @remain = 5
    @purse = 25
    @pot = 0
  end
  
  def roll(remaining_dice, p_num)
   puts "Player #{p_num} Hit (ENTER) to Roll"
   STDIN.gets
    $val = []
    while $val.length < remaining_dice
      r = rand(6) + 1
      $val.push(r)
    end
    return $val
  end

  def show
    six = <<SIX
          _______
              |  o  o |
              |  o  o |
              |  o  o |
              |_______|
SIX

five = <<FIVE
        _______
            | o   o |
            |   o   |
            | o   o |
            |_______|
FIVE

four = <<FOUR                                    
      _______
          | o   o |
          |       |
          | o   o |
          |_______|
FOUR

three = <<THREE
    _______
        | o     |
        |   o   |
        |     o |
        |_______|
THREE

two = <<TWO
  _______
      | o     |
      |       |
      |     o |
      |_______|
TWO

one = <<ONE
_______
    |       |
    |   o   |
    |       |
    |_______|
ONE
    num = 1
    $val.each do |v|
      print " #{num}. \s"
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
      else  
      end
      num += 1
    end
  end
    
  def pick(p_num)
    print "Which ones do you player #{p_num} wanna keep? "
    input = gets.chomp
    
    if input == 'out'
      puts "Better luck next time..."
      puts "Player #{p_num} lost.."
      Process.exit!(0)
    else    
      input_array = input.split('')
      input_array.each do |inp|
        @in_digit = (inp.to_i) 
        if @in_digit.to_i < 1 || @in_digit.to_i > $val.length
          puts "So Yeah... that's not an option... "
          pick(p_num)
        else
          @in_digit -= 1
          value = $val[@in_digit]
          @keepers.push(value)
          if value == 3
            value = 0
          else
            @tally += value
          end
        end
      end
    end       # end of 'for block'
  end
    
  def report_choices(p_num)
    results = <<RESULTS 

    Player #{p_num} kept #{@keepers}, making his total is #{@tally}.

RESULTS
    print results
  end
  
  def first_bet(p_num)
    print "Hey player #{p_num}, what do wanna bet?  "
    @bet = STDIN.gets.to_i
    if @bet > @purse
      puts "No way pal, you've only got #{@purse} left"
      first_bet(p_num)
    else
      @purse -= @bet
      $pot += @bet
      puts "The pot is #{$pot} and you have #{@purse} left in your purse", ""
      $the_bet = @bet
      $p_num = p_num
    end
  end

  def call_or_raise(p_num)
    puts "The bet stands at #{$the_bet}, your total is #{@tally} "
    print "so player #{p_num} what are you in for?  "
    @bet = STDIN.gets.to_i
    if @bet > @purse
      puts "\t No way pal, you've only got #{@purse} left"
      call_or_raise(p_num)
    elsif @bet > $the_bet
      @purse -= @bet
      $pot += @bet
      puts "\n","\t Raisin' eh? Bold Move", "\n"
      $the_bet = @bet - $the_bet
    elsif @bet == $the_bet  
      @purse -= @bet
      $pot += @bet
      puts "\n","\t Callin' eh? It's good to play it safe", "\n"
      $the_bet = @bet - $the_bet
    elsif @bet < $the_bet
      puts "\t That's not enough to keep you in the game"
      call_or_raise(p_num)
    end
    $p_num = p_num
  end
end

# get_name()
@first_player = DiceGame.new
@second_player = DiceGame.new
@first_player.purse
@second_player.purse
$pot = 0

while true
  break if @first_player.remain == 0
  @first_player.roll(@first_player.remain, 1)
  @first_player.show
  @first_player.pick(1)
  @first_player.report_choices(1)
  @first_player.first_bet(1)
  
  while $the_bet > 0
    if $p_num == 2
      @first_player.call_or_raise(1)
    elsif $p_num == 1
      @second_player.call_or_raise(2)
    end    
  end
  
  break if @first_player.remain == 0
  @second_player.roll(@second_player.remain, 2)
  @second_player.show
  @second_player.pick(2)
  @second_player.report_choices(2)
  @second_player.first_bet(2)

  while $the_bet > 0
    if $p_num == 2
      @first_player.call_or_raise(1)
    elsif $p_num == 1
      @second_player.call_or_raise(2)
    end
  end
end

  # @purse += $pot
  # puts "Player#{p_num} is now sitting on #{@purse}"


