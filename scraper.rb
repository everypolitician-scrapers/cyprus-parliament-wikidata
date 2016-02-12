#!/bin/env ruby
# encoding: utf-8

require 'pry'
require 'wikidata/fetcher'

links = EveryPolitician::Wikidata.morph_wikinames(source: 'tmtmtmtm/cyprus-openpatata', column: 'wikipedia')

def urls_to_names(a)
  a.map { |u| URI.decode File.basename u }
end

by_site = links.group_by { |p| p[/\/\/(\w+).wikipedia.org/, 1] }
EveryPolitician::Wikidata.scrape_wikidata(names: { 
  en: urls_to_names(by_site['en']),
  el: urls_to_names(by_site['el']),
})

warn EveryPolitician::Wikidata.notify_rebuilder

