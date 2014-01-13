class UpdateFeatures < ActiveRecord::Migration
  def up
    drop_table :features
    create_table :features do |t|
      t.string  :title,           null: false
      t.string  :url,             null: false
      t.integer :priority,        null: false, default: 0
      t.text    :description,     null: false
      t.string  :banner,          null: false
      t.integer :banner_width,    null: false
      t.integer :banner_height,   null: false
      t.boolean :enabled,         null: false, default: false
    end
    add_index :features, [:enabled, :priority]
    Feature.create!({
      title: "Tom Zé",
      enabled: true,
      url: "/artistas/tom-ze/programa-passagem-de-som-em-06-janeiro-2013",
      priority: 10,
      description: <<-_.dedent
        ## 06/01/2013

        O músico e compositor Tom Zé inaugura a nova programação do Instrumental Sesc Brasil, que estreia a série de documentários Passagem de Som e o novo site, além de oferecer o melhor da música instrumental.

        Antes de cada show, o Sesc TV exibe o Passagem de Som que traz um passeio com entrevistas e curiosidades com os músicos que passam pelo projeto. Já o novo site, conta com um acervo e um playlist com mais de 2 mil músicas e 300 artistas que já passaram pelo palco de um dos maiores projetos da música instrumental brasileira
      _
    }) do |tomze|
      tomze[:banner] = "banner-3d98f48f909c0afbee71ca9834acac8e.jpg"
      tomze.banner_width = 900
      tomze.banner_height = 500
    end
    Feature.create!({
      title: "André Geraissati",
      enabled: true,
      url: "http://www.livestream.com/instrumentalsesc",
      priority: 1,
      description: <<-_.dedent
        ## 06/01 - às 19h ao vivo. Clique para assistir

        A trajetória de André Geraissati é uma das mais emblemáticas da música instrumental brasileira.

        Embora envolvido com música desde os Anos 60, Geraissati surgiu para o grande público no final dos Anos 70, com o Grupo D’Alma e desde a década de 1980 vem trabalhando em carreira solo, dirigindo e produzindo diversos artistas como Egberto Gismonti, Hermeto Pascoal e Zimbo Trio.
      _
    }) do |geraissati|
      geraissati[:banner] = "banner-2690a479029dea958dc8f8197b71a445.jpg"
      geraissati.banner_width = 781
      geraissati.banner_height = 500
    end
  end
  def down
    drop_table :features
    create_table :features do |t|
      t.belongs_to :featurable, null: false, polymorphic: true
      t.text       :description_override
      t.boolean    :enabled, null: false, default: false
      t.timestamps
    end
    add_index :features, :enabled
  end
end
