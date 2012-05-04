module PeterParser
    module Components
        class Ruleset
            include NonNativeComponent
        
            def _init(first, *rules, &block)
                if first.class == Class
                    @res_class = first
                else
                    @res_class = nil
                    rules.unshift(first)
                end
                @rules = rules
            end
            
            def self.[](*rules, &block)
                return Ruleset.new(*rules, &block)
            end
            
            def _extract(job)
                res = @res_class.new if @res_class
                @rules.each{|rule|
                    part = rule.extract(job.merge({'partial' => res}))
                    if not @res_class
                        @res_class = part.class
                        res = @res_class.new
                    elsif part.class != @res_class
                        part = @res_class.new(part)
                    end
                    res = res + part
                }
                return res
            end
        end
    end
end
