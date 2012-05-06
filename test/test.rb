# -*- encoding: utf-8 -*-
require 'peter_parser'

class TestParser < PeterParser::Parser
    include PeterParser::XMLParser
    #include PeterParser::LocalFile

    @default_job = {
        #'url' => './assets/test.xml',
        'url' => 'http://ws.audioscrobbler.com/1.0/user/lggassert/recenttracks.rss',
    }

    @extractor = R(
        {
            'a_number' => 222,
            'lang' => x("//language", 0),
            'songs' => x("//item/title").iter{|item| item.match(".* – (.*)")[-1]},
            'bands' => x("//item/title").iter{|item| item.match("(.*) – .*")[-1]}.pproc{|ar| ar.sort.uniq},
            'something' => ['a', x("//language", 0),].iter{|a| a + " HAHAHA"},
            'some_info' => R({
                'version' => x("/rss/@version", 0),
            }),
            'source' => 'last.fm',
            'or' => or_(x("//language", 1), "a"),
            'url' => url,
        },
        {
            'songs_per_band' => partial{|part| part['songs'].size * 1.0/part['bands'].size}.to(String),
            '2nd song' => partial['songs'][1],
        },
        [1, 2, 3, 4],
    )
end

if __FILE__ == $0
    require 'pp'
    pp TestParser.run
end
