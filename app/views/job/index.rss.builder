xml.instruct!
xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
 xml.channel do
   xml.title [@site.portal_title, 'Работа'].join(' | ')
   xml.description raw([@site.portal_title, 'Работа'].join(' | '))
   xml.link 'https://' + request.host

   xml.image do
     xml.url "https://#{request.host}/images/city/#{@site.domain}/logo.jpg"
     xml.title @site.portal_title
     xml.link 'https://' + request.host
   end

   xml.pubDate @job_items.present? ? @job_items.first.created_at.rfc822 : Time.now.rfc822

   xml.language "ru"
   xml.copyright @site.domain
   xml.webMaster "oleg@evrone.ru"

   @job_items.each do |job_item|
     xml.item do |xml2|
        xml2.pubDate      job_item.created_at.rfc822
        xml2.title job_item.title
        xml2.link  url_for(job_item.url)
        if @add_model_name
          xml2.desription job_item.class.model_name.human + ": "  + job_item.text
        else
          xml2.desription job_item.text
        end
     end
   end
 end
end