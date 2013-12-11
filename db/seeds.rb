# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

tomze = Artist.find_by_slug!("tom-ze")

Feature.delete_all
Feature.create!({
  featurable: tomze.sound_checks.first,
  enabled: true,
  description_override: <<-_.dedent
    O músico e compositor Tom Zé inaugura a nova programação do Instrumental Sesc Brasil, que estreia a série de documentários Passagem de Som e o novo site, além de oferecer o melhor da música instrumental.

    Antes de cada show, o Sesc TV exibe o Passagem de Som que traz um passeio com entrevistas e curiosidades com os músicos que passam pelo projeto. Já o novo site, conta com um acervo e um playlist com mais de 2 mil músicas e 300 artistas que já passaram pelo palco de um dos maiores projetos da música instrumental brasileira
  _
})

TvScheduleItem.delete_all
TvScheduleItem.create!([
  { starts_at: "2013-12-11 10:00",
    description: "Instrumental SESC Brasil - Blues Etílicos (Livre)" },
  { starts_at: "2013-12-11 17:00",
    description: "Instrumental SESC Brasil - Duofel (Livre)" },
  { starts_at: "2013-12-12 18:00",
    description: "Instrumental SESC Brasil - Swami Jr. (Livre)" },
  { starts_at: "2013-12-13 00:00",
    description: "Instrumental SESC Brasil - Swami Jr. (Livre)" },
  { starts_at: "2013-12-13 05:00",
    description: "Instrumental SESC Brasil - Blues Etílicos (Livre)" },
  { starts_at: "2013-12-13 08:00",
    description: "Instrumental SESC Brasil - Swami Jr. (Livre)" },
  { starts_at: "2013-12-13 13:00",
    description: "Instrumental SESC Brasil - Duofel (Livre)" },
  { starts_at: "2013-12-14 17:00",
    description: "Instrumental SESC Brasil - Blues Etílicos (Livre)" },
  { starts_at: "2013-12-15 01:05",
    description: "nstrumental SESC Brasil - Blues Etílicos (Livre)" },
  { starts_at: "2013-12-15 21:30",
    description: "Instrumental SESC Brasil - Tom Zé (Livre)" },
  { starts_at: "2013-12-16 06:00",
    description: "Instrumental SESC Brasil - Duofel (Livre)" },
  { starts_at: "2013-12-16 17:00",
    description: "Instrumental SESC Brasil - Tom Zé (Livre)" },
  { starts_at: "2013-12-17 05:00",
    description: "Instrumental SESC Brasil - Swami Jr. (Livre)" },
  { starts_at: "2013-12-17 10:00",
    description: "Instrumental SESC Brasil - Tom Zé (Livre)" },
  { starts_at: "2013-12-18 11:00",
    description: "Passagem de Som - Tom Zé (12 anos)" },
  { starts_at: "2013-12-18 11:30",
    description: "Instrumental SESC Brasil - Tom Zé (Livre)" },
  { starts_at: "2013-12-18 17:00",
    description: "Instrumental SESC Brasil - Panorama do Choro Paulista Contemporâneo (Livre)" },
  { starts_at: "2013-12-18 13:00",
    description: "Passagem de Som - Tom Zé (12 anos)" },
  { starts_at: "2013-12-19 13:30",
    description: "Instrumental SESC Brasil - Tom Zé (Livre)" },
  { starts_at: "2013-12-19 18:00",
    description: "Instrumental SESC Brasil - Choronas (Livre)" },
  { starts_at: "2013-12-20 00:00",
    description: "Instrumental SESC Brasil - Choronas (Livre)" },
  { starts_at: "2013-12-20 05:00",
    description: "Instrumental SESC Brasil - Panorama do Choro Paulista Contemporâneo (Livre)" },
  { starts_at: "2013-12-20 08:00",
    description: "Instrumental SESC Brasil - Choronas (Livre)" },
  { starts_at: "2013-12-20 13:00",
    description: "Instrumental SESC Brasil - Panorama do Choro Paulista Contemporâneo (Livre)" },
  { starts_at: "2013-12-21 14:00",
    description: "Passagem de Som - Tom Zé (12 anos)" },
  { starts_at: "2013-12-21 14:30",
    description: "Instrumental SESC Brasil - Tom Zé (Livre)" },
  { starts_at: "2013-12-21 17:00",
    description: "Instrumental SESC Brasil - Choronas (Livre)" },
  { starts_at: "2013-12-22 01:00",
    description: "Instrumental SESC Brasil - Panorama do Choro Paulista Contemporâneo (Livre)" },
  { starts_at: "2013-12-22 21:00",
    description: "Passagem de Som - Com a Corda Toda (Livre)" },
  { starts_at: "2013-12-22 21:30",
    description: "Instrumental SESC Brasil - Com a Corda Toda (Livre)" },
  { starts_at: "2013-12-23 06:00",
    description: "Instrumental SESC Brasil - Panorama do Choro Paulista Contemporâneo (Livre)" },
  { starts_at: "2013-12-23 16:30",
    description: "Passagem de Som - Com a Corda Toda (Livre)" },
  { starts_at: "2013-12-23 17:00",
    description: "Instrumental SESC Brasil - Com a Corda Toda (Livre)" },
  { starts_at: "2013-12-24 05:00",
    description: "Instrumental SESC Brasil - Choronas (Livre)" },
  { starts_at: "2013-12-24 09:30",
    description: "Passagem de Som - Com a Corda Toda (Livre)" },
  { starts_at: "2013-12-24 10:00",
    description: "Instrumental SESC Brasil - Com a Corda Toda (Livre)" },
  { starts_at: "2013-12-25 11:00",
    description: "Passagem de Som - Com a Corda Toda (Livre)" },
  { starts_at: "2013-12-25 11:30",
    description: "Instrumental SESC Brasil - Com a Corda Toda (Livre)" },
  { starts_at: "2013-12-25 17:00",
    description: "Instrumental SESC Brasil - Patavinas Jazz Club (Livre)" },
  { starts_at: "2013-12-26 13:00",
    description: "Passagem de Som - Com a Corda Toda (Livre)" },
  { starts_at: "2013-12-26 13:30",
    description: "Instrumental SESC Brasil - Com a Corda Toda (Livre)" },
  { starts_at: "2013-12-26 18:00",
    description: "Instrumental SESC Brasil - Camarones (Livre)" },
  { starts_at: "2013-12-27 00:00",
    description: "Instrumental SESC Brasil - Camarones (Livre)" },
  { starts_at: "2013-12-27 05:00",
    description: "Instrumental SESC Brasil - Patavinas Jazz Club (Livre)" },
  { starts_at: "2013-12-27 08:00",
    description: "Instrumental SESC Brasil - Camarones (Livre)" },
  { starts_at: "2013-12-27 13:00",
    description: "Instrumental SESC Brasil - Patavinas Jazz Club (Livre)" },
  { starts_at: "2013-12-28 14:30",
    description: "Instrumental SESC Brasil - Com a Corda Toda (Livre)" },
  { starts_at: "2013-12-28 17:00",
    description: "Instrumental SESC Brasil - Camarones (Livre)" },
  { starts_at: "2013-12-29 01:00",
    description: "Instrumental SESC Brasil - Patavinas Jazz Club (Livre)" },
  { starts_at: "2013-12-29 21:00",
    description: "Passagem de Som - Bandolim Elétrico (Livre)" },
  { starts_at: "2013-12-29 21:30",
    description: "Instrumental SESC Brasil - Bandolim Elétrico" },
  { starts_at: "2013-12-30 06:00",
    description: "Instrumental SESC Brasil - Patavinas Jazz Club (Livre)" },
  { starts_at: "2013-12-30 16:30",
    description: "Passagem de Som - Bandolim Elétrico (Livre)" },
  { starts_at: "2013-12-30 17:00",
    description: "Instrumental SESC Brasil - Bandolim Elétrico" },
  { starts_at: "2013-12-31 05:00",
    description: "Instrumental SESC Brasil - Camarones (Livre)" },
  { starts_at: "2013-12-31 09:30",
    description: "Passagem de Som - Bandolim Elétrico (Livre)" },
  { starts_at: "2013-12-31 10:00",
    description: "Instrumental SESC Brasil - Bandolim Elétrico" },
])
