require './game_player'
class GreedGame
  attr_reader :is_final_round
  def initialize
    @is_final_round = false
  end

  def playGame
    puts "\nWelcome to GREED\n"
    player_names = []
    player_num = 0
    while player_num < 2 do
      puts "\nPlease enter number of players. Minimum 2 players required\n"
      player_num = gets.to_i
    end
    if(player_num>=2)
      player_num.times{ |i| player_names << "player_#{i+1}"}  #By default naming players as player_1, player_2 and so on.
    end
    players = GamePlayers.new(player_names)

    current_player = players.next
    while current_player do # nil (ie no more players) is false
      puts "\n#{current_player.name.capitalize}, it's your turn. Your total score is currently #{current_player.total_score} points."

      current_player.playTurn

      unless @is_final_round
        if isFinalRound?(current_player.total_score)
          puts "#{current_player.name.capitalize} has reached 3000 points. All the other players can play one last turn and then the game will be over.\n"
          sleep(2)
          players.setCurrentPlayerAsStoppingPlayer
        end
      end
      current_player = players.next
      sleep(1)

      puts current_player ? 'Current Scores' : ' Final Scores'
      puts "==============\n"

      players.players_by_scores.each_with_index do |player, index|
      puts "#{index+1}. #{player.name.capitalize}: #{player.total_score} points\n"
      end
    end
  end

  def isFinalRound?(total_score)
    if total_score >= 3000
      @is_final_round = true
      return true
    end
    false
  end
end

def score(dice)
  if dice.size == 0
    return [[], 0, []]
  end
  scoring_dice = []
  non_scoring_dice = dice.dup
  dice_count = Hash.new(0)
  dice.each { |item| dice_count[item] += 1 }
  score = 0
  dice_count.each do |value, occurrences|
    nb_triplets = occurrences / 3
    nb_dice_in_triplets = nb_triplets * 3
    if value == 1
      score += nb_triplets * 1000
    else
      score += nb_triplets * value * 100
    end
    nb_dice_in_triplets.times do
      idx = non_scoring_dice.find_index(value)
      non_scoring_dice.delete_at(idx)
    end
    scoring_dice.push(*Array.new(nb_dice_in_triplets, value)) 
    remainder = occurrences % 3

    # remaining 5s
    if value == 5 and remainder > 0
      score += remainder * 50
      non_scoring_dice.delete(5) #delete all remaining 5s
      scoring_dice.push(*Array.new(remainder, 5))
    end
    # remaining 1s
    if value == 1 and remainder > 0
      score += remainder * 100
      non_scoring_dice.delete(1) # delete all remaining 1s
      scoring_dice.push(*Array.new(remainder, 1))
    end
  end

  return [scoring_dice, score, non_scoring_dice]
end

if __FILE__ == $0
game = GreedGame.new
game.playGame
end