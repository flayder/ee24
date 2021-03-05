xml.instruct!
xml.source(:host => @site.domain,  :'creation-time' => yandex_time_format) do
  xml.vacancies do
    @vacancies.each do |vacancy|
      xml.vacancy do
        xml.url vacancy.url
        xml.tag! 'creation-date', yandex_time_format(vacancy.created_at)
        xml.tag! 'update-date', yandex_time_format(vacancy.updated_at)
        if vacancy.money.to_i > 0
          xml.salary "#{vacancy.money}"
          xml.currency 'руб'
        end
        vacancy.professions.each do |profession|
          xml.category do
            xml.industry vacancy.industry.title
            xml.specialization profession.title
          end
        end
        xml.tag! 'job-name', vacancy.title
        #employment
        #schedule
        if vacancy.yandex_busy.present?
          vacancy.yandex_busy.each do |key, value|
            xml.tag! key, value
          end
        end
        xml.description h(sanitize(vacancy.text, :tags => []))
        xml.addresses do
          xml.address do
            xml.location @city.title
          end
        end
        xml.company do
          xml.name vacancy.company_name
          xml.tag! 'hr-agency', false
        end
      end
    end
  end
end