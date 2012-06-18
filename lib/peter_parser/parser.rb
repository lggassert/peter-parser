module PeterParser
    class Parser
        include PeterParser::HTMLParser
        include PeterParser::NetworkFile
        
        # LOTS OF DEFINITIONS FOR MAKING LIFE EASIER
        def self.xpath(xpath, index=(0..-1), &postprocess)
            return PeterParser::Components::XPathSelector.new(xpath, index, &postprocess)
        end
    
        def self.R(*args, &block)
            PeterParser::Components::Ruleset.new(*args, &block)
        end
        
        def self.or_(*args, &block)
            PeterParser::Components::Or.new(*args, &block)
        end
        
        def self.job(*args, &block)
            PeterParser::Components::LazyEvaluator.new(*args, &block)
        end
        
        def self.url(*args, &block)
            job('url', *args, &block)
        end
        
        def self.partial(*args, &block)
            job('partial', *args, &block)
        end
        
        class << self
            alias_method :x, :xpath
        end
        # END OF DEFINITIONS
        
        def self.run(job=nil)
            instance = self.new((job || @default_job || {}))
            return instance.run()
        end
        
        def initialize(job={})
            @job = Hash[job.each{|k, v| [k, v]}]
        end
        
        def run()
            prepare()
            call_hook(:pre_parse)
            @result = parse()
            call_hook(:post_parse)
            handled = handle()
            
            return handled
        end
        
        def prepare()
            @job['url'] or raise NoURLOnJob, "Could not find an URL to parse on #{@job}"
            @job['data'] = fetch_data(@job['url'])
            if (encoding = get_class_variable(:@page_encoding))
                @job['data'] = @job['data'].force_encoding(encoding)
                @job['data'].encode!('utf-8')
            end
            @job['doc'] = mount_doc(@job['data'])
            
            return nil
        end
        
        def get_class_variable(var_name)
            return self.class.instance_variable_get(var_name)
        end
        
        def call_hook(name, *args)
            return send(name, *args) if respond_to?(name)
            return true
        end
        
        def parse()
            extractor = get_class_variable(:@extractor)
            return extractor.extract(@job)
        end
        
        def handle()
           return @result.handle(get_class_variable(:@handler) || {})
        end
    end
end
