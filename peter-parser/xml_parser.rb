module PeterParser
    class XMLParser < Parser
        def self.mount_doc(data)
            return Nokogiri::XML::Document.new(data)
        end 
    end
end
