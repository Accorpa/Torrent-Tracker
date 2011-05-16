#!/usr/bin/env ruby

base_dir = File.expand_path(File.join(File.dirname(__FILE__),".."))
require File.expand_path(File.join(base_dir, 'config', 'environment'))

start = Time.now

HandleDownloads.new("#{ENV["TR_TORRENT_DIR"]}","#{ENV["TR_TORRENT_NAME"]}").delay.perform

File.open("#{base_dir}/log/handle_downloads.log", 'a') do |f|
  f.puts "Initiating HandleDownloads at #{start} with TR_TORRENT_DIR = #{ENV["TR_TORRENT_DIR"]}, TR_TORRENT_NAME = #{ENV["TR_TORRENT_NAME"]} and finished in #{(Time.now - start).to_i} seconds"
end
