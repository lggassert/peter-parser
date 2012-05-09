module PeterParser
    module Components
        class LazyEvaluator
            include NonNativeComponent
            
            def _init(*idxs, &block)
                idxs.each{|idx|
                    _lazy_access(idx)
                }
            end
            
            def _extract(job)
                return job
            end
            
            def _lazy_access(idx)
                pproc{|j| j[idx]}
            end
            
            def [](idx, &block)
                _lazy_access(idx)
                pproc(&block)
                return self
            end
        end
    end
end
