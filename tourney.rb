class Tourney
  def initialize()
    how_many_input()
    create_game()
    play_it()
  end

  def open_game()
    puts "Which file would you like to open?"

    folder = Dir.chdir('saved')        
    files = Array.new
    Dir.new(Dir.pwd).entries.each { |n| files.push(n) if File.file?(n) }
    puts files
    
    filename = gets.chomp
    # filename = filename + ".rb"
    target = File.open(filename, 'r')
    saved_players = target.read
    target.close()
    saved_array = saved_players.split("\n")
    
    saved_array.each do |saved|
      array = saved.split("\s")
      @players.push(Player.new(array[0], array[1].to_i))
    end
    puts @players
    
#    @players.each do |player|
 #     player.ante_up?(1)
  #  end
    
    
  end
  
  def how_many_input()
    print "\n", "Enter the number player or 'open' > "
    input = gets.chomp
    @players = []
    if input == 'open'
      open_game()
    elsif input =~ /\d+/
      @x = input[/\d+/].to_i
      setup_players()
    else
      puts "I didn't understand..."
      how_many_input()
    end
  end
  
  def name_input
    name = gets.chomp
    if name =~ /\s+/
      puts "sorry, your name can't have any spaces in it"
      name_input()
    elsif name.length >= 1
      @name = name
    else
      puts "I didn't catch that can you repeat it"
      name_input()
    end
  end
  
  def setup_players()
    @x.times do |counter|
      puts "Enter the name of player #{counter + 1}"
      name_input()
      @players.push(Player.new(@name, 50))
       # @players.push(Player.new('Ling Bawi'))     # Hard Code for testing 
       # @players.push(Player.new('Jack'))   # Hard Code for testing
       # @players.push(Player.new('Andrew'))   # Hard Code for testing
    end
  end

  def all_the_players
    @players
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

