module PeterParser
    class Parser
        def self.run(job=nil)
            instance = self.new((job || @default_job || {}))
            return instance.run()
        end
        
        def initialize(job)
            @job = Hash[job.each{|k, v| [k, v]}]
        end
        
        def run()
            prepare()
        end
        
        def prepare()
            @job['url'] or raise NoURLOnJob, "Could not find an URL to parse on #{@job}"
            @job['data'] = fetch_data(@job['url'])
            @job['data'] = @job['data'].force_encoding(@page_encoding) if @page_encoding
            @job['doc'] = mount_doc(@job['data'])
            
            puts @job['doc'].class
                        
            return nil
        end
        
        def fetch_data(url)
            return RestClient.get(url)
        end
        
        def mount_doc(data)
            return Nokogiri::HTML::Document.new(data)
        end
        
        def call_hook(name)
            send(name) if respond_to?(name)
        end
    end
end
