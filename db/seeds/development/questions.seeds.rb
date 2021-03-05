after 'development:categories' do
  puts 'Creating questions'
  Category.all.each do |category|
    rand(10).times do
      category.questions.create!(
          title: Faker::Lorem.sentence,
          content: Faker::Lorem.paragraphs(3).map{|p| "<p>#{p}</p>"}.join,
          answer: Faker::Lorem.paragraphs(2).map{|p| "<p>#{p}</p>"}.join,
          user_id: User.all.sample.id
      )
      putc '.'
    end
  end
end
