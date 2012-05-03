module PeterParser
    module EnvFixes
        module Array
            def _extract(job)
                return self.map{|rule|
                    rule.extract(job)
                }
            end
        end
        
        module Hash
            def _extract(job)
                return Object::Hash[self.map{|field, rule|
                    [field, rule.extract(job)]
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
