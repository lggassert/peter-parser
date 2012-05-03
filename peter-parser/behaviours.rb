module PeterParser
    module XMLParser
        def mount_doc(data)
            return Nokogiri::XML(data)
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
