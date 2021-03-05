# encoding: utf-8
# TODO: options[:message] инкапсулированы в значении uniqueness,
# надо извлечь данное значение для корректной работы данного валидатора
# пока options[:message] == nil
class UrlOrPathValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /^((http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?|\/.{0,})$/ix
      record.errors[attribute] << (options[:message] || "имеет неправильный формат")
    end
  end
end
