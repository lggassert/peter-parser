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
            if get_class_variable(:@page_encoding)
                if data.match(/<\?xml.*encoding="(.*)".*\?>/){|m| m[1]}
                    data.sub!(/(<\?xml.*encoding=").*(".*\?>)/, '\1UTF-8\2')
                else
                    data.sub!(/(<\?xml.*)(\?>)/, '\1 encoding="UTF-8" \2')
                end
                @job['data'] = data
            end
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
