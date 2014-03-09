require "spec_helper"

describe "Database Schema" do
  before do
    @lennon = Artist.create!(name: "John Lennon", slug: 'john-lennon',
                             sort_name: "John Lennon", first_letter: 'j',
                             description: "A Beatle")
    @wimbledom = @lennon.shows.create(date: "2006-05-09",
                                      description: "Show at Wimbledom Stadium",
                                      slug: "show-em-09-maio-2006")
    @letitbe = @wimbledom.songs.create(title: "Let it Be",
                                       composer: "Paul McCartney")
    @guitar = Instrument.create!(name: "Guitar")
    @vocals = Instrument.create!(name: "Vocals")
    @drums = Instrument.create!(name: "Drums")
    @bass = Instrument.create!(name: "Bass")
    @flute = Instrument.create!(name: "Flute")
    @rock = Genre.create!(name: "Rock")
    @salsa = Genre.create!(name: "Salsa")
    @classic_rock = Genre.create!(name: "Classic Rock")
    @letitbe.band_members.create!(artist_name: "George Harrisson",
                                  instruments: [@guitar, @vocals])
    @letitbe.band_members.create!(artist_name: "Paul McCartney",
                                  instruments: [@bass, @vocals])
    @letitbe.band_members.create!(artist_name: "Ringo Starr",
                                  instruments: [@drums])
    @lennon.instruments << @vocals
    @lennon.instruments << @guitar
    @lennon.genres << @rock
    @lennon.genres << @classic_rock
    @letitbe.genres << @rock
    @letitbe.genres << @classic_rock
  end

  specify "show associations" do
    @lennon.shows.should include @wimbledom
    @wimbledom.artist.should == @lennon
  end

  specify "songs associations" do
    @lennon.songs.should include @letitbe
    @wimbledom.songs.should include @letitbe
    @letitbe.playlistable.should == @wimbledom
    @letitbe.artist.should == @lennon
  end

  specify "genres associations" do
    @lennon.genres.should include @rock, @classic_rock
    @lennon.genres.should_not include @salsa
    @wimbledom.genres.should include @rock, @classic_rock
    @wimbledom.genres.should_not include @salsa
    @letitbe.genres.should include @rock, @classic_rock
    @letitbe.genres.should_not include @salsa
    @rock.songs.should include @letitbe
    @classic_rock.songs.should include @letitbe
    @salsa.songs.should be_empty
  end

  specify "instruments associations" do
    @lennon.instruments.should =~ [@guitar, @vocals]
    @wimbledom.instruments.should =~ [@guitar, @vocals, @drums, @bass]
    @letitbe.instruments.should =~ [@guitar, @vocals, @drums, @bass]
  end

end
