class PeopleController
  def initialize(params)
    @params = params
  end

  def normalize
    PeopleManager.new(params).normalize!
  end

  private

  attr_reader :params
end

############################################################################################################

class PeopleManager
  require 'csv'

  def initialize(params)
    self.params = params
    self.normalized_data = []
  end

  # @return [Array] Return the formatted data
  def normalize!
    extract(data: params[:dollar_format], separator: '$')
    extract(data: params[:percent_format], separator: '%')
    normalized_data.sort
  end

  private

  attr_accessor :params, :normalized_data

  # Extract the formatted data
  def extract(data:, separator:)
    CSV.parse(data, col_sep: separator, headers: true, header_converters: lambda { |f| f.strip }) do |row|

      details = [row['first_name'].strip, city_name(row['city'].strip), date(row['birthdate'], separator)]
      normalized_data << details.join(', ')
    end
  end

  # @return [Date] Formatted value of the birthdate
  def date(birthdate, separator)
    if separator == '$'.freeze
      birthdate = Date.strptime(birthdate.strip, '%d-%m-%Y')
    else
      birthdate = Date.strptime(birthdate.strip, '%Y-%m-%d')
    end

    birthdate.strftime('%-m/%-d/%Y')
  end

  # @return [String] City Name
  def city_name(city)
    city_codes[city.to_sym] || city
  end

  # @return [Hash] map of city code with city name
  def city_codes
    {
      NYC: 'New York City',
      LA: 'Los Angeles'
    }
  end
end
