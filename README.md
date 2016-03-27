# wait_group

WaitGroup waits for collection of spawn to finish.

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  wait_group:
    github: takaishi/wait_group
```


## Usage

```crystal
require "wait_group"

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
```


## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/takaishi/wait_group/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [takaishi](https://github.com/takaishi) Ryo Takaishi - creator, maintainer
