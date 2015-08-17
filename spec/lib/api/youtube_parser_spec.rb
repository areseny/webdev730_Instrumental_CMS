require 'api/youtube_parser'
require 'dedent'

describe YoutubeParser do
  def parse(attributes)
    YoutubeParser.new(attributes)
  end

  it "does not match a title that does not contain the site's name in the end" do
    parser = parse(title: "John Lennon | Imagine (John Lennon) | Some Another program")
    parser.title_match.should be_nil
  end

  it "detects a song by the video's title" do
    parser = parse(title: "Rick Udler | Dia de Sol (João da Silva) | Instrumental Sesc Brasil")
    parser.song_match.should be_true
    parser.artist_name.should == "Rick Udler"
    parser.song_title.should == "Dia de Sol"
    parser.composer_name.should == "João da Silva"
  end

  it "detects an interview by the video's title" do
    parser = parse(title: "Janis Joplin | Entrevista | Instrumental Sesc Brasil")
    parser.interview_match.should be_true
    parser.artist_name.should == "Janis Joplin"
  end

  it "detects a video chat by the video's title" do
    parser = parse(title: "Jimmy Hendrix | Bate-papo | Instrumental Sesc Brasil")
    parser.video_chat_match.should be_true
    parser.artist_name.should == "Jimmy Hendrix"
  end

  it "detects a tv show by the video's title" do
    parser = parse(title: "Black Sabbath | Programa Instrumental Sesc Brasil")
    parser.tv_show_match.should be_true
    parser.artist_name.should == "Black Sabbath"
  end

  it "detects a sound check by the video's title" do
    parser = parse(title: "Jim Morrisson | Programa Passagem de Som")
    parser.sound_check_match.should be_true
    parser.artist_name.should == "Jim Morrisson"
  end

  it "detects a legacy tv show by the video's title" do
    parser = parse(title: "Black Sabbath | Programa Instrumental Sesc Brasil | Memória")
    parser.legacy_tv_show_match.should be_true
    parser.artist_name.should == "Black Sabbath"
  end

  it "detects the text before any data marker as the event's description" do
    parser = parse description: <<-_.dedent
      Descrição do evento

      Dados seguem:
      foo bar baz
    _
    parser.description.should == "Descrição do evento\n"
  end

  it "detects the full description text as the event's description if no marker is found" do
    parser = parse description: <<-_.dedent
      Descrição do evento

      Foo Bar Baz
    _
    parser.description.should == "Descrição do evento\n\nFoo Bar Baz"
  end

  it "detects the factsheet information" do
    parser = parse description: <<-_.dedent
      Descrição do evento

      Ficha técnica:
      Foo
      Bar?

      Barbaz!!

      ---

      Some other text
    _
    parser.factsheet.should == "Foo\nBar?\n\nBarbaz!!\n"
  end

  context 'band members' do
    it "detects band member information" do
      parser = parse description: <<-_.dedent
        Descrição do evento

        Formação:
        João - Baixo
        Maria - Bateria e Bumbo
        Pedro - Guitarra, violão e flauta
        Foo bar baz
      _
      parser.band_members.should == [
        ["João", ["baixo"]],
        ["Maria", ["bateria", "bumbo"]],
        ["Pedro", ["guitarra", "violão", "flauta"]]
      ]
    end

    it "ignores punctuation in band member information" do
      parser = parse description: <<-_.dedent
        Descrição do evento

        Formação:
        João - Baixo;
        Maria - Bateria e Bumbo
        Pedro - Guitarra, violão; e flauta.
        Foo bar baz
      _
      parser.band_members.should == [
        ["João", ["baixo"]],
        ["Maria", ["bateria", "bumbo"]],
        ["Pedro", ["guitarra", "violão", "flauta"]]
      ]
    end

    it "orders the parsed band members" do
      parser = parse description: <<-_.dedent
        Descrição do evento

        Formação:
        João - Baixo
        Pedro - Guitarra, violão e flauta
        Maria - Bateria e Bumbo
        Foo bar baz
      _
      parser.band_members.should == [
        ["João", ["baixo"]],
        ["Maria", ["bateria", "bumbo"]],
        ["Pedro", ["guitarra", "violão", "flauta"]]
      ]
    end

    it 'removes duplicated instruments' do
      parser = parse description: <<-_.dedent
        Descrição do evento

        Formação:
        Almir - violão, bandolim e violão
        João - viola caipira e violão
        Foo bar baz
      _
      parser.band_members.should == [
        ['Almir', ['violão', 'bandolim']],
        ['João', ['viola caipira', 'violão']],
      ]
    end
  end

  it "detects the event's date in the video's description" do
    parser = parse(description: "Arranca-rabo que ocorreu no Teatro da Esquina dia 28/01/2013\n")
    parser.date.should == Date.new(2013, 1, 28)
  end

  it "detects the event's date with extra spaces" do
    parser = parse(description: "Arranca-rabo que ocorreu no Teatro da Esquina dia 28/01/2013 \n")
    parser.date.should == Date.new(2013, 1, 28)
  end

  it "won't detect invalid dates" do
    parser = parse(description: "Show que ocorreu no Teatro da Esquina dia 28/40/2013")
    parser.date.should be_nil
  end

  it "detects timecodes in the video's description" do
    parser = parse description: <<-_.dedent
      01:30 - Pergunta 1
      02:53 - Pergunta 2
      03:10 - Pergunta 3

      Foo bar baz
    _
    parser.timecodes.should == [
      [90, "Pergunta 1"],
      [173, "Pergunta 2"],
      [190, "Pergunta 3"]
    ]
  end

  it "orders the parsed timecodes" do
    parser = parse description: <<-_.dedent
      02:53 - Pergunta 1
      01:30 - Pergunta 2
      03:10 - Pergunta 3

      Foo bar baz
    _
    parser.timecodes.should == [
      [90,  "Pergunta 2"],
      [173, "Pergunta 1"],
      [190, "Pergunta 3"]
    ]
  end

  it "detects the song's genre in the video's description" do
    parser = parse description: <<-_.dedent
      Foo bar

      Gênero: Rock

      Baz
    _
    parser.genres.should == ["rock"]
  end

  it "detects more than one genres in the video's description" do
    parser = parse description: <<-_.dedent
      Foo bar

      Gêneros: Rock, Samba, Baião

      Baz
    _
    parser.genres.should == ["rock", "samba", "baião"]
  end

  it "ignores punctuation when detecting genres in the video's description" do
    parser = parse description: <<-_.dedent
      Foo bar

      Gêneros: Rock, Samba, Baião; Bolero. e ; Bossa Nova.

      Baz
    _
    parser.genres.should == ["rock", "samba", "baião", "bolero", "bossa nova"]
  end

  it "skips empty genres" do
    parser = parse description: <<-_.dedent
      Foo bar

      Gênero:

      Some other sentence below that should not be interpreted as the genre

      Yet another sentence that should also not be interpreted
    _
    parser.genres.should == []
  end

end
