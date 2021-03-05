# encoding : utf-8
class Ckeditor::Picture < Ckeditor::Asset
  mount_uploader :data, CkeditorPictureUploader, :mount_on => :data_file_name

  validate :file_size

  def file_size
    if data.file.size > 300.kilobytes.to_i && User.find(assetable_id).try(:user_type) == 'user'
      errors.add('Размер файла:', "Вы не можете загружать файлы размером больше чем 300Kb")
    end
  end

	def url_content
	  url(:content)
  end

end
