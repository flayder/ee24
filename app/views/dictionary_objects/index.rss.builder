xml.instruct!
xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
 xml.channel do
   xml.title @xml["title"]
   xml.description raw(@xml["description"])
   xml.link 'https://' + request.host

   xml.image do
     xml.url "https://#{request.host}/images/city/#{@site.domain}/logo.jpg"
     xml.title @site.portal_title
     xml.link 'https://' + request.host
   end

   xml.pubDate @xml["created_at"]

   xml.language "ru"
   xml.copyright @site.domain
   xml.webMaster "oleg@evrone.ru"

   @dictionaries.each do |dictionary|
     xml.item do |xml2|
        xml2.pubDate      dictionary.created_at.rfc822
        xml2.title dictionary.title
        xml2.link  dict_show_url(dictionary.id)
        xml2.desription dictionary.text
     end
   end
 end
end