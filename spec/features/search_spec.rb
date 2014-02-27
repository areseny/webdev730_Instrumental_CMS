require 'spec_helper'

feature "Busca" do

  scenario "Campo de busca é prenchido com o termo procurado" do
    visit root_path
    fill_in "q", with: "teste"
    click_on "Buscar"
    page.should have_css "input[name=q][value=teste]"
  end

end
