# -*- encoding: utf-8 -*-
require './peter-parser'

class TestParser < PeterParser::Parser
    include PeterParser::XMLParser
    include PeterParser::LocalFile

    @default_job = {
        'url' => 'http://ws.audioscrobbler.com/1.0/user/lggassert/recenttracks.rss',
        'url' => './test.xml',
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
            'songs_per_band' => part{|part| part['songs'].size * 1.0/part['bands'].size},
            '2nd song' => part('songs', 1),
        },
    )
end

if __FILE__ == $0
    puts TestParser.run
end
