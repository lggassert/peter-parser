class Array
    include PeterParser::Components::IterableComponent
    
    def _extract(job)
        return self.map{|rule|
            PeterParser::Components.extract(rule, job)
        }.flatten
    end
end
