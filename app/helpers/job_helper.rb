# encoding : utf-8
module JobHelper
  # REFACTOR very very very very very very very bad naming
  def opposite(type)
    type == 'resume' ? 'vacancy' : 'resume'
  end

  #определение типа объявления (в связи с наличием общего списка) - да, не очень :-/
  def job_type(job_item)
    if params[:type].present?
      params[:type]
    elsif(job_item.respond_to?('job_type'))
      job_item.job_type
    else
      'vacancy'
    end
  end

  def job_form_partial(type, params)
    type = 'vacancy' unless type.in?(['vacancy', 'resume'])
    params[:partial] = "/job/#{type}/form"
    render(params)
  end

  #формат времени для фида яндекса
  def yandex_time_format(time = Time.now)
    time.strftime('%Y-%m-%d %X GMT+') + (time.gmt_offset/(60*60)).to_s
  end

  def doc_rubrics
    doc_global_rubric = @site.doc_global_rubrics.find_by_link('job')
    doc_global_rubric.present? ? doc_global_rubric.doc_rubrics : []
  end
end
