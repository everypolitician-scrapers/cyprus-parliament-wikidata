#!/bin/env ruby
# encoding: utf-8

require 'json'
require 'pry'
require 'rest-client'
require 'scraperwiki'
require 'wikidata/fetcher'
require 'mediawiki_api'


def pages
  morph_api_url = 'https://api.morph.io/tmtmtmtm/cyprus-openpatata/data.json'
  morph_api_key = ENV["MORPH_API_KEY"]
  result = RestClient.get morph_api_url, params: {
    key: morph_api_key,
    query: "select DISTINCT(wikipedia) AS wikiname from data"
  }
  JSON.parse(result, symbolize_names: true).map { |p| p[:wikiname] }.compact
end

by_site = pages.group_by { |p| p[/\/\/(\w+).wikipedia.org/, 1] }


by_site.each do |site, urls|
  WikiData.ids_from_pages(site, urls.map { |u| URI.decode File.basename u }).each_with_index do |p, i|
    data = WikiData::Fetcher.new(id: p.last).data(site) rescue nil
    unless data
      warn "No data for #{p}"
      next
    end
    data[:original_wikiname] = p.first
    ScraperWiki.save_sqlite([:id], data)
  end
end

require 'rest-client'
warn RestClient.post ENV['MORPH_REBUILDER_URL'], {} if ENV['MORPH_REBUILDER_URL']

