class String
  def squash
    blank? ? nil : self
  end
end

class NilClass
  def squash
    nil
  end
end
