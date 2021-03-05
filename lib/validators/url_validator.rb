# encoding: utf-8
# TODO: options[:message] инкапсулированы в значении uniqueness,
# надо извлечь данное значение для корректной работы данного валидатора
# пока options[:message] == nil
class UrlValidator < ActiveModel::EachValidator
  REGEXP = /^(http|https):\/\/[a-zа-я0-9]+([\-\.]{1}[a-zа-я0-9]+)*\.[a-zа-я]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix

  def validate_each(record, attribute, value)
    unless value =~ REGEXP
      record.errors[attribute] << (options[:message] || "имеет неправильный формат")
    end
  end
end
