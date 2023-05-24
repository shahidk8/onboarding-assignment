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