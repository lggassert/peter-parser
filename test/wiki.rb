# -*- encoding: utf-8 -*-
require 'peter_parser'

class WikipediaParser < PeterParser::Parser
    include PeterParser::HTMLParser
    include PeterParser::NetworkFile
    
    @default_job = {
        'url' => 'http://en.wikipedia.org/wiki/Taxonomy',
    }

    @extractor = R({
        'page_text' => x("//div[@id='mw-content-text']/p"),
    })
end

if __FILE__ == $0
    require 'pp'
    pp WikipediaParser.run
end
