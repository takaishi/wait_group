require "../src/wait_group"

def worker(msg : String)
  wg = WaitGroup.new
  receiver = Channel(String).new
  fin = Channel(Bool).new

  spawn do
    3.times do |i|
      wg.add(1)
      spawn do
        receiver.send("#{i} #{msg} done")
        wg.done
      end
    end
    wg.wait
    fin.send(true)
  end
  return receiver, fin
end

receiver, fin = worker("job")

loop do
  index, value = Channel.select(receiver.receive_op, fin.receive_op)
  case index
  when 0
    puts(value)
  when 1
    break
  end
end
