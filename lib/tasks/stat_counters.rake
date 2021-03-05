namespace :stat_counters do
  task create: :environment do
    (0..19).map { |n| Date.today - n.days }.each do |date|
      StatCounter.generate date
    end
  end

  task generate_todays: :environment do
    StatCounter.generate Date.today
  end
end