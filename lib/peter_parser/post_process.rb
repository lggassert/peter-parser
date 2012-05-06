module PeterParser
    module PostProcess
        class Block < Proc
            def self.get(&block)
                self.new(&block)
            end
        end
        class Iterator < Block
            def self.get(&block)
                self.new{|array|
                    array.map{|val|
                        yield val
                    }
                }
            end
        end
        
        class Transformation < Block
            def self.get(&block)
                self.new(&block)
            end
        end
    end
end
