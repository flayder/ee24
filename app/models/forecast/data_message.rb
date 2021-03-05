class Forecast::DataMessage
  KEYS_INDEXES = {
    0 => 'cloudiness',
    1 => 'precipitation_rate',
    2 => 'precipitation_type'
  }

  def message(icon_code)
    generate_message icon_code[/\d+/].split('').map(&:to_i)
  end

  private
  def index_message(index)
    I18n.translate("forecast_data_message.#{KEYS_INDEXES[index]}")
  end

  def generate_message(symbols)
    body = [0, 1].map do |index|
      index_message(index)[symbols[index]]
    end.join(', ')

    body += index_message(2)[symbols[2]] unless symbols[1] == 0
    body
  end
end
