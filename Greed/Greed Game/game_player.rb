require './greed_player'
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