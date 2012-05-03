module PeterParser
    module PostProcess
        class Iterator < Proc
            def self.get_iter(&block)
                self.new{|array|
                    array.map{|val|
                        yield val
                    }
                }
            end
        end
    end
end
