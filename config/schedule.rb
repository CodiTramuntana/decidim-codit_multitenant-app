# frozen_string_literal: true

env :PATH, ENV.fetch("PATH", nil)

every 1.day, at: "5:00 am" do
  rake "decidim:metrics:all"
end

every 1.day, at: "6:00 am" do
  rake "decidim:open_data:export"
end

every :sunday, at: "4:00 am" do
  rake "decidim:delete_download_your_data_files"
end
