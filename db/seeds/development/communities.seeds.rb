after 'development:categories' do
  puts 'Creating communities'
  Category.all.each do |category|
    puts "Creating communities for category #{category.name}"
    (5..15).to_a.sample.times do
      category.communities.create!(
          name: Faker::Commerce.department,
          description: Faker::Lorem.sentence(33),
          remote_logo_url: "https://lorempixel.com/110/110/#{%w(abstract animals business cats city food nightlife fashion people nature sports technics transport).sample}",
          rules: Faker::Lorem.paragraphs(5).map{|p| "<p>#{p}</p>"}.join,
          user_id: User.all.sample.id
      )
      putc '.'
    end
    puts ''
  end
end
