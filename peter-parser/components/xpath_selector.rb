module PeterParser
    module Components
        class XPathSelector
            include Component
        
            def initialize(selector, index=0..-1, &block)
                @selector = selector
                @index = index
                pproc(&block)
            end
            
            def _extract(job)
                res = job['doc'].xpath(@selector)[@index]
                if @index.class == Range
                    res.map{|el| el.content}
                else
                    res.content
                end
            end
        end
    end
end
