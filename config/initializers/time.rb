class Time
  def middle_of_day
    change(:hour => 12)
  end
  alias :midday :middle_of_day
  alias :noon :middle_of_day
  alias :at_midday :middle_of_day
  alias :at_noon :middle_of_day
  alias :at_middle_of_day :middle_of_day
end

Time::DATE_FORMATS[:short_with_year] = "%d %b %H:%M %Y"
Date::DATE_FORMATS[:for_metrika] = "%Y%m%d"
