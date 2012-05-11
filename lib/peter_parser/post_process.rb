module PeterParser
    module PostProcess
        class Block < Proc
            def self.get(&block)
                return self.new(&block)
            end
        end
        
        class Iterator < Block
            def self.get(&block)
                return self.new{|array|
                    array.map{|val|
                        yield val
                    }
                }
            end
        end
        
        class Transformation < Block
            def self.get(origin, descriptor)
                if origin.class == Array and descriptor == Hash
                    transform = Proc.new{|ar| Hash[*ar]}
                elsif descriptor == String
                    transform = Proc.new{|this| String(this)}
                elsif descriptor.class == Class
                    transform = Proc.new{|this| descriptor.new(this)}
                else
                    transform = Proc.new{|this| this.send('to_' + String(descriptor))}
                end
                return self.new(&transform)
            end
        end
    end
end
