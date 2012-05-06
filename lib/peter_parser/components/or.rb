module PeterParser
    module Components
        class Or
            include NonNativeComponent
            
            def _init(*rules, &block)
                @rules = rules
            end
            
            def _extract(job)
                @rules.each{|rule|
                    res = rule.extract(job)
                    return res if res and not res.empty?
                }
            end
        end
    end
end
