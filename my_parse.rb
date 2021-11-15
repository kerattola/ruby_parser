require 'mechanize'
require 'date'
require 'json'
require 'csv'
require 'set'
require 'sorted_set'

agent = Mechanize.new
page = agent.get("https://pitchfork.com/best/")

best = page.links_with(href: %r{^/reviews/best/\w+})

best = best[2..4]

puts "///////....4 BEST ALBUMS.....////////"
see_album = best[0].click
album_links = see_album.links_with(href: %r{^/reviews/albums/\w+})
album_links = album_links[0...4]
# puts album_links

albums_best = album_links.map do |link|
  albums_best= link.click

  artist = albums_best.search('.artist-links').text
  album = albums_best.search('.single-album-tombstone__review-title').text
  label, year = albums_best.search('.single-album-tombstone__meta').text.split('•').map(&:strip)
  reviewer = albums_best.search('.authors-detail__display-name').text
  review_date = Time.parse(albums_best.search('.pub-date')[0]['title'])
  score = albums_best.search('.score').text.to_f
  {
    artist: artist,
    album: album,
    label: label,
    year: year,
    reviewer: reviewer,
    review_date: review_date,
    score: score
  }
end
 # puts JSON.pretty_generate(albums_best)

CSV.open("albums_best.csv", "w") do |csv|
  JSON.parse(JSON[albums_best]).each do |hash|
    csv << hash.values
  end
end

puts "///////....4 BEST TRACKS.....////////"
see_tracks = best[1].click
track_links = see_tracks.links_with(href: %r{^/reviews/tracks/\w+})
track_links = track_links.reject do |link|
  parent_classes = link.node.parent['class'].split
  parent_classes.any? { |p| p == 'track-collection-item'}
end
track_links = track_links[2..5]
# puts track_links

tracks_best = track_links.map do |link|
  tracks_best= link.click

  artist = tracks_best.search('.artist-links').text
  track = tracks_best.search('.track-details .title').text
  label = tracks_best.search('.label .labels-list__item').text
  year = tracks_best.search('.label .year').text.to_i
  reviewer = tracks_best.search('.authors-detail__display-name').text
  review_date = Time.parse(tracks_best.search('.pub-date')[0]['title'])
  genre = tracks_best.search('.genre-list__link').text
  {
    artist: artist,
    track: track,
    label: label,
    year: year,
    reviewer: reviewer,
    review_date: review_date,
    genre: genre
  }
end
# puts JSON.pretty_generate(tracks_best)

CSV.open("tracks_best.csv", "w") do |csv|
  JSON.parse(JSON[tracks_best]).each do |hash|
    csv << hash.values
  end
end

puts "///////....4 BEST REISSUE.....////////"
see_reissue = best[2].click
reissue_links = see_reissue.links_with(href: %r{^/reviews/albums/\w+})
reissue_links = reissue_links[0...4]
# puts reissue_links

reissue_best = reissue_links.map do |link|
  reissue_best= link.click

  artist = reissue_best.search('.artist-links').text
  album = reissue_best.search('.single-album-tombstone__review-title').text
  label, year = reissue_best.search('.single-album-tombstone__meta').text.split('•').map(&:strip)
  reviewer = reissue_best.search('.authors-detail__display-name').text
  review_date = Time.parse(reissue_best.search('.pub-date')[0]['title'])
  score = reissue_best.search('.score').text.to_f
  {
    artist: artist,
    album: album,
    label: label,
    year: year,
    reviewer: reviewer,
    review_date: review_date,
    score: score
  }
end
# puts JSON.pretty_generate(reissue_best)

CSV.open("reissue_best.csv", "w") do |csv|
  JSON.parse(JSON[reissue_best]).each do |hash|
    csv << hash.values
  end
end