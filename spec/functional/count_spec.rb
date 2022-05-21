require 'spec_helper'

#######################################################
# DO NOT CHANGE THIS FILE - WRITE YOUR OWN SPEC FILES #
#######################################################
RSpec.describe 'App Functional Test' do
  describe 'dollar and percent formats sorted by first_name' do
    dollar_format_count = rand(1..200)
    percent_format_count = rand(1..200)
    o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten

    dollar_format = "city $ birthdate $ last_name $ first_name \n"
    percent_format = "first_name % city % birthdate \n"

    for i in 1..dollar_format_count do 
      dollar_format << "#{(1..5).map { o[rand(o.length)] }.join} $ #{rand(1..28)}-#{rand(1..12)}-#{rand(1900..2020)} $ #{(1..5).map { o[rand(o.length)] }.join} $ #{(1..5).map { o[rand(o.length)] }.join}\n"
    end
    for i in 1..percent_format_count do 
      percent_format << "#{(1..5).map { o[rand(o.length)] }.join} % #{(1..5).map { o[rand(o.length)] }.join} % #{rand(1900..2020)}-#{rand(1..12)}-#{rand(1..27)}\n"
    end


    let(:params) do
      {
        dollar_format: dollar_format,
        percent_format: percent_format,
        order: :first_name,
      }
    end
    let(:people_controller) { PeopleController.new(params) }

    it 'parses input files and outputs normalized data and validates count' do
      normalized_people = people_controller.normalize
      expect(normalized_people.count).to eq dollar_format_count + percent_format_count
    end
  end
end
