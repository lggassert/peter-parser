module PeterParser
    module Components
        module Component
            def extract(job)
                res = _extract(job)
                (@postprocess || []).each{|proc|
                    res = proc.call(res)
                }
                return res
            end    
            
            def pproc(&block)
                @postprocess = [] if not @postprocess
                @postprocess.push(block) if block
                return self
            end
        end
    
        module IterableComponent
            include Component
        
            def iter(&block)
                @postprocess = [] if not @postprocess
                iter = PeterParser::PostProcess::Iterator.get_iter(&block)
                @postprocess.push(iter) if block
                return self
            end
        end
    
        def self.extract(obj, job)
            if obj.respond_to?(:extract)
                obj.extract(job)
            else
                obj
            end
        end
    end
end

require_relative './components/xpath_selector.rb'
require_relative './components/ruleset.rb'

require_relative './components/objects.rb'
