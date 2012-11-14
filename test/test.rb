# -*- encoding: utf-8 -*-
require 'peter_parser'

class TestParser < PeterParser::Parser
    include PeterParser::XMLParser
    include PeterParser::LocalFile

    @default_job = {
        'url' => './test/assets/test.xml',
    }

    @extractor = R(
        {
            'lang' => x("//language", 0),
            'songs' => x("//item/title").iter{|item| item.match(".* – (.*)")[-1]},
            'bands' => x("//item/title").iter{|item| item.match("(.*) – .*")[-1]}.pproc{|ar| ar.sort.uniq},
            'iterate_array' => [1, 2,].iter{|a| a.to_s + " check"},
            'info_ruleset' => R({
                'version' => x("/rss/@version", 0),
            }),
            'a_number' => 222.to('s'){|x| x + ' ok'},
            'source' => 'last.fm',
            'or' => or_([], nil, "", {}, x("/wrongXpath"), "or is ok"),
            'url' => url,
        },
        {
            '2nd song' => partial['songs'][1],
            '3rd song' => partial['songs'][2],
        },
        [1, 2, 3, 4],
    )
end

if __FILE__ == $0
    require 'pp'
    pp TestParser.run
    pp TestParser.run
end
