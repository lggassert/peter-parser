module PeterParser
    module Components
        class Ruleset
            include Component
        
            def initialize(*rules, &block)
                @rules = rules
                pproc(&block)
            end
            
            def self.[](*rules, &block)
                return Ruleset.new(*rules, &block)
            end
            
            def _extract(job)
                @rules.map{|rule|
                    rule.extract(job)
                }.inject(&:merge)
            end
        end
    end
end
