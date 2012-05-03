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
        end
    end
end
