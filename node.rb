class Node
    attr_accessor :data, :left, :right
  
    def initialize(data = nil)
      @data = data
      @left = nil
      @right = nil
    end
  end