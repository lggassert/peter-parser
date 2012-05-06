module PeterParser
    module Components
        class LazyEvaluator
            include NonNativeComponent
            
            def _init(*idx, &block)
                @idx = idx
            end
            
            def _extract(job)
                idx = @idx.shift
                return job if not idx
                str = job[idx]
                @idx.each{|idx|
                    str = str[idx]
                    break if not str
                }
                return str
            end
            
            def [](idx, &block)
                access = Proc.new{|j| j[idx]}
                pproc(&access)
                pproc(&block)
                return self
            end
        end
    end
end
