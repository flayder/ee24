puts 'Creating categories'
%w(Образование Иммиграция Развлечения Недвижимость Закон Еда Бизнес Авто).each do |category|
  Category.find_or_create_by_name(category,
    remote_logo_url: "https://lorempixel.com/110/110/#{%w(abstract animals business cats city food nightlife fashion people nature sports technics transport).sample}",
    description: Faker::Lorem.sentence(33)
  )
  putc '.'
end
puts ''
