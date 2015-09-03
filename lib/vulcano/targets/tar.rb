# encoding: utf-8
require 'rubygems/package'
require 'zlib'

module Vulcano::Targets
  class TarHelper

    def structure(input)
      files = Array.new
      Gem::Package::TarReader.new( Zlib::GzipReader.open input ) do |tar|
        files = tar.map{|entry| entry.full_name }
      end
      files
    end

    def content(input)
      content = {}
      Gem::Package::TarReader.new( Zlib::GzipReader.open input ) do |tar|
        tar.each do |entry|
          if entry.directory?
            #nothing to do
          elsif entry.file?
            content[entry.full_name] = entry.read
          elsif entry.header.typeflag == '2'
            # ignore symlinks for now
          end
        end
      end
      content
    end
  end
end
