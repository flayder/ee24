# encoding: utf-8
# TODO: options[:message] инкапсулированы в значении uniqueness,
# надо извлечь данное значение для корректной работы данного валидатора
# пока options[:message] == nil
class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A(|(([A-Za-zА-Яа-я0-9]+_+)|([A-Za-zА-Яа-я0-9]+\-+)|([A-Za-zА-Яа-я0-9]+\.+)|([A-Za-zА-Яа-я0-9]+\++))*[A-Za-zА-Яа-я0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-ZА-Яа-я]{2,6})\z/i
      record.errors[attribute] << (options[:message] || "имеет неправильный формат")
    end
  end
end
