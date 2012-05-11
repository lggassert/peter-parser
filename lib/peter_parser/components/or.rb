module PeterParser
    module Components
        class Or
            include NonNativeComponent
            
            def do_init(*rules, &block)
                @rules = rules
            end
            
            def do_extract(job)
                @rules.each{|rule|
                    res = rule.extract(job)
                    return res if res and not res.empty?
                }
            end
        end
    end
end
