# encoding : utf-8
module NumWorder
  #сумма прописью - метод перенесён из плагина rutils
  #gender   = 1 - мужской, = 2 - женский, = 3 - средний
  def num_in_words(amount, gender = 1)
    into = ''
    tmp_val ||= 0
    return "ноль " if amount == 0
    tmp_val = amount
    # единицы
    into, tmp_val = sum_string_fn(into, tmp_val, gender)
    return into if tmp_val == 0
    # тысячи
    into, tmp_val = sum_string_fn(into, tmp_val, 2, "тысяча", "тысячи", "тысяч")
    return into if tmp_val == 0
    # миллионы
    into, tmp_val = sum_string_fn(into, tmp_val, 1, "миллион", "миллиона", "миллионов")
    return into if tmp_val == 0
    # миллиардов
    into, tmp_val = sum_string_fn(into, tmp_val, 1, "миллиард", "миллиарда", "миллиардов")
    return into
  end

  def sum_string_fn(into, tmp_val, gender, one_item='', two_items='', five_items='')
    rest, rest1, end_word, ones, tens, hundreds = [nil]*6
    #
    rest = tmp_val % 1000
    tmp_val = tmp_val / 1000
    if rest == 0
      # последние три знака нулевые
      into = five_items + " " if into == ""
      return [into, tmp_val]
    end
    #
    # начинаем подсчет с Rest
    end_word = five_items
    # сотни
    hundreds = case rest / 100
    when 0 then ""
    when 1 then "сто "
    when 2 then "двести "
    when 3 then "триста "
    when 4 then "четыреста "
    when 5 then "пятьсот "
    when 6 then "шестьсот "
    when 7 then "семьсот "
    when 8 then "восемьсот "
    when 9 then "девятьсот "
    end

    # десятки
    rest = rest % 100
    rest1 = rest / 10
    ones = ""
    tens = case rest1
    when 0 then ""
    when 1 # особый случай
      case rest
      when 10 then "десять "
      when 11 then "одиннадцать "
      when 12 then "двенадцать "
      when 13 then "тринадцать "
      when 14 then "четырнадцать "
      when 15 then "пятнадцать "
      when 16 then "шестнадцать "
      when 17 then "семнадцать "
      when 18 then "восемнадцать "
      when 19 then "девятнадцать "
      end
    when 2 then "двадцать "
    when 3 then "тридцать "
    when 4 then "сорок "
    when 5 then "пятьдесят "
    when 6 then "шестьдесят "
    when 7 then "семьдесят "
    when 8 then "восемьдесят "
    when 9 then "девяносто "
    end
    #
    if rest1 < 1 or rest1 > 1 # единицы
      case rest % 10
      when 1
        ones = case gender
        when 1 then "один "
        when 2 then "одна "
        when 3 then "одно "
        end
        end_word = one_item
      when 2
        if gender == 2
          ones = "две "
        else
          ones = "два "
        end
        end_word = two_items
      when 3
        ones = "три " if end_word = two_items # TODO - WTF?
      when 4
        ones = "четыре " if end_word = two_items  # TODO - WTF?
      when 5
        ones = "пять "
      when 6
        ones = "шесть "
      when 7
        ones = "семь "
      when 8
        ones = "восемь "
      when 9
        ones = "девять "
      end
    end

    # сборка строки
    plural = [hundreds, tens, ones, end_word,  " ",  into].join.strip
    return [plural, tmp_val]
  end
end
