module PeterParser
    module Components
        module Component
            def _init_comp()
                @postprocess = [] if not @postprocess
                return true
            end

            def _do_pp(res)
                _init_comp()
                @postprocess.each{|proc|
                    res = proc.call(res)
                }
                return res
            end

            def extract(job)
                res = _extract(job)
                res = _do_pp(res)
                return res
            end

            def pp_push(&block)
                _init_comp()
                if block
                    @postprocess.push(block)
                    return true
                end
                return false
            end

            def pproc(&block)
                if block
                    block = PeterParser::PostProcess::Block.get(&block)
                    pp_push(&block)
                end
                return self
            end

            def iter(&block)
                if block
                    iter = PeterParser::PostProcess::Iterator.get(&block)
                    pp_push(&iter)
                end
                return self
            end

            def to(*args, &block)
                args.each{ |descriptor|
                    if self.class == Array and descriptor == Hash
                        transform = Proc.new{|array| Hash[*array]}
                    elsif descriptor == String
                        transform = Proc.new{|this| String(this)}
                    elsif descriptor.class == Class
                        transform = Proc.new{|this| descriptor.new(this)}
                    else
                        transform = Proc.new{|this| this.send('to_' + String(descriptor))}
                    end
                    transform = PeterParser::PostProcess::Transformation.get(&transform)
                    pp_push(&transform)
                }
                pproc(&block)
                return self
            end
        end

        module NonNativeComponent
            include Component

            def initialize(*args, &block)
                _init(*args, &block)
                pproc(&block)
            end
        end
    end
end

require 'peter_parser/components/xpath_selector.rb'
require 'peter_parser/components/ruleset.rb'
require 'peter_parser/components/or.rb'
require 'peter_parser/components/lazy_evaluator.rb'
