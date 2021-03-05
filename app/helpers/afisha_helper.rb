# encoding : utf-8
module AfishaHelper
  def fancy_date(event)
    if event.start_date.to_date <= Date.today && event.finish_date.to_date >= Date.today
      "Сегодня, #{Russian::strftime(Date.today, "%d %B")}"
    elsif event.start_date.to_date == Date.tomorrow
      "Завтра, #{Russian::strftime(Date.tomorrow, "%d %B")}"
    else 
      "#{Russian::strftime(event.start_date, "%A, %d %B")}"
    end
  end

  def fancy_archive_search_date(date)
    if params[:year] && !params[:month] && !params[:day]
      "#{Russian::strftime(date, "%Y")}"
    elsif params[:year] && params[:month] && !params[:day]
      "#{Russian::strftime(date, "%B")}"
    elsif params[:year] && params[:month] && params[:day]
      if date == Date.today
        "Сегодня, #{Russian::strftime(Date.today, "%d %B")}"
      elsif date == Date.tomorrow
        "Завтра, #{Russian::strftime(Date.tomorrow, "%d %B")}"
      else
        "#{Russian::strftime(date, "%A, %d %B")}"
      end
    end
  end
end
