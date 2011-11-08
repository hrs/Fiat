require 'fiat/version'
require 'colorize'

module Fiat
  def self.dep_tree
    tree = {}
    task_headers = IO.readlines("Makefile").select{ |l| l.include? ":" }
    
    task_headers.each do |line|
      k = line.split(":").first
      reqs = line.split(":")[1..-1].join(":")
      tree[k] = reqs.strip.split
    end
    
    tree
  end

  def self.deps(key, tree)
    if tree.include? key
      tree[key].map{ |d| deps(d, tree) }.flatten.uniq
    else
      key
    end
  end

  def self.file_ctimes(filenames)
    hash = {}
    real_files = filenames.select{ |f| File.exists? f }

    real_files.each do |f|
        hash[f] = File.ctime(f)
    end
    
    hash
  end

  def self.anything_changed?(filenames, ctimes)
    ctimes != file_ctimes(filenames)
  end

  def self.passed_tests?(result_string, failure_terms)
    failure_terms.select{ |term| result_string.include? term }.empty?
  end

  def self.crashed?(process)
    process.exitstatus != 0
  end

  def self.run_tests(dependencies, ctimes, instruction, failure_terms)
    results = `make #{instruction}`
    puts results + "\n"

    bar = "#" * 40
    if crashed?($?) or not passed_tests?(results, failure_terms)
      puts bar.red
    else
      puts bar.green
    end
  end
end
