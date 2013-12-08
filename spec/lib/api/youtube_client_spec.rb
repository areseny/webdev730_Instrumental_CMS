require 'api/youtube_client'
require 'support/vcr'
require 'dotenv'

Dotenv.load!

VCR.configure do |config|
  config.filter_sensitive_data('<YOUTUBE_KEY>')         { ENV['YOUTUBE_KEY']  }
  config.filter_sensitive_data('<YOUTUBE_SECRET>')      { ENV['YOUTUBE_SECRET'] }
  config.filter_sensitive_data('foobarbazrefreshtoken') { ENV['REFRESH_TOKEN'] }
end

describe YoutubeClient, vcr: true do
  let(:token)  { "foobarbazrefreshtoken" }
  let(:client) { YoutubeClient.new(token) }

  describe "#uploads" do
    it "returns a list of the videos uploaded by the user" do
      client.uploads.to_a.should == [
        { video_id: "jHnhul4iAYk",
          title: "Ferro-velho de Juqueí",
          description: "Na estrada de Riviera" },
        { video_id: "h3Mz_G8bqIg",
          title: "Estrada pra Riviera",
          description: "Viagem" },
        { video_id: "OPbNf2z2QoA",
          title: "Lila",
          description: "A gata Taliban" },
        { video_id: "7pZtpkg8eW0",
          title: "If I Fell",
          description: "Rendition of if I Fell by me & my mom" }
      ]
    end

    it "pages through the list of results" do
      # To be sure it's paging correctly, we force results_per_page = 3
      # (4 results = 2 requests)
      stub_const "YoutubeClient::ResultsPerPage", 3
      client.uploads.to_a.should have(4).items
    end
  end

  describe "#videos" do
    it "raises an exception if more than 50 ids are queried" do
      ids = 51.times.map { 1 }
      expect { client.videos(ids) }.
        to raise_error(RuntimeError, /too many videos/i)
    end

    it "returns a list of videos for the given ids" do
      client.videos(["7pZtpkg8eW0"]).to_a.should == [
        {
          video_id: "7pZtpkg8eW0",
          title: "If I Fell",
          description: "Rendition of if I Fell by me & my mom",
          thumbnails: {
            "default" => "https://i1.ytimg.com/vi/7pZtpkg8eW0/default.jpg",
            "medium" => "https://i1.ytimg.com/vi/7pZtpkg8eW0/mqdefault.jpg",
            "high" => "https://i1.ytimg.com/vi/7pZtpkg8eW0/hqdefault.jpg",
            "standard" => "https://i1.ytimg.com/vi/7pZtpkg8eW0/sddefault.jpg"
          },
          tags: ["IMG", "0868"],
          view_count: "19",
          like_count: "1",
          dislike_count: "1",
          comment_count: "1"
        }
      ]
    end
  end

end
