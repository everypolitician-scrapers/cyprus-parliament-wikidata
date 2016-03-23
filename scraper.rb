#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

ids = EveryPolitician::Wikidata.morph_wikinames(source: 'tmtmtmtm/cyprus-openpatata', column: 'identifier__wikidata')
EveryPolitician::Wikidata.scrape_wikidata(ids: ids)
