# tie_ers = []
# leading_score = 31
# @players.each do |player|
#   if player.tally < leading_score
#     leading_score = player.tally
#     winner = player
#   elsif player.tally == leading_score
#     tie_ers.push(player)
#   end
# end
# if tie_er.tally == leading_score
#   puts " \s I do not believe this...... we have a TIE!!!!!"
#   
# puts "and the winner is........   #{winner.name}"
# winner.put_into_purse(@pot)

# def call_or_raise(p_num, p_name)
#   if @the_bet > 0
#     @remaining = (5 - @keepers.length)
#     get_betting_input(p_num, p_name)
#     if @bet > $the_bet
#       remarks_for_raising(p_num)
#     elsif @bet == $the_bet
#       remarks_for_calling(p_num)
#     end
#     update_purse(p_num)
#   end
# end 

# def fold_or_call(p_num, p_name)
#   # puts "  def fold_or_call(p_num, p_name)"
#   # puts "\t $the_bet = #{$the_bet}"
#   if $the_bet > 0
#     @remaining = (5 - @keepers.length)
#     get_betting_input(p_num, p_name)
#   
#     if @bet > $the_bet
#       @bet = $the_bet
#       puts " \s Sorry, you already had your turn to raise..."
#       puts " \s We'll just put you in for #{@bet} since that's most you can bet until next turn"
#     elsif @bet == $the_bet
#       remarks_for_calling(p_num)
#     end
#     update_purse(p_num)
#   end
# end