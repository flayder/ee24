namespace :liquid do
  task inspect_views: :environment do
    exts = []
    Dir.glob(File.join(Rails.root, 'app/views/**/*.*')).each do |file|
      exts << file if File.extname(file).in?(['.erb', '.haml'])
    end

    # TODO for each view file (partial, template) there will be liquid analogue
    # So liquid template will be loaded by view file path (relative to Rails.root dir)
    exts.each { |e| puts e }
  end
end
