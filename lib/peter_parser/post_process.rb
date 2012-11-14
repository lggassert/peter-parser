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
            def self.get(descriptor)
                transform = Proc.new{|this|
                    if this.class == Array and descriptor == Hash
                        Hash[*this]
                    elsif descriptor == String
                        String(this)
                    elsif descriptor.class == Class
                        descriptor.new(this)
                    else
                        this.send('to_' + String(descriptor))
                    end
                }
                return self.new(&transform)
            end
        end
    end
end
