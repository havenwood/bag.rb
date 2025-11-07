# Bag

A pure Ruby implementation of a **Bag** (multiset), inspired by Smalltalk-80's Bag class.

A Bag is like a Set that remembers how many times you've added each element:

```ruby
Set.new(%w[quartz quartz obsidian])
#=> #<Set: {"quartz", "obsidian"}>

Bag.new(%w[quartz quartz obsidian])
#=> #<Bag "quartz" => 2, "obsidian" => 1>

%w[quartz quartz obsidian].tally
#=> {"quartz" => 2, "obsidian" => 1}
```

## Installation

```bash
gem install bag.rb
```

Or add to your Gemfile:

```ruby
gem 'bag.rb'
```

## Usage

```ruby
require 'bag'

words = Bag.new(%w[the quick brown fox jumps over the lazy dog])

words.count('the')
#=> 2
words.size
#=> 9
words.uniq_size
#=> 8

words << 'the' << 'the'
words.add('fox', 2)
words.remove('lazy')

words.sorted_by_count
#=> [['the', 4], ['fox', 3], ['quick', 1], ...]
words.sample
#=> 'the'
```

## API

### Creation & Modification

```ruby
bag = Bag.new
bag = Bag.new(%i[abyss void abyss chaos abyss])
#=> #<Bag abyss: 3, void: 1, chaos: 1>
bag = Bag.new(%i[abyss void abyss].tally)
#=> #<Bag abyss: 2, void: 1>

bag << 'nihil'
bag.add('entropy', 5)
bag.add('nihil', -1)

bag.remove('nihil')
bag.remove('nihil', 2)
bag.remove_all('entropy')
bag.clear

bag.count('abyss')
bag.include?('void')
#=> true
bag.empty?
#=> false
```

### Set Operations

```ruby
bag1 = Bag.new(%i[phosphor phosphor glyph rune])
bag2 = Bag.new(%i[phosphor glyph glyph sigil])

bag1 + bag2
#=> #<Bag phosphor: 3, glyph: 3, rune: 1, sigil: 1>
bag1 & bag2
#=> #<Bag phosphor: 1, glyph: 1>
bag1 - bag2
#=> #<Bag phosphor: 1, rune: 1>

bag1 + {'phosphor' => 1, 'sigil' => 2}
bag1 + Data.define(:x, :y).new(x: 3, y: 5)
```

### Enumeration

```ruby
bag = Bag.new([1, 2, 2, 3, 3, 3])

bag.each { |n| print n }
#=> 1 2 2 3 3 3

bag.each_with_count { |element, count| puts "#{element}: #{count}" }

bag.map { |n| n * 2 }
#=> [2, 4, 4, 6, 6, 6]
bag.filter { |n| n > 1 }
#=> [2, 2, 3, 3, 3]
bag.reduce(:+)
#=> 14
```

### Analysis

```ruby
bag = Bag.new(%i[ressentiment pathos ethos logos ressentiment ressentiment])

bag.sorted_by_count
#=> [[:ressentiment, 3], [:pathos, 1], ...]

bag.sorted_elements
#=> {ethos: 1, logos: 1, ...}

bag.cumulative_counts
#=> [[:ressentiment, 3], [:pathos, 4], ...]

bag.sample
#=> :ressentiment
bag.sample(3)
#=> [:ressentiment, :logos, :ressentiment]
```

### Conversion & Comparison

```ruby
bag = Bag.new(%i[quasar quasar nebula])

bag.to_a
#=> [:quasar, :quasar, :nebula]
bag.to_h
#=> {quasar: 2, nebula: 1}
bag.to_set
#=> #<Set: {:quasar, :nebula}>

Bag.new([1, 2]) < Bag.new([1, 2, 3])
#=> true
```

## Examples

### Word Frequency

```ruby
text = File.read('beowulf.txt')
words = Bag.new(text.downcase.scan(/\w+/))

words.sorted_by_count.first(10).each do |word, count|
  puts "#{word}: #{count}"
end
```

### Inventory Tracking

```ruby
inventory = Bag.new

inventory.add('widget', 100)
inventory.remove('widget', 15)
inventory.count('widget')
#=> 85
```

### Survey Analysis

```ruby
responses = Bag.new(%w[yes no yes yes maybe yes no])

responses.sorted_by_count
#=> [['yes', 4], ['no', 2], ['maybe', 1]]

total = responses.size
responses.each_with_count do |response, count|
  percentage = (count.fdiv(total * 100)).round(1)
  puts "#{response}: #{percentage}%"
end
```

## Requirements

- Ruby 3+
