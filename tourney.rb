class Tourney
  def initialize()
    setup_players()
    create_game()
    play_it()
  end
  
  def how_many_input()
    @x = gets.chomp.to_i
    if @x < 2 
      puts "I didn't catch that can you repeat it"
      how_many_input()
    end
  end
  
  def name_input
    @name = gets.chomp
    if @name.length == 0
      puts "I didn't catch that can you repeat it"
      name_input()
    end
  end
  
  def setup_players()
#    puts "\n", "How many player will join?"
#    how_many_input() 

    @players = []
#    @x.times do |counter|
#      puts "Enter the name of player #{counter + 1}"
#      name_input()
#      @players.push(Player.new(@name))
       @players.push(Player.new('Jack'))     # Hard Code for testing 
       @players.push(Player.new('Trevor'))   # Hard Code for testing
       @players.push(Player.new('Andrew'))   # Hard Code for testing
#    end
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

    # if
    #   puts " \s #{p_name} you bankrupted your opponent and are the overall CHAMPION!"
    #   Process.exit!(0)
    # else
    #   puts " \s #{p_name} with a tally of #{@tally}........ you WON and took away a pot of #{$pot}!!!!!"
    #   puts " \s but the loser escaped to fight another day"
    # end
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

