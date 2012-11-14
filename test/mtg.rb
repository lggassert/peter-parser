# -*- encoding: utf-8 -*-
require 'peter_parser'

class MTGParseEngine
    def self.parse(clause, accumul=nil)
        non_terminal = true
        remainder = nil
        if match = clause.match(/^destroy (.*)/) 
            value = {'effect' => 'destroy', 'target' => parse(match[1])}
        elsif match = clause.match(/^target (.*)/)
            value = parse(match[1])
        elsif match = clause.match(/^artifact(.*)/)
            value = {'type' => 'artifact', 'attribute' => 'permanent'}
            remainder = match[1]
            non_terminal = false
        elsif match = clause.match(/^enchantment(.*)/)
            value = {'type' => 'enchantment', 'attribute' => 'permanent'}
            remainder = match[1]
            non_terminal = false
        elsif match = clause.match(/^or (.*)/)
            value = {'or' => [accumul, parse(match[1])]}
        elsif match = clause.match(/^([wubrg])(\s|$)(.*)/)
            value = {'effect' => 'add mana', 'color' => match[1]}
            remainder = match[3]
            non_terminal = false
        elsif match = clause.match(/^flash(.*)/)
            value = {'ability' => 'flash'}
            remainder = match[1]
            non_terminal = false
        elsif match = clause.match(/^flying(.*)/)
            value = {'ability' => 'flying'}
            remainder = match[1]
            non_terminal = false
        elsif match = clause.match(/^when (.*)/)
            value = parse_trigger(match[1])
        else
            value = clause
        end
        
        if not non_terminal
            remainder.strip!
            if remainder != "." and remainder != ""
                value = parse(remainder, value)
            end
        end
        
        return value
    end
end

class CardModel
    attr_accessor :hash

    def +(other)
        hash.merge(other.hash)
    end

    ColorSymbol = {
        "white" => "W",
        "blue"  => "U",
        "black" => "B",
        "red"   => "R",
        "green" => "G",
    }
    
    SymbolColor = ColorSymbol.invert
    
    def symbolNumberVar(value)
        if symbol = ColorSymbol[value]
            return symbol
        elsif num = intFloatNan(value)
            return num
        else
            return {"var" => value}
        end
    end
    
    def intFloatNan(value)
        if match = value.match(/^(\d+)$/)
            return match[1].to_i
        elsif match = value.match(/^([0-9\.]+)$/)
            return match[1].to_f
        else
            return nil
        end
    end

    def initialize(hash={})
        self.hash = {}
                
        if hash[':labels'] and hash[':values']
            self.hash += Hash[hash[':labels'].zip(hash[':values'])]
        end
        
        hash.keys.each{|key|
            if self.hash[key]
                self.hash[key] = hash[key]
            end
        }
        
        transform = {
            'card_#' => 'card_num',
            'card_text' => 'cardtext',
            'community_rating' => 'ratings',
            'converted_mana_cost' => 'cmc',
            'p/t' => 'p_t',
        }
        
        transform.each{|old, new|
            next if not self.hash[old] 
            self.hash[new] = self.hash[old]
            self.hash.delete(old)
        }
        
        adjust = [
            'card_num',
            'cardtext',
            'cmc',
            'mana_cost',
            'p_t',
            'ratings',
            'types',
        ]
        
        adjust.each{|key|
            next if not value = self.hash[key]
            value = self.send('adjust_'+key, value)
            if value
                self.hash[key] = value
            else
                self.hash.delete(key)
            end
        }
    end
    
    def adjust_card_num(value)
        return value.to_i
    end
    
    def adjust_cardtext(value)
        text = value.map{|clause|
            clause.gsub!(self.hash['card_name'], '~')
            MTGParseEngine.parse(clause.downcase)
        }
    end
    
    def adjust_cmc(value)
        return value.to_i
    end
    
    def adjust_mana_cost(value)
        mana_cost = value.map{|cost|
            symbolNumberVar(cost.downcase)
        }
        return mana_cost
    end
    
    def adjust_p_t(value)
        (power, tough) = value.match(/(.*) \/ (.*)/)[1,2]
        self.hash['power'] = symbolNumberVar(power)
        self.hash['toughness'] = symbolNumberVar(tough)
        return nil
    end
    
    def adjust_ratings(value)
        (rate, max, votes) = value.match(/Rating: ([0-9\.]+) \/ (\d+).*?(\d+) votes/)[1, 3]
        ratings = {
            'rate'  => intFloatNan(rate),
            'max'   => intFloatNan(max),
            'votes' => votes.to_i,
        }
        return ratings
    end

    def adjust_types(value)
        (supertypes, subtypes) = value.split('—')[0..1]
        supertypes = supertypes.split(' ').map{|el| el.strip} if supertypes
        subtypes = subtypes.split(' ').map{|el| el.strip} if subtypes
        types = {
            'supertypes' => supertypes,
            'subtypes' => subtypes,
        }
        return types
    end
end

class Card < PeterParser::Parser    
    @extractor = R(CardModel, {
        ':labels'   => x("//div[@class='label']").iter{|el| el.strip.downcase.gsub(' ','_').gsub(':','') if el},
        ':values'   => x("//div[@class='value']").iter{|el| el.strip if el},
        'card_text' => or_(
            x("//div/div[@class='value']/div[@class='cardtextbox']/../../preceding-sibling::*//div[@class='cardtextbox']"),
            x("//div[@class='value']/div[@class='cardtextbox']"),
        ).iter{ |el| el.strip if el},
        'mana_cost' => x("//div[@class='value']/img/@alt").iter{|el| el.strip if el},
        'all_sets'  => x("//div[@class='value']/div/a/img/@alt").iter{|el| el.match(/(.*) \((.*)\)/)[1,2] }.pproc{|el| el.flatten}.to(Hash)
    })
end

if __FILE__ == $0
    require 'pp'
    cards = [
        'http://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid=240096',  #Restoration Angel
        #'http://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid=253672',  #Naturalize
        #'http://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid=249723',  #Island
    ]
    cards.each{|card|
        pp Card.run({'url' => card})
    }
end
