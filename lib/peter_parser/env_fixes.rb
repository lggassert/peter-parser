module PeterParser
    module EnvFixes
        module Array
            def do_extract(job)
                return self.map{|rule|
                    rule.extract(job)
                }.compact
            end
        end
        
        module Hash
            def +(a_hash)
                return self.merge(a_hash)
            end
        
            def do_extract(job)
                return Object::Hash[self.map{|field, rule|
                    res = rule.extract(job)
                    [field, res]
                }]
            end
        end
    end
end

class Object
    include PeterParser::Components::Component
end

class Array
    include PeterParser::EnvFixes::Array
end

class Hash
    include PeterParser::EnvFixes::Hash
end
