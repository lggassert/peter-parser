module PeterParser
    module Components
        class Ruleset
            include Component
        
            def initialize(rules)
                @rules = rules
            end
            
            def self.[](rules)
                return Ruleset.new(rules)
            end
            
            def _extract(job)
                Hash[@rules.map{|field, rule|
                    f_v = [field, PeterParser::Components.extract(rule, job)]
                }]
            end
        end
    end
end
