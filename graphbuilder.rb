# encoding: utf-8
Encoding.default_external = 'utf-8'
Encoding.default_internal = 'utf-8'
require 'rubygems'
require 'bundler'
Bundler.require

@data={}

[:followers,:following].each do |type|
@e_id=-1
  @data[type] = Hash[Dir["./#{type}/*.json"].map{|j| [j.gsub(/^.*[\\\/]|\.json$/,""), JSON.parse((content=File.open(j,&:read)).strip==""?"{}":content).map{|u|u["login"]}] }]
File.open("#{type}.gexf","w"){|f| f.write <<-GEXF}
<?xml version="1.0" encoding="UTF-8"?>
<gexf xmlns="http://www.gexf.net/1.2draft" version="1.2"><graph mode="static" defaultedgetype="directed">
<nodes>
#{ (@data[type].keys+@data[type].values).flatten.uniq.map{|n| "<node id=\"#{n}\" label=\"#{n}\"/>"}.join("\n") }
</nodes>
<edges>
#{ @data[type].map{|k,v| v.map{|c| "<edge id=\"#{@e_id+=1}\" source=\"#{type==:followers ? c:k}\" target=\"#{type==:followers ? k:c}\"/>" } }.flatten.join("\n") }
</edges>
</graph></gexf>
GEXF
end