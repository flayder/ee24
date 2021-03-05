module Modules
  module WithMultipleAds
    def find_more_banners ad_codes, rubric_type, rubric_ids
      AdCode::BANNER_TYPES.each do |banner_type|
        banners = AdCode.site(@site.id).where(:ad_section_id => rubric_ids, :ad_section_type => rubric_type, :banner_type => banner_type)
        if banners.any?
          banners.sort!{ |a,b| b.ad_section.level <=> a.ad_section.level }
          ad_codes[banner_type] ||= banners.first.code
        end
      end
    end
  end
end