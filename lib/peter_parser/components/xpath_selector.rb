module PeterParser
    module Components
        class XPathSelector
            include NonNativeComponent
        
            def do_init(selector, index=0..-1, &block)
                @selector = selector
                @index = index
            end
            
            def do_extract(job)
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
