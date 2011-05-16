Factory.define :feed do |f|
  f.name "Feed name"
  f.url "http://example.com/feed.rss"
end

Factory.define :another_feed, :parent => "feed" do |f|
  f.url "http://example.com/feed2.rss"
end
