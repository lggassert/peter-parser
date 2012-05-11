module PeterParser
    module HTMLParser
        def mount_doc(data)
            require 'nokogiri'
            return Nokogiri::HTML(data)
        end
    end

    module XMLParser
        def mount_doc(data)
            require 'nokogiri'
            return Nokogiri::XML(data)
        end 
    end
    
    module NetworkFile
        def fetch_data(url)
            require 'restclient'
            return RestClient.get(url)
        end
    end
    
    module LocalFile
        def fetch_data(url)
            f = File.open(url)
            content = f.inject{|a, b| a.concat(b)}
            f.close
            
            return content
        end
    end
end
