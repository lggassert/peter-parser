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
                res = {}
                @rules.each{|rule|
                    res.merge!(rule.extract(job.merge({'partial' => res})))
                }
                return res
            end
        end
    end
end
