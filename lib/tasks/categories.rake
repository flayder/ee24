include Faker

namespace :categories do

  task reset:  :environment do
    Category.destroy_all
  end

  task create: :environment do
    rand(10).times do
      category = Category.new(
          name: Lorem.word,
          description: Lorem.sentence(10)
      )
      if category.save
        p '---------------------------'
        p "CATEGORY CREATED: #{category.name}"
      end

      rand(10).times do
        community = Community.new(
            name: Lorem.word,
            description: Lorem.sentence(10),
            rules: Lorem.sentence(10),
            user_id: User.last.id,
            category_id: category.id
        )
        if community.save
          p "- community: #{community.name}"
        end
      end

      rand(10).times do
        category.questions.create!(
            title: Lorem.sentence,
            content: Lorem.paragraphs(3).map{|p| "<p>#{p}</p>"}.join,
            answer: Lorem.paragraphs(2).map{|p| "<p>#{p}</p>"}.join,
            user_id: User.all.sample.id
        )
        putc '.'
      end
    end
  end

end
