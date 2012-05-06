module PeterParser
    module Components
        class XPathSelector
            include NonNativeComponent
        
            def _init(selector, index=0..-1, &block)
                @selector = selector
                @index = index
            end
            
            def _extract(job)
                res = job['doc'].xpath(@selector)[@index]
                if @index.class == Range
                    res.map{|el| el.content}
                else
                    res.content if res
                end
            end
        end
    end
end
