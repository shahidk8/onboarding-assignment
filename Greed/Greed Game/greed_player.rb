require './greed'
require './dice'
class GreedPlayer
    attr_accessor :turn_score, :total_score, :name
    def initialize(name)
      @name = name
      @total_score = 0
      @num_of_dice=5
      @minimum_turn_score = 300
      @diceSet = DiceSet.new
    end
  
    def playTurn(test_input = nil)
      @turn_score = 0
      rollNumber = 0
  
      dicesToRoll = @num_of_dice
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
  
          okToRoll = test_input || userConfirmation? 
          dicesToRoll = determineDicesToRoll(okToRoll, non_scoring_dice.size)
        else
          puts 'No points in this roll! You lose all of this turn\'s points, and your turn is over...'
          break
        end
      end # while dicesToRoll > 0
  
      if reactToTurnScore
        puts "\nIn this turn, you have added #{turn_score} points to your score."
      elsif @turn_score > 0
        puts " \nIn this turn, your score of #{turn_score} points wasn't enough to \"get in the game\" (min. #{@minimum_turn_score} points required)."
      end
  
      puts "Your total score is: #{total_score} points.\n"
    end
  
    def reactToTurnScore
      if @turn_score >= @minimum_turn_score || @total_score >= @minimum_turn_score
        @total_score += @turn_score
        return @turn_score > 0
      end
      return false
    end
  
    def determineDicesToRoll(okToRoll, numberOfRemainingDice)
      if okToRoll
        numberOfRemainingDice == 0 ? @num_of_dice : numberOfRemainingDice
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