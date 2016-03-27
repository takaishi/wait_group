require "./wait_group/*"

class WaitGroup
  def initialize
    @count = 0
    @ch = Channel(Bool).new
  end

  def add(n = 1)
    @count += n
  end

  def done
    @count -= 1
    if @count == 0
      @ch.send(true)
    end
  end

  def wait
    @ch.receive
  end
end
