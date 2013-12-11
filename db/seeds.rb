# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

tomze = Artist.find_by_slug!("tom-ze")

Feature.delete_all
Feature.create!([
  featurable: tomze.sound_checks.first,
  enabled: true,
  description_override: <<-_.dedent
    O músico e compositor Tom Zé inaugura a nova programação do Instrumental Sesc Brasil, que estreia a série de documentários Passagem de Som e o novo site, além de oferecer o melhor da música instrumental.

    Antes de cada show, o Sesc TV exibe o Passagem de Som que traz um passeio com entrevistas e curiosidades com os músicos que passam pelo projeto. Já o novo site, conta com um acervo e um playlist com mais de 2 mil músicas e 300 artistas que já passaram pelo palco de um dos maiores projetos da música instrumental brasileira
  _
])
