class Betting
  def purse
    @bet = 0 
    @purse = 25
  end

  def first_bet(p_num)
    print "Hey you, player#{p_num}, what do you want to start the betting at?  "
    @bet = STDIN.gets.to_i
    if @bet > @purse
      puts "No way pal, you've only got #{@purse} left"
      first_bet(p_num)
    elsif @bet == 0
      puts "You've at least got to anti up 1"
      first_bet(p_num)
    else
      @purse -= @bet
      $pot += @bet
      puts "You have #{@purse} left in your purse"
      $the_bet = @bet
      $p_num = p_num
    end
  end

  def call_or_raise(p_num)
    print "The bet stands at #{$the_bet}, "
    print "so player#{p_num} what are you in for?  "
    @bet = STDIN.gets.to_i
    if @bet > @purse
      puts "No way pal, you've only got #{@purse} left"
      call_or_raise(p_num)
    elsif @bet > $the_bet
      @purse -= @bet
      $pot += @bet
      puts "Raisin' eh? Bold Move"
      $the_bet = @bet - $the_bet
    elsif @bet == $the_bet  
      @purse -= @bet
      $pot += @bet
      puts "Callin' eh? It's good to play it safe"
      $the_bet = @bet - $the_bet
    elsif @bet < $the_bet
      puts "That's not enough to keep you in the game"
      call_or_raise(p_num)
    end
    $p_num = p_num
  end

  def win_it(p_num)
    puts "The dice landed on #{p_num}"
    puts "Player#{p_num} gets to take the pot which stood at #{$pot}"
    @purse += $pot
    puts "Player#{p_num} is now sitting on #{@purse}"
  end
end



@player1 = Betting.new
@player2 = Betting.new
@player1.purse
@player2.purse
$pot = 0
@player1.first_bet(1)


while $the_bet > 0
  if $p_num == 2
    @player1.call_or_raise(1)
  elsif $p_num == 1
    @player2.call_or_raise(2)
  end    
end

puts "The betting has ended"

random = rand(2)
if random == 0
  @player1.win_it(1)
elsif random == 1
  @player2.win_it(2)
end

