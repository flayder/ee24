class PresentTag < Liquid::Tag
  def initialize(tag_name, variable)
     super
     @var = variable
  end

  def render(context)
    @var.present?
  end
end
