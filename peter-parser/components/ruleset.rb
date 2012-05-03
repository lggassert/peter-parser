module PeterParser
    module Components
        class Ruleset
            include NonNativeComponent
        
            def _init(*rules, &block)
                @rules = rules
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
