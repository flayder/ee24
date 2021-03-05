xml.instruct!
xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
 xml.channel do
   xml.title [@site.portal_title, 'Компании'].join(' | ')
   xml.description raw([@site.portal_title, 'Компании'].join(' | '))
   xml.link 'https://' + request.host

   xml.image do
     xml.url "https://#{request.host}/images/city/#{@site.domain}/logo.jpg"
     xml.title @site.portal_title
     xml.link 'https://' + request.host
   end

   xml.pubDate @catalogs.present? ? @catalogs.first.created_at.rfc822 : Time.now.rfc822

   xml.language "ru"
   xml.copyright @site.domain
   xml.webMaster "oleg@evrone.ru"

   @catalogs.each do |catalog|
     xml.item do |xml2|
        xml2.pubDate      catalog.created_at.rfc822
        xml2.title catalog.title
        xml2.link  url_for(catalog.url(@site))
        xml2.desription catalog.annotation
     end
   end
 end
end