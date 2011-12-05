begin
  require "text"
rescue LoadError
  raise LoadError,
    "Type `[sudo] gem install text` to use Ohm::FulltextSearching."
end

module Ohm
  module FulltextSearching
    def self.included(model)
      model.extend ClassMethods
    end
  
    module ClassMethods
      def search(hash)
        find(hash_to_metaphones(hash))
      end
  
      def hash_to_metaphones(hash)
        ret = Hash.new { |h, k| h[k] = [] }

        hash.each do |att, string|
          metaphones(string).each { |m| ret[:"fulltext_#{att}"] << m }
        end
        
        return ret
      end
  
      def double_metaphone(str)
        return [] if STOPWORDS.include?(str.to_s.downcase)

        Text::Metaphone.double_metaphone(str).compact
      end

      def metaphones(str)
        str.to_s.strip.split(/\p{Space}+/).map { |s| double_metaphone(s) }.flatten
      end

      def fulltext(att)
        field = :"fulltext_#{att}"
        
        define_method(field) { self.class.metaphones(send(att)) }
        index(field)
      end
    end

    STOPWORDS = %w{a about above according across actually adj after 
      afterwards again against all almost alone along already also although 
      always among amongst an and another any anyhow anyone anything anywhere 
      are aren't around as at b be became because become becomes becoming 
      been before beforehand begin behind being below beside besides between
      beyond both but by c can can't cannot caption co co. could couldn't d 
      did didn't do does doesn't don't down during e each eg eight eighty 
      either else elsewhere end ending enough etc even ever every everyone 
      everything everywhere except f few first for found from further g h 
      had has hasn't have haven't he he'd he'll he's hence her here here's 
      hereafter hereby herein hereupon hers herself him himself his how 
      however hundred i i'd i'll i'm i've ie if in inc. indeed instead into is
      isn't it it's its itself j k l last later latter latterly least less let
      let's like likely ltd m made make makes many maybe me meantime meanwhile 
      might miss more moreover most mostly mr mrs much must my myself n namely 
      neither never nevertheless next nine ninety no nobody none nonetheless 
      noone nor not nothing now nowhere o of off often on once one one's only 
      onto or other others otherwise our ours ourselves out over overall own 
      p per perhaps q r rather recent recently s same seem seemed seeming 
      seems seven several she she'd she'll she's should shouldn't since so 
      some somehow someone something sometime sometimes somewhere still such 
      t taking than that that'll that's that've the their them themselves then
      thence there there'd there'll there're there's there've thereafter thereby 
      therefore therein thereupon these they they'd they'll they're they've 
      thirty this those though three through throughout thru thus to together 
      too toward towards u under unless unlike unlikely until up upon us used 
      using v very via w was wasn't we we'd we'll we're we've well were weren't 
      what what'll what's what've whatever when whence whenever where where's 
      whereafter whereas whereby wherein whereupon wherever whether which while 
      whither who who'd who'll who's whoever whole whom whomever whose why will 
      with within without won't would wouldn't x y yes yet you you'd you'll 
      you're you've your yours yourself yourselves z}
  end
end
