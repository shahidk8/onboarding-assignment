require_relative '../greed'
require_relative '../game_player'
require_relative '../greed_player'
require_relative '../dice'

describe 'Dice Rolls' do
    before :all do
        @dice = DiceSet.new
    end
    it 'Roll should not be empty' do
        expect(@dice.roll(5)).not_to be_nil
    end

    it "Roll should be equal to the given length but greater than 0 and less than 6" do
        expect(@dice.roll(5)).to eq(5)
        expect(@dice.roll(0)).to eq("maximum allowed dice set is 5")
        expect(@dice.roll(-1)).to eq("maximum allowed dice set is 5")
    end

    it "test_rolling_the_dice_returns_a_set_of_integers_between_1_and_6" do
        @dice.values.each do |value|
            expect(value >= 1 && value <= 6).to be_truthy
        end
    end
end

describe 'Test Greed Player class' do
    before :all do
        @greed_player = GreedPlayer.new('John Doe')
        @greed_player.playTurn("n")
    end
    it "If score >0 return true" do 
        expect(@greed_player.reactToRollScore(100)).to be_truthy
    end

    it "If score <0 return false" do 
        expect(@greed_player.reactToRollScore(0)).not_to be_truthy
    end

    it "reactToTurn score" do 
        expect(@greed_player.reactToTurnScore).not_to be_truthy
    end

    it "Role dice with 3 dices" do
        expect(@greed_player.determineDicesToRoll(true,3)).to eq(3)
    end

    it "False case, Not to role dice should return 0" do
        expect(@greed_player.determineDicesToRoll(false,5)).to eq(0)
    end

    it "check pluralize method" do
        expect(@greed_player.pluralize(2,['First', 'Second'])).to eq("2 Second")
        expect(@greed_player.pluralize(1,['First', 'Second'])).to eq("1 First")
    end
end

describe "GamePlayers Class" do
    before :all do
        @GamePlayers = GamePlayers.new(["John","Anthony","Peter"])
    end
    it "next player method" do 
        expect((@GamePlayers.next).name).to eq('John')
        expect((@GamePlayers.next).name).to eq('Anthony')
        expect((@GamePlayers.next).name).to eq('Peter')
    end

    it "sort player scores" do
        @array_players = Array.new 
        (@GamePlayers.next).total_score = 10
        (@GamePlayers.next).total_score = 20
        (@GamePlayers.next).total_score = 30
        (@GamePlayers.players_by_scores).each{|each| @array_players << (each).name }
        expect(@array_players).to eq(["Peter","Anthony","John"])
    end

end


describe "Greed Class Main method" do 
    before :all do
        @game = GreedGame.new
    end

    describe 'Score Calculator; Score method' do
        it "test score of a single roll of 1 is 100" do 
            expect(score([1])[1]).to eq(100)        
        end
    
        it "test score of multiple 1s and 5s is the sum of individual scores" do 
            expect(score([1,5,5,1])[1]).to eq(300)
        end
    
        it "test score of a triple 1 is 1000" do 
            expect(score([1,1,1])[1]).to eq(1000)
        end
    
        it "test score of other triples is 100x" do
            expect(score([2,2,2])[1]).to eq(200) 
            expect(score([3,3,3])[1]).to eq(300) 
            expect(score([4,4,4])[1]).to eq(400) 
            expect(score([5,5,5])[1]).to eq(500) 
            expect(score([6,6,6])[1]).to eq(600) 
          end
        
          it "test score of mixed is sum" do
            expect(score([2,5,2,2,3])[1]).to eq(250)
            expect(score([5,5,5,5])[1]).to eq(550)
            expect(score([1,1,1,1])[1]).to eq(1100)
            expect(score([1,1,1,1,1])[1]).to eq(1200)
            expect(score([1,1,1,5,1])[1]).to eq(1150)
          end
    end

    it "isFinalRound" do 
        expect(@game.isFinalRound?(2000)).not_to be_truthy
        expect(@game.isFinalRound?(3000)).to be_truthy
    end

end