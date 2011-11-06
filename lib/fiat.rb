require "fiat/version"
require 'colorize'

module Fiat
  def self.dep_tree
    tree = {}
    IO.readlines("Makefile").each do |line|
      if line.include? ":"
        k = line.split(":").first
        line = line.split(":")[1..-1].join(":")
        tree[k] = line.strip.split
      end
    end
    tree
  end

  def self.deps(key, tree)
    if tree.include? key
      tree[key].map { |d| deps(d, tree) }.flatten.uniq
    else
      key
    end
  end

  def self.file_ctimes(filenames)
    hash = {}
    filenames.each do |f|
      if File.exists? f
        hash[f] = File.ctime(f)
      end
    end
    hash
  end

  def self.anything_changed?(filenames, ctimes)
    ctimes != file_ctimes(filenames)
  end

  def self.passed_tests?(result_string)
    $failing_words.each do |f|
      if result_string.include? f
        return false
      end
    end
    true
  end

  def self.crashed?(process)
    process.exitstatus != 0
  end

  def self.run_tests(dependencies, ctimes, instruction)
    results = `make #{instruction}`
    puts results + "\n"

    if crashed?($?) or not passed_tests?(results)
      puts ("#" * 40).red
    else
      puts ("#" * 40).green
    end
  end
end
