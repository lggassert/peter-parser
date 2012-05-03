module PeterParser
    class Parser
        def self.perform(job=nil)
            @job = Hash[(job || @default_job).map{|k, v| [k, v]}]
            prepare()
            
        end
        
        def self.prepare()
            @job['url'] or raise NoURLOnJob, "Could not find an URL to parse on #{@job}"
            @job['data'] = fetch_data(@job['url'])
            @job['data'] = @job['data'].force_encoding(@page_encoding) if @page_encoding
            @job['doc'] = mount_doc(@job['data'])
            
            return nil
        end
        
        def self.fetch_data(url)
            return RestClient.get(url)
        end
        
        def self.mount_doc(data)
            return Nokogiri::HTML::Document.new(data)
        end
        
        def self.call_hook(name)
            self.send(name) if self.respond_to?(name)
        end
    end
end
