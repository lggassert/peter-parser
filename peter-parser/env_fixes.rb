module PeterParser
    module EnvFixes
        module Array
            def _extract(job)
                return self.map{|rule|
                    rule.extract(job)
                }.compact
            end
        end
        
        module Hash
            def +(a_hash)
                return self.merge(a_hash)
            end
        
            def _extract(job)
                return Object::Hash[self.map{|field, rule|
                    res = rule.extract(job)
                    [field, res]
                }]
            end
        end
    end
end

class Array
    include PeterParser::Components::Component
    include PeterParser::EnvFixes::Array
end

class Hash
    include PeterParser::Components::Component
    include PeterParser::EnvFixes::Hash
end

module Kernel
    def extract(job={})
        return self
    end
end
