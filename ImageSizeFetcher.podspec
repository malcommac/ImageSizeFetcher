Pod::Spec.new do |s|
  s.name         = "ImageSizeFetcher"
  s.version      = "0.9.0"
  s.summary      = "Finds the size or type of an image given its URL by fetching as little as needed"
  s.description  = <<-DESC
    ImageSizeFetcher attempt to parse the size of an image downloaded as little data as needed without getting the entire file.
  DESC
  s.homepage     = "https://github.com/malcommac/ImageSizeFetcher.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Daniele Margutti" => "hello@danielemargutti.com" }
  s.social_media_url   = "https://twitter.com/danielemargutti"
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/malcommac/ImageSizeFetcher.git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*"
  s.frameworks  = "Foundation"
  s.swift_version = "4.0"
end
