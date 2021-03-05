# encoding:utf-8
namespace :users do

  task :generate_new_gender => :environment do
    User.where(:gender => nil).update_all(:new_gender => nil)
    User.where(:gender => 'male').update_all(:new_gender => true)
    User.where(:gender => 'female').update_all(:new_gender => false)
    User.where(:gender => 'Мужской').update_all(:new_gender => true)
    User.where(:gender => 'Женский').update_all(:new_gender => false)
    User.where(:gender => 'Не определился').update_all(:new_gender => nil)
  end

  task :list_duplicates => :environment do
    associations = [:has_one, :has_many].inject([]) do |names, assoc|
      names += User.reflect_on_all_associations(assoc).map(&:name)
      names
    end

    duplicate_emails = User.group(:email).count.select { |k, v| v > 1 }.keys

    duplicate_emails.each do |email|
      users = User.where(:email => email)
      current_user = users.order('updated_at DESC').first

      users.each do |user|
        associations.each do |association|
          next unless user.send(association)
          user.send(association).update_all :user_id => current_user.id
        end        
      end

      users.keep_if { |u| u.id != current_user.id }
      users.map(&:destroy)
    end
  end
end