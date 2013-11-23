module Ngrams
  refine String do
    def ngrams(options = {:regex=>//, :n=>2})
      ngrams = []
      tokens = self.split(options[:regex])
      max_pos = tokens.length - options[:n]
      for i in 0..max_pos
        ngrams.push(tokens[i..i+(options[:n]-1)])
      end
      ngrams
    end
  end
end
using Ngrams

class DuplicateFinder
  class NgramText
    attr_accessor :ngrams, :neighbors, :id
    def initialize(id, text)
      @id = id
      # @ngrams = Set.new( (3..8).map{|i| text.ngrams regex: //, n: i}.flatten(1).map{|i|i.join.downcase}).map do |n|
      #   NgramText.ngram_lookup(n)
      # end
      @neighbors = {}
      @ngrams = text.gsub('http://','').split(/[\/\.]/)
    end

    def jaccard(other)
      return if @neighbors[other.id] and other.neighbors[id]
      weight = (ngrams & other.ngrams).length.to_f / (ngrams + other.ngrams).length
      @neighbors[other.id] = weight
      other.neighbors[id] = weight
      weight
    end

    def best_matches
      @neighbors.sort_by{|k,v| -v}.take(5)
    end

    def self.ngram_lookup(word)
      @@ngrams ||= {}
      @@old_i  ||= 0
      if @@ngrams[word]
        @@ngrams[word]
      else
        @@ngrams[word] = @@old_i
        @@old_i += 1
        return @@old_i - 1
      end
    end
  end


  def self.find_duplicates
    puts 'Fetching active sources...'
    sources = Source.active.pluck(:id, :url)
    p1 = ProgressBar.create(:title => "Ngrams", :starting_at => 0, :total => sources.count)
    urls = sources.map do |id, url|
      p1.increment
      NgramText.new(id, url)
    end
    p1.finish

    puts 'Calculating distances...'
    p1 = ProgressBar.create(:title => "Ngrams", :starting_at => 0, :total => urls.count, format: '%e <%B%> %p%% %t')
    urls.each_with_index do |url, index|
      p1.increment
      urls.drop(index + 1).each do |other|
        url.jaccard(other)
      end
    end
    potentials = urls.select{|i| i.neighbors.any?{|k,v| v > 0.3 }}
    potentials.sort_by{|n| n.best_matches[1] }
    potentials.each do |p|
      DuplicateCandidate.new(ids: [p.id] + p.best_matches.take(3).map{|i| i[0]}).save! rescue nil
    end.uniq
    puts DuplicateCandidate.count

    p1.finish
  end
end
