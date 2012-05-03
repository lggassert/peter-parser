module PeterParser
    module Components
        class XPathSelector
            include IterableComponent
        
            def initialize(selector, index=0..-1, &block)
                @selector = selector
                @index = index
                iter(&block)
            end
            
            def _extract(job)
                return job['doc'].xpath(@selector).map{|el| el.content}[@index]
            end
        end
    end
end
