class Game
  def initialize(players)
    @players = players
    @ante = 1
    @pot = 0
    @bet = 0
    @the_bet = 0
    @players_done = 0
    @game_over == false
    @players.each do |player|
      player.init_temp_vars()
    end
    check_ante()
    play_game()
  end
  
  def check_ante()
    # ante up
    @players = @players.select do |player|
      did_ante = player.ante_up?(@ante) 
      if did_ante == true 
        @pot += @ante
      end
      did_ante
    end
  end
    
  def play_game()  
    @players.each do |player|
      next if player.has_folded?() == true
      if player.remaining > 0
        roll(player)
        show()
        pick_input(player)
        report_choices(player)
        if player.purse == 0
          puts " \s Looks like you're all in, so we'll skip betting"
        else
          first_bet(player)
          take_bets(player)
          call_or_fold(player)
        end
      else
        puts "\n", " \s #{player.name}, picked all five and is done rolling"
        @total_players_done += 1
        
        if @players_done == @players.length
          @game_over = true
          check_for_a_winner()
        end
      end
    end
    
    while @game_over == false
      play_game()
    end
  end
  
  def first_bet(player)
    bet_input(player)
    transfer_funds(player)
    player.push_bet(@bet)
  end
  
  def take_bets(player)
    @players.each do |player|
      if player.bet < @the_bet
        bet_input(player)
        transfer_funds(player)
        player.push_bet(@bet)
      end
      puts "#{player.name} is in for #{@bet}"
    end
  end
  
  def call_or_fold(player)
    @players.each do |player|
      if player.bet < @the_bet
        call_or_fold_input(player)
        transfer_funds(player)
        player.push_bet(@bet)
      end
      puts "#{player.name} is in for #{@bet}"
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

  def roll(player)
    if player.remaining == 1
      puts "\n", " \s #{player.name}, last roll make it a good one!  ---  Hit <ENTER> to Roll"
    elsif player.remaining > 1
      puts "\n", " \s #{player.name}, Hit <ENTER> to Roll" 
    end

    STDIN.gets
    @val = []
    while @val.length < player.remaining
      r = rand(6) + 1
      @val.push(r)
    end
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
  end

  def pick_input(player)
    print "\n", "Which ones do you wanna keep? "
    @input = gets.chomp
    quit_fold_help?(player)
    if @input =~ /[1-5]+/
      array = @input.split('')
      array = array.delete_if {|x| x < '1' || x > '5' }   # deletes letters as well
      @input_array = array.uniq
      pick(player)
    else
      puts "Let's cut the nonesense, the choices go 1 - 5"
      pick_input(player)
    end
  end
  
  def quit_fold_help?(player)
    if @input == 'quit'
      quit(player)
    elsif @input == 'fold'
      player.fold_em()
      @input = 1
    elsif @input == 'help'
      intro()
    end
  end
  
  def pick(player)
    @input_array.each do |inp|
      digit = inp.to_i 
      if digit <= @val.length     # Check for number < 5 but > the number of options
        digit -= 1                # Changes the human number to zero indexed number
        value = @val[digit]       # Pulls the digit out by index number
        player.push_keepers(value)
        if value == 3
          # 3 counts as 0 so @tally is not increased
        else
          player.push_tally(value)
        end # value == 3
      elsif digit > @val.length
        puts "#{@in_digit} wasn't available to you so we just excluded it..."
      end
    end # for loop
  end

  def report_choices(player)
    if player.remaining == 0 && @times_bet_after_last_dice == 0
      puts "\n", " \s That was the last dice!"
    end
    puts "\n", " \s #{player.name}, kept #{player.keepers}, for a total of #{player.tally}."
  end

  def bet_input(player)
    print "\n", "#{player.name}, the bet stands at #{@the_bet - player.bet} you have #{player.purse} in the purse, what's your bet?  "
    @input = gets.chomp
    @bet = @input.to_i
    quit_fold_help?(player)
    
    if @input == '0'
      puts "Ok, that's fine... No shame is betting 0... well maybe a little shame"
    elsif @bet < @the_bet - player.bet
      if @input.empty?
        puts "\n", " \s You can bet 0 if you'd like but you've got to enter something..."
      elsif @input =~ /[A-Za-z]+/
        puts "\n", " \s #{@input.upcase}, you want to bet #{@input.upcase}! Give me a break..."
      elsif @bet < @the_bet
        puts "\n", " \s #{@input.upcase}, are you kiddin me! That's not enough to keep you in the game"
      elsif @bet > player.purse
        puts "\n", " \s No way pal, you've only got #{player.purse} left"
      end
      bet_input(player)
    elsif @bet >= @the_bet - player.bet
      comment_on_bet(player)
    end
  end

  def call_or_fold_input(player)
    print "\n", "#{player.name}, it's #{@the_bet - player.bet} to call and you have #{player.purse} in the purse, will you call or 'fold'? "
    @input = gets.chomp
    @bet = @input.to_i
    quit_fold_help?(player)
    
    if @input == '0'
      puts "It's call or 'fold'.  0 isn't an option! The bet stands at #{@the_bet - player.bet}"
    elsif @bet < @the_bet - player.bet
      if @input.empty?
        puts "\n", " \s It's call or 'fold'... you've got to enter something..."
      elsif @input =~ /[A-Za-z]+/
        puts "\n", " \s #{@input.upcase}, you want to bet #{@input.upcase}! Give me a break..."
      elsif @bet < @the_bet
        puts "\n", " \s #{@input.upcase}, are you kiddin me! That's not enough to keep you in the game"
      elsif @bet > player.purse
        puts "\n", " \s No way pal, you've only got #{player.purse} left"
      end
      call_or_fold_input(player)
    elsif @bet == @the_bet - player.bet
      remarks_for_calling(player)
    elsif @bet > @the_bet - player.bet
      puts "\n", " \s You already had your chance to raise!  Either call #{@the_bet - player.bet} or 'fold'"
      call_or_fold_input(player)
    end
  end

  def remarks_for_raising(player)
    puts "\n"
    if @bet == player.purse
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

  def remarks_for_calling(player)
    puts "\n"
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

  def transfer_funds(player)
    player.pull_from_purse(@bet)
    @pot += @bet
    if @bet > @the_bet
      @the_bet = @bet
    end
  end

  def comment_on_bet(player)
    if @bet == @the_bet
      remarks_for_calling(player)
    elsif @bet > @the_bet
      remarks_for_raising(player)
    end
  end

  def run_down()
    puts "\n", "Ok #{p_name}, here's the run down
    <> The initial bet stands at #{$the_bet}
    <> You've set aside #{@keepers} for a total of #{@tally}
    <> You've got #{@purse} left in your purse and the pot stands at #{$pot}", "\n"
  end

  def quit(player)
    puts "#{player.name}, you lacked the courage to keep fighting... GAME OVER" 
    Process.exit!(0)
  end

  def check_for_a_winner()
    scores = []
    winners = []
    @players.each do |player|
      if player.tally == 30
        puts " \s I do not believe this...... "
        puts " \s #{player.name}, you 'Shot The MOON'......"
        puts " \s and secured yourself the win! "
        winners.push(player)
      else
        scores.push[ player.tally, player ]
      end
    end
    
    in_order = scores.sort
    winner = in_order.slice!(0)
    co_winners.push(winner.last)
    
    in_order.each do |score|
      if winner.first == score.first
        co_winners.push(score.last)
      end
    end
    puts "and the winner is........   #{winning_player.name}"
    winning_player.put_into_purse(@pot)
  end
end

