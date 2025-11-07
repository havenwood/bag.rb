# frozen_string_literal: true

require_relative 'bag/version'

class Bag
  include Comparable
  include Enumerable

  def initialize(elements = nil)
    @contents = Hash.new(0)
    return unless elements

    if elements.is_a?(Hash)
      elements.each { |element, count| add(element, count) }
    else
      elements.each { |element| add element }
    end
  end

  def add(element, occurrences = 1)
    raise ArgumentError, 'bag elements cannot be nil' if element.nil?
    return self if occurrences.zero?

    @contents[element] += occurrences
    @contents.delete(element) unless @contents[element].positive?
    self
  end

  def <<(element)
    raise ArgumentError, 'bag elements cannot be nil' if element.nil?

    @contents[element] += 1
    self
  end

  def remove(element, occurrences = 1)
    add(element, -occurrences)
  end

  def remove_all(element)
    @contents.delete(element)
    self
  end

  def occurrences_of(element) = @contents[element]
  alias count occurrences_of

  def include?(element) = @contents.key?(element) && @contents[element].positive?

  def size = @contents.values.sum
  alias length size

  def uniq_size = @contents.size

  def each
    return enum_for(__method__) unless block_given?

    @contents.each { |element, count| count.times { yield element } }
    self
  end

  def each_with_count(&)
    return enum_for(__method__) unless block_given?

    @contents.each(&)
    self
  end

  def to_a = @contents.flat_map { |element, count| [element] * count }

  def to_h = @contents.dup

  def keys = @contents.keys

  def values = @contents.values

  def sorted_by_count
    @contents.sort_by { |_element, count| -count }.map { |element, count| [element, count] }
  end

  def sorted_elements
    @contents.sort.to_h
  end

  def cumulative_counts
    cumulative = 0
    sorted_by_count.map do |element, count|
      cumulative += count
      [element, cumulative]
    end
  end

  def to_set
    @contents.keys.to_set
  end

  def empty? = @contents.empty?

  def clear
    @contents.clear
    self
  end

  def sample(num = nil, random: Random)
    return (num ? [] : nil) if empty?

    if num
      raise ArgumentError, 'negative array size' if num.negative?

      return Array.new(num) { sample(random:) }
    end

    sample_single(random)
  end

  def +(other)
    other = from_hash(other)
    result = Bag.new

    @contents.each { |element, count| result.contents[element] = count }
    other.contents.each { |element, count| result.contents[element] += count }

    result
  end

  def &(other)
    other = from_hash(other)
    result = Bag.new

    @contents.each do |element, count|
      other_count = other.contents[element]
      result.contents[element] = [count, other_count].min if other_count.positive?
    end

    result
  end

  def -(other)
    other = from_hash(other)
    result = Bag.new

    @contents.each do |element, count|
      remaining = count - other.contents[element]
      result.contents[element] = remaining if remaining.positive?
    end

    result
  end

  def ==(other)
    return false unless other.is_a?(Bag)

    @contents == other.contents
  end

  def <=>(other)
    return nil unless other.is_a?(Bag)
    return size <=> other.size unless size == other.size
    return uniq_size <=> other.uniq_size unless uniq_size == other.uniq_size

    compare_contents(other)
  end

  def inspect = "#<Bag: #{@contents.inspect}>"
  alias to_s inspect

  def pretty_print(pp)
    pp.object_group(self) do
      pp.seplist(@contents, -> { pp.text ',' }) do |element, count|
        pp.breakable
        if element.is_a?(Symbol)
          pp.text element.inspect[1..]
          pp.text ': '
        else
          pp.pp element
          pp.text ' => '
        end
        pp.pp count
      end
    end
  end

  protected

  attr_reader :contents

  private

  def sample_single(random)
    target_index = random.rand(size)
    current_sum = 0

    element, = @contents.find do |_, count|
      current_sum += count
      target_index < current_sum
    end
    element
  end

  def compare_contents(other)
    to_a.sort <=> other.to_a.sort
  rescue ArgumentError
    nil
  end

  def from_hash(other)
    return other if other.is_a?(Bag)
    raise TypeError, "can't convert #{other.class} to Bag" unless other.respond_to?(:to_h)

    Bag.new(other.to_h)
  end

  def coerce(other) = [from_hash(other), self]
end
