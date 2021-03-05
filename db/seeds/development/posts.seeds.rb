after 'development:communities' do
  puts 'Creating posts for communities'
  Community.all.each do |community|
    puts "Creating posts for community #{community.name}"
    (5..10).to_a.sample.times do
      community.posts.create!(
          title: Faker::Lorem.sentence,
          content: Faker::Lorem.paragraphs(rand(10)).map{|p| "<p>#{p}</p>"}.join,
          user_id: User.all.sample.id
      )
      putc '.'
    end
    puts ''
  end
end
