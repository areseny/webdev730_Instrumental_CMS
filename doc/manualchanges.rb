artist = Artist.create!({
  name: "Wilson das Neves",
  slug: "wilson-das-neves",
  sort_name: "Wilson das Neves",
  first_letter: "w",
  description: %{“O Som quente é das Neves” traz o calor e talento do baterista, percussionista e cantor que lançou em 1976, o antológico LP que dá nome ao show. O músico nos brinda com uma fusão de ritmos brasileiros, todos mais ou menos "sambeados" e com o intenso uso de percussão e arranjos que refletem na concepção musical de Wilson Das Neves. Soul music, jazz, ritmos cubanos e candomblé refletem no talento de todos os músicos e arranjadores participantes, um time de responsa, que gravavam os sucessos da época na década de 1970.

Com Wilson das Neves (bateria), João Rebouças (arranjos e teclados), André Tandeta (bateria), José Carlos (guitarra), Zé Luiz (baixo), Armando Marçal (percussão), Zero (percussão), Zé Trambique (percussão), Zé Bigorna (sax e flauta), Marcelo Martins (sax), Jessé Sadoc (trompete), Altair Martins (trompete) e Serginho do Trombone (trombone).}
})
Event.create!(type: "Show", artist: artist, description: artist.description, date: "2014-02-17", slug: "show-em-17-fevereiro-2014")

artist.banner = File.open("/Users/potis/Dropbox/Instrumental/IMAGENS/Wilson das Neves/thumbnail.jpg")
artist.thumbnail = File.open("/Users/potis/Dropbox/Instrumental/IMAGENS/Wilson das Neves/thumbnail.jpg")
artist.save

# artist["banner"] = "xxx"
# artist["thumbnail"] = "xxx"
# artist.save
