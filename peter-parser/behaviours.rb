module PeterParser
    module XMLParser
        def mount_doc(data)
            return Nokogiri::XML::Document.new(data)
        end 
    end
end
