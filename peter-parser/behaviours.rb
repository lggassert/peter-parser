module PeterParser
    module XMLParser
        def mount_doc(data)
            return Nokogiri::XML(data)
        end 
    end
end
