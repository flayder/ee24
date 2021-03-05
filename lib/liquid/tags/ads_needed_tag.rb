class AdsNeededTag < Liquid::Tag
  def initialize(tag_name)
     super
  end

  def render(context)
    ads_needed?
  end
end
