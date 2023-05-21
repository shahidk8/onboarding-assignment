class GreedGame
  attr_reader :is_final_round
  def initialize
    @is_final_round = false
  end

  def playGame
    puts "\nWelcome to GREED\n"
    player_names = []
    puts "\nPlease enter number of players. Minimum 2 players required\n"
    player_num = gets.to_i
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
    return false
  end
end

class GamePlayers
  def initialize(player_names)
    @array_players = Array.new
    player_names.each { |name| @array_players << GreedPlayer.new(name) }
    @current_index = -1
    @stopping_index = nil
  end

  def next
    @current_index += 1
    if @current_index >= @array_players.size
      @current_index = 0
    end
    (@current_index == @stopping_index) ? nil : @array_players[@current_index]
  end

  def setCurrentPlayerAsStoppingPlayer
    @stopping_index = @current_index
  end

  def players_by_scores
    @array_players.sort { |elt, other| elt.total_score <=> other.total_score }.reverse
  end
end

class GreedPlayer
  NO_OF_DICE = 5
  MINIMUM_TURN_SCORE = 300
  attr_accessor :turn_score, :total_score, :name

  def initialize(name)
    @name = name
    @total_score = 0
    @diceSet = DiceSet.new
  end

  def playTurn
    @turn_score = 0
    rollNumber = 0

    dicesToRoll = NO_OF_DICE
    while dicesToRoll > 0 do
      rollNumber += 1
      @diceSet.roll(dicesToRoll)
      puts "dice set size #{@diceSet.values.size}"
      scoring_dice, roll_score, non_scoring_dice = score(@diceSet.values)
      puts "Roll #{rollNumber}: #{@diceSet.values.sort}"

      if reactToRollScore(roll_score)
        puts "  ==> scored #{roll_score} points with #{scoring_dice}"
        puts "  Accumulated score for this turn: #{turn_score} points"
        if non_scoring_dice.size > 0
          puts "  Non-Scoring Dice: #{non_scoring_dice}"
          puts 'Would you like to re-roll ' + pluralize(non_scoring_dice.size, %w(die dice)) + '? [Y,n]'
        else
          puts 'Would you like to roll a new series of 5 dice? [Y,n]'
        end

        okToRoll = userConfirmation?
        dicesToRoll = determineDicesToRoll(okToRoll, non_scoring_dice.size)
      else
        puts 'No points in this roll! You lose all of this turn\'s points, and your turn is over...'
        break
      end
    end # while dicesToRoll > 0

    if reactToTurnScore
      puts "\nIn this turn, you have added #{turn_score} points to your score."
    elsif @turn_score > 0
      puts " \nIn this turn, your score of #{turn_score} points wasn't enough to \"get in the game\" (min. #{MINIMUM_TURN_SCORE} points required)."
    end

    puts "Your total score is: #{total_score} points.\n"
  end

  def reactToTurnScore
    if @turn_score >= MINIMUM_TURN_SCORE or @total_score >= MINIMUM_TURN_SCORE
      @total_score += @turn_score
      return @turn_score > 0
    end
    return false
  end

  def determineDicesToRoll(okToRoll, numberOfRemainingDice)
    if okToRoll
      numberOfRemainingDice == 0 ? NO_OF_DICE : numberOfRemainingDice
    else
      0
    end
  end

  def userConfirmation?
    return gets.chomp.upcase[0] != 'N'
  end

  def pluralize(number, options)
    if number <= 1
      return "#{number} #{options[0]}"
    else
      return "#{number} #{options[-1]}"
    end
  end

  def reactToRollScore(roll_score)
    if roll_score > 0
      @turn_score += roll_score
      return true
    else
      @turn_score = 0
    end
    return false
  end
end

class DiceSet
  attr_reader :values

  def roll(len)
    @values = []
    if len<=5 && len>0
      len.times { @values << rand(6) + 1 }
    else
      "maximum allowed dice set is 5"
    end

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