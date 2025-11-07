# frozen_string_literal: true

require_relative 'test_helper'

class BagTest < Minitest::Test
  def test_empty_bag
    bag = Bag.new
    assert_equal 0, bag.size
    assert_equal 0, bag.uniq_size
    assert bag.empty?
  end

  def test_initialization
    bag = Bag.new(%w[will power power übermensch])
    assert_equal 4, bag.size
    assert_equal 3, bag.uniq_size
    assert_equal 2, bag.count('power')
    refute bag.empty?
  end

  def test_add
    bag = Bag.new
    bag.add('abyss', 3)
    assert_equal 3, bag.count('abyss')
  end

  def test_shovel_operator
    bag = Bag.new
    bag << 'Hope' << 'Hope' << 'feathers'
    assert_equal 2, bag.count('Hope')
    assert_equal 1, bag.count('feathers')
  end

  def test_remove
    bag = Bag.new(%w[eternal eternal eternal chaos chaos])
    bag.remove('eternal', 2)
    assert_equal 1, bag.count('eternal')
  end

  def test_remove_all
    bag = Bag.new(%w[soul soul Death Death])
    bag.remove_all('Death')
    assert_equal 0, bag.count('Death')
    refute bag.include?('Death')
  end

  def test_clear
    bag = Bag.new(%w[carriage immortality eternity])
    bag.clear
    assert bag.empty?
    assert_equal 0, bag.size
  end

  def test_smalltalk_negative_add
    bag = Bag.new(%w[ascetic ascetic ascetic star star])
    bag.add('ascetic', -2)
    assert_equal 1, bag.count('ascetic')
  end

  def test_zero_add_is_noop
    bag = Bag.new(%w[brain brain])
    bag.add('brain', 0)
    assert_equal 2, bag.count('brain')
  end

  def test_negative_add_removes_completely
    bag = Bag.new(%w[rope rope rope])
    bag.add('rope', -10)
    refute bag.include?('rope')
  end

  def test_include
    bag = Bag.new(%w[bridge precipice genealogy])
    assert bag.include?('precipice')
    refute bag.include?('nihilism')
  end

  def test_occurrences_of
    bag = Bag.new(%w[sky sky hemisphere])
    assert_equal 2, bag.occurrences_of('sky')
    assert_equal 0, bag.occurrences_of('void')
  end

  def test_union
    bag1 = Bag.new(%w[will power power übermensch])
    bag2 = Bag.new(%w[power übermensch übermensch eternal])
    union = bag1 + bag2
    assert_equal 8, union.size
    assert_equal 3, union.count('power')
    assert_equal 3, union.count('übermensch')
  end

  def test_intersection
    bag1 = Bag.new(%w[Hope feathers feathers soul])
    bag2 = Bag.new(%w[feathers soul soul storm])
    intersection = bag1 & bag2
    assert_equal 2, intersection.size
    assert_equal 1, intersection.count('feathers')
    assert_equal 1, intersection.count('soul')
  end

  def test_difference
    bag1 = Bag.new(%w[Death carriage carriage immortality])
    bag2 = Bag.new(%w[carriage immortality immortality eternity])
    difference = bag1 - bag2
    assert_equal 2, difference.size
    assert_equal 1, difference.count('Death')
    assert_equal 1, difference.count('carriage')
  end

  def test_union_with_empty
    bag = Bag.new(%w[abyss chaos])
    empty = Bag.new
    assert_equal bag, bag + empty
    assert_equal bag, empty + bag
  end

  def test_hash_coercion_union
    bag = Bag.new(%w[pathos star star])
    result = bag + {'pathos' => 1, 'chaos' => 2}
    assert_equal 2, result.count('pathos')
    assert_equal 2, result.count('chaos')
  end

  def test_hash_coercion_intersection
    bag = Bag.new(%w[circumference circumference circumference slant slant])
    result = bag & {'circumference' => 2, 'slant' => 1}
    assert_equal 2, result.count('circumference')
    assert_equal 1, result.count('slant')
  end

  def test_hash_coercion_difference
    bag = Bag.new(%w[quartz quartz quartz firmament firmament])
    result = bag - {'quartz' => 2, 'diadem' => 1}
    assert_equal 1, result.count('quartz')
    assert_equal 2, result.count('firmament')
  end

  def test_hash_with_negative_counts
    bag = Bag.new(%w[contentment contentment contentment plashless plashless])
    result = bag + {'contentment' => -2, 'plashless' => 1, 'frigate' => 2}
    assert_equal 3, result.count('contentment')
    assert_equal 3, result.count('plashless')
    assert_equal 2, result.count('frigate')
  end

  def test_each
    bag = Bag.new(%w[phosphorescence quartz quartz firmament])
    assert_equal %w[firmament phosphorescence quartz quartz], bag.to_a.sort
  end

  def test_each_with_count
    bag = Bag.new(%w[will power power übermensch])
    counts = {}
    bag.each_with_count { |element, count| counts[element] = count }
    assert_equal({'will' => 1, 'power' => 2, 'übermensch' => 1}, counts)
  end

  def test_enumerable_methods
    bag = Bag.new([1, 2, 2, 3])
    assert_equal 8, bag.reduce(:+)
    assert_equal([2, 2], bag.select { |num| num == 2 })
    assert_equal [2, 4, 4, 6], bag.map { |num| num * 2 }.sort
  end

  def test_to_a
    bag = Bag.new(%w[eternity Death carriage carriage])
    assert_equal %w[Death carriage carriage eternity], bag.to_a.sort
  end

  def test_to_h
    bag = Bag.new(%w[abyss star star chaos])
    assert_equal({'abyss' => 1, 'star' => 2, 'chaos' => 1}, bag.to_h)
  end

  def test_keys
    bag = Bag.new(%w[genealogy untergang untergang ressentiment])
    assert_equal %w[genealogy ressentiment untergang], bag.keys.sort
  end

  def test_values
    bag = Bag.new(%w[circumference slant slant diadem])
    assert_equal [1, 1, 2], bag.values.sort
  end

  def test_sorted_by_count
    bag = Bag.new(%w[abyss abyss abyss soul soul feathers])
    sorted = bag.sorted_by_count
    assert_equal [['abyss', 3], ['soul', 2], ['feathers', 1]], sorted
  end

  def test_to_set
    bag = Bag.new(%w[eternal eternal return eternity])
    set = bag.to_set
    assert_equal 3, set.size
    assert set.include?('eternal')
    assert set.include?('return')
    assert set.include?('eternity')
  end

  def test_equality
    bag1 = Bag.new(%w[soul immortality immortality carriage])
    bag2 = Bag.new(%w[carriage immortality soul immortality])
    bag3 = Bag.new(%w[soul immortality carriage])
    assert_equal bag1, bag2
    refute_equal bag1, bag3
  end

  def test_comparison_by_size
    small = Bag.new(%w[abyss])
    large = Bag.new(%w[untermensch chaos star])
    assert small < large
    assert large > small
  end

  def test_comparison_by_unique_count
    bag1 = Bag.new(%w[will will will])
    bag2 = Bag.new(%w[power übermensch übermensch])
    assert bag1 < bag2
  end

  def test_comparison_lexicographic
    bag1 = Bag.new(%w[circumference opalescence])
    bag2 = Bag.new(%w[circumference phosphorescence])
    assert bag1 < bag2
  end

  def test_comparison_with_non_comparable_elements
    bag1 = Bag.new([1, 'Death'])
    bag2 = Bag.new([2, 'carriage'])
    assert_nil bag1 <=> bag2
  end

  def test_sorting
    bags = [Bag.new(%w[dionysian apollonian ressentiment]), Bag.new(%w[pathos]), Bag.new(%w[nihil untergang])]
    sorted = bags.sort
    assert_equal [1, 2, 3], sorted.map(&:size)
  end

  def test_chaining
    bag = Bag.new
    result = bag.add('abyss').add('eternal', 2).<<('chaos').remove('eternal').clear
    assert_same bag, result
    assert bag.empty?
  end

  def test_coerce_with_struct
    struct_class = Struct.new(:x, :y)
    struct = struct_class.new(2, 3)
    bag = Bag.new(%w[precipice precipice])
    result = bag + struct
    assert_equal 2, result.count(:x)
    assert_equal 3, result.count(:y)
  end

  def test_coerce_type_error
    bag = Bag.new
    assert_raises(TypeError) { bag + 42 }
    assert_raises(TypeError) { bag + :symbol }
  end

  def test_sample_single_element
    bag = Bag.new(%w[dionysian dionysian dionysian apollonian])
    element = bag.sample
    assert_includes %w[dionysian apollonian], element
  end

  def test_sample_multiple_elements
    bag = Bag.new(%w[ressentiment ressentiment ressentiment pathos])
    samples = bag.sample(10)
    assert_equal 10, samples.size
    assert(samples.all? { |element| %w[ressentiment pathos].include?(element) })
  end

  def test_sample_respects_frequency
    bag = Bag.new(['transvaluation'] * 99 + ['perspectivism'])
    samples = bag.sample(100)
    count_trans = samples.count('transvaluation')
    assert count_trans > 80, "Expected 'transvaluation' sampled frequently (got #{count_trans}/100)"
  end

  def test_sample_with_custom_random
    bag = Bag.new(%w[phosphorescence frigate opalescence opalescence])
    rng = Random.new(42)
    result1 = bag.sample(random: rng)
    rng = Random.new(42)
    result2 = bag.sample(random: rng)
    assert_equal result1, result2
  end

  def test_sample_empty_bag
    bag = Bag.new
    assert_nil bag.sample
    assert_equal [], bag.sample(5)
  end

  def test_sample_zero_elements
    bag = Bag.new(%w[untimely selbstüberwindung amor-fati])
    assert_equal [], bag.sample(0)
  end

  def test_sample_negative_raises_error
    bag = Bag.new(%w[genealogy ascetic sovereign])
    assert_raises(ArgumentError) { bag.sample(-1) }
  end

  def test_nil_element_raises_error_on_add
    bag = Bag.new
    assert_raises(ArgumentError) { bag.add(nil) }
    assert_raises(ArgumentError) { bag.add(nil, 5) }
  end

  def test_nil_element_raises_error_on_shovel
    bag = Bag.new
    assert_raises(ArgumentError) { bag << nil }
  end

  def test_sorted_elements
    bag = Bag.new(%w[eternity Death Death carriage])
    sorted = bag.sorted_elements
    assert_equal({'Death' => 2, 'carriage' => 1, 'eternity' => 1}, sorted)
    assert_equal %w[Death carriage eternity], sorted.keys
  end

  def test_sorted_elements_with_strings
    bag = Bag.new(%w[untergang nihil bridge nihil])
    sorted = bag.sorted_elements
    assert_equal %w[bridge nihil untergang], sorted.keys
  end

  def test_cumulative_counts
    bag = Bag.new(%w[soul soul soul immortality immortality perch])
    cumulative = bag.cumulative_counts
    assert_equal [['soul', 3], ['immortality', 5], ['perch', 6]], cumulative
  end

  def test_cumulative_counts_single_element
    bag = Bag.new(%w[abyss abyss abyss])
    cumulative = bag.cumulative_counts
    assert_equal [['abyss', 3]], cumulative
  end

  def test_cumulative_counts_empty
    bag = Bag.new
    assert_equal [], bag.cumulative_counts
  end

  def test_pretty_print_empty_bag
    require 'pp'
    bag = Bag.new
    output = PP.pp(bag, +'', 79)
    assert_match(/^#<Bag>\n$/, output)
  end

  def test_pretty_print_single_element
    require 'pp'
    bag = Bag.new(%w[abyss abyss abyss])
    output = PP.pp(bag, +'', 79)
    assert_match(/#<Bag/, output)
    assert_match(/"abyss" => 3/, output)
  end

  def test_pretty_print_multiple_elements
    require 'pp'
    bag = Bag.new(%w[eternal eternal chaos])
    output = PP.pp(bag, +'', 79)
    assert_match(/#<Bag/, output)
    assert_match(/"eternal" => 2/, output)
    assert_match(/"chaos" => 1/, output)
  end

  def test_pretty_print_with_line_breaks
    require 'pp'
    bag = Bag.new(%w[transvaluation transvaluation perspectivism])
    output = PP.pp(bag, +'', 30)
    lines = output.lines
    assert_operator lines.size, :>, 1
    assert_match(/#<Bag/, lines.first)
  end

  def test_pretty_print_nested_structures
    require 'pp'
    bag = Bag.new([{nihil: 'void'}, {nihil: 'void'}, ['untergang']])
    output = PP.pp(bag, +'', 79)
    assert_match(/#<Bag/, output)
    assert_match(/nihil/, output)
    assert_match(/untergang/, output)
  end

  def test_pretty_print_with_pp_method
    require 'pp'
    bag = Bag.new(%w[soul soul feathers])
    output = capture_io { pp bag }.first
    assert_match(/#<Bag/, output)
    assert_match(/"soul" => 2/, output)
    assert_match(/"feathers" => 1/, output)
  end

  def test_pretty_print_preserves_order
    require 'pp'
    bag = Bag.new(%w[circumference slant diadem])
    output = PP.pp(bag, +'', 79)
    circumference_pos = output.index('circumference')
    slant_pos = output.index('slant')
    diadem_pos = output.index('diadem')
    assert circumference_pos
    assert slant_pos
    assert diadem_pos
  end

  def test_inspect_format
    bag = Bag.new(%w[abyss abyss soul])
    inspected = bag.inspect
    assert_match(/^#<Bag: /, inspected)
    assert_match(/"abyss" => 2/, inspected)
    assert_match(/"soul" => 1/, inspected)
    assert_match(/>$/, inspected)
  end

  def test_to_s_aliases_inspect
    bag = Bag.new(%w[Hope feathers])
    assert_equal bag.inspect, bag.to_s
  end

  def test_pretty_print_with_symbols
    require 'pp'
    bag = Bag.new(%i[dionysian dionysian apollonian])
    output = PP.pp(bag, +'', 79)
    assert_match(/#<Bag/, output)
    assert_match(/dionysian: 2/, output)
    assert_match(/apollonian: 1/, output)
  end

  def test_pretty_print_with_integers
    require 'pp'
    bag = Bag.new([1, 1, 1, 2, 3])
    output = PP.pp(bag, +'', 79)
    assert_match(/#<Bag/, output)
    assert_match(/1 => 3/, output)
    assert_match(/2 => 1/, output)
  end

  def test_pretty_inspect
    require 'pp'
    bag = Bag.new(%w[abyss soul soul])
    pretty = bag.pretty_inspect
    assert_match(/#<Bag/, pretty)
    assert_match(/"abyss" => 1/, pretty)
    assert_match(/"soul" => 2/, pretty)
  end

  def test_pretty_print_large_bag
    require 'pp'
    elements = %w[a b c d e f g h i j k l m n o p q r s t u v w x y z]
    bag = Bag.new(elements * 2)
    output = PP.pp(bag, +'', 40)
    lines = output.lines
    assert_operator lines.size, :>, 10
    assert_match(/#<Bag/, lines.first)
  end
end
