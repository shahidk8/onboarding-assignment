require_relative '../greed'

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

describe 'Score Calculate' do
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