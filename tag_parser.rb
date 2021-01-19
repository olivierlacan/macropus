require "bundler"
Bundler.require

require "json"
require "csv"
require "uri"
require "fileutils"

file = File.read("tags.json")
payload = JSON.parse(file)
tags = payload["data"]["tagsBySearch"]["edges"].map { _1["node"] }

activities = tags.filter { _1["tagType"] == "ACTIVITY" }
categories = tags.filter { _1["tagType"] == "CATEGORY" }

def filename(url)
  return false if url.nil?

  uri = URI.parse(url)
  filename = File.basename(uri.path)
end

def download_image(url, save_path)
  return if url.nil?

  uri = URI.parse(url)
  puts "Downloading #{uri}..."
  tempfile = Down.download(uri)
  FileUtils.mv(tempfile.path, "tags/#{save_path}/#{tempfile.original_filename}")
rescue => error
  puts "Error for #{uri}: #{error.message}"
end

CSV.open("tag_activities.csv", "w", headers: true) do |csv|
  csv << ["id", "name", "image_url", "created_at"]

  activities.sort_by{ _1["createdAt"] }.each do |tag|
    image_url = tag["imageAsset"] && tag["imageAsset"]["url"]
    download_image(image_url, "activities") unless File.exist?("tags/activities/#{filename(image_url)}")

    csv << [tag["id"], tag["name"], image_url, tag["createdAt"]]
  end
end

CSV.open("tag_categories.csv", "w", headers: true) do |csv|
  csv << ["id", "name", "image_url", "created_at"]

  categories.sort_by{ _1["createdAt"] }.each do |tag|
    image_url = tag["imageAsset"] && tag["imageAsset"]["url"]
    download_image(image_url, "categories") unless File.exist?("tags/categories/#{filename(image_url)}")

    csv << [tag["id"], tag["name"], image_url, tag["createdAt"]]
  end
end
