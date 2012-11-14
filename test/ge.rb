# -*- encoding: utf-8 -*-
require 'peter_parser'

class GEParser < PeterParser::Parser
    include PeterParser::XMLParser
    include PeterParser::LocalFile
    
    @default_job = {
        'url' => './test/assets/ge.xml',
    }

    @extractor = R({
        "tech_spec" => x("//item/@opcao | //item/@valor").to(Hash),
    },
        partial('tech_spec'){|hash|
            code = nil
            barcode = nil
            hash.keys.sort.map{|key|
                if key.match('EAN')
                    candidate = hash[key]
                    barcode = hash[key] if barcode.nil? and candidate != "#" and candidate != "-"
                elsif (not code) and key.match('C.digo')
                    code = hash[key]
                end
                if code and barcode
                    break
                end
            }
            barcode.gsub!(/[\s\-#]/,"") if barcode
            {'code' => code, 'barcode' => barcode}
        }
    )
end

if __FILE__ == $0
    require 'pp'
    pp GEParser.run
end
