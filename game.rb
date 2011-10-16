class Game
  def initialize(players)
    @all_players = players
    @players = []
    @ante = 1
    @pot = 0
    @@keep_going = true
    @@total_players_done = 0
    @all_players.each do |player|
      player.init_temp_vars()
    end
    check_ante()
    play_game()
  end
  
  def check_ante()
    # ante up
    @ante_counter = 0
    @players = @all_players.select do |player|
      did_ante = player.ante_up?(@ante) 
      if did_ante == true
        @ante_counter += 1
        @pot += @ante
      end
      did_ante
    end
    
    if @ante_counter < 2
      puts "\n", " \s Not enough players anted up"
      save_game?()
    end
  end
    
  def play_game()
    @players.each do |player|
      next if player.has_folded? == true
      if player.remaining > 0 && @@keep_going == true
        roll(player)
        show()
        pick_input(player)
        next if player.has_folded? == true
        report_choices(player)
        
        if player.remaining == 0
          @@total_players_done += 1
        end
        
        if player.purse == 0
          puts " \s Looks like you're all in, so we'll skip betting"
        elsif 
          take_bets(player)
        end
      else
        puts "\n", " \s #{player.name} is done rolling..."
        check_for_a_winner()
      end
    end

    while true
      break if @@keep_going == false
      play_game()
    end
  end
  
  def take_bets(player)
    @players.each do |player|       # Loops the players reseting all the variables
      player.reset_can_raise        
      @@highest_bet = 0
      @bet = 0
    end
    
    if @players.length - @@total_players_done >= 1      # To start betting
      bet_input(player)                               # At least 2 players need                                                # to have be still playing
      transfer_funds(player)
    puts "~~~~~~~~~~~~~~~~~~highest #{@@highest_bet}~~~~~~~bet #{@bet}~~~~~~~~~~~~~~~~~~~~~~~~"
      2.times do
        puts "2.times do"
        @players.each do |p|
          puts "p.name#{p.name}"
          puts "~~~~~~~~~~~~~~~~~~highest #{@@highest_bet}~~~~~~~bet #{@bet}~~~~~~~~~~~~~~~~~~~~~~~~"

          next if p.has_folded? == true
          next if @bet >= @@highest_bet
          bet_input(p)
          transfer_funds(p)
        end
      end
    else
      check_for_a_winner()
    end
  end
  
  def help
    info = <<INFO
  
  The game is called "Threes."  
  The goal is to have the lowest total
  You start by rolling 5 dice,
  then put 1 or more aside.
  Players can bet each turn.
  Repeat until you have no dice.
  
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
      puts "\n", " \t \t #{player.name}, Hit <ENTER> to Roll" 
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
     
    if @input =~ /(help|info|intro)/
      help()
      pick_input(player)
    elsif @input =~ /(fold|quit|out|done)/
      @@total_players_done += 1
      player.fold_em()
    elsif @input =~ /[1-5]+/
      array = @input.split('')
      array = array.delete_if {|x| x < '1' || x > '5' }   # deletes letters as well
      @input_array = array.uniq
      pick(player)
    else
      puts "Let's cut the nonesense, the choices go 1 - 5"
      pick_input(player)
    end
  end

  def pick(player)
    @input_array.each do |inp|
      digit = inp.to_i 
      if digit > @val.length
        if @input_array.length == 1
          puts "\n", " \s #{digit} wasn't available to you try again..."
          pick_input(player)
        else @input_array.length > 1
          puts "#{digit} wasn't available to you so we excluded it from your choices"
        end
      elsif digit <= @val.length     # Check for number < 5 but > the number of options
        digit -= 1                # Changes the human number to zero indexed number
        value = @val[digit]       # Pulls the digit out by index number
        player.push_keepers(value)
        if value == 3
          # 3 counts as 0 so @tally is not increased
        else
          player.push_tally(value)
        end # value == 3
      end
    end # for loop
  end

  def report_choices(player)
    puts "\n", " \s #{player.name}, kept #{player.keepers}, for a total of #{player.tally}."
    if player.remaining == 0 && @times_bet_after_last_dice == 0
      puts "\n", " \s That was the last dice!"
    end
  end

  def bet_input(player)

    print "\n", "#{player.name}, the bet stands at #{@@highest_bet - @bet} you have #{player.purse} in the purse, what's your bet?  "
    @input = gets.chomp
    @bet = @input.to_i + @bet
    
    if @input =~ /(help|info|intro)/
      help()
      bet_input(player)
    elsif @input =~ /(fold|quit|out|done)/
      @@total_players_done += 1
      player.fold_em()
    elsif @input =~ /[^0-9]+/              # Regexp = everything except numbers
      puts "\n", " \s #{@input.upcase}, you want to bet #{@input.upcase}! Give me a break..."
      bet_input(player)
    elsif @bet < @@highest_bet - @bet
      puts "\n", " \s #{@input.upcase}, are you kiddin me! You need to put #{@@highest_bet - player.bet} to keep you in the game"
      bet_input(player)
    elsif @bet > player.purse
      puts "\n", " \s No way pal, you've only got #{player.purse} left"
      bet_input(player)
    elsif @input.empty?
      puts "\n", " \s You can bet 0 if you'd like but you've got to enter something..."
      bet_input(player)
    elsif @input == '0'
      puts "\n", " \s Ok, that's fine... No shame is betting 0... well maybe a little shame"
    elsif @bet == @@highest_bet - @bet
      remarks_for_calling(player)
    elsif @bet > @@highest_bet
      if player.can_raise? == true
        @@highest_bet = @bet
        remarks_for_raising(player)
      elsif player.can_raise? == false
        puts "\n", " \s you already had your chance to raise, you can call or 'fold'"
        bet_input(player)
      end
    end
    player.cannot_raise_again
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
    if @bet == player.purse
      puts " \s Going all in, that takes balls!"
    else
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
  end

  def transfer_funds(player)
    player.pull_from_purse(@bet)
    @pot += @bet
  end

  def run_down()
    puts "\n", "Ok #{p_name}, here's the run down
    <> The initial bet stands at #{$the_bet}
    <> You've set aside #{@keepers} for a total of #{@tally}
    <> You've got #{@purse} left in your purse and the pot stands at #{$pot}", "\n"
  end

  def quit(player)
    puts "#{player.name}, you lacked the courage to keep fighting... GAME OVER" 
    save_game?()
  end
  
  def save_game?()
    print "\n", "Do you want to quit and save the standings so you can come back to it later? (Y/n)"     
    want_to_save = gets.chomp
    if want_to_save == 'n'
      puts "ok, your results were erased"
    else

      print "\n", " \s Type in a name to remember your game by > "
      filename = gets.chomp
      filename = filename + ".rb"          

      folder = Dir.chdir('saved')                 # Directory is changed to the 'results' directory
      target = File.open(filename, 'w')           # A file is created in the results folder
      
      target.write(@all_players)
      
      target.close()                                        
      puts "ok, your results were saved"
    end
    Process.exit!(0)
  end

  def check_for_a_winner()
    scores = []
    in_order = []
    winner = []
    co_winners = []
    
    @players.each do |player|
      if player.tally == 30
        puts " \s I do not believe this...... "
        puts " \s #{player.name}, you 'Shot The MOON'......"
        puts " \s and secured yourself the win! "
        winner = [ player.tally, player ]
      else
        scores.push([ player.tally, player.name, player ])
      end
    end

    in_order = scores.sort
    winner = in_order.slice!(0)  

    puts "in order #{in_order}"
    puts "winner #{winner}"

    if winner.last.remaining == 0  # player.remaining
      in_order.each do |score|
        if winner.first == score.first  #player.tally
          co_winners.push(score.last.name)   # player.name
        end
      end

      if co_winners.length == 0
        puts "With a score of #{winner.first}........ the winner is........   #{winner.last.name}"
        winner.last.put_into_purse(@pot)
        @pot = 0
        puts "winner.last.purse #{winner.last.purse}"
        @@keep_going = false
      else
        co_winners.each do |winner|
          print "#{winner.last.name} you are tied for the win"
          winner.last.put_into_purse(@pot / co_winners.length)
          @pot = 0
          @@keep_going = false
        end
      end
    end   
  
  end   # def check_for_a_winner
end   # class Game





















