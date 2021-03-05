xml.instruct!
xml.rss "version" => "2.0", "xmlns:mailru" => "http://news.mail.ru" do
 xml.channel do
   xml.title @site.portal_title
   xml.link 'https://' + @site.domain
   xml.description @site.portal_title

   xml.image do
     xml.url 'https://' + @site.domain + @site.logo.url
     xml.title @site.portal_title
     xml.link 'https://' + @site.domain
   end

   xml.pubDate @docs.first.created_at.rfc822

   xml.language "ru"
   xml.webMaster "oleg@evrone.ru"

   @docs.each do |doc|
     xml.item do |xml2|
       xml2.title do
         xml2.cdata! doc.title
       end
       xml2.link  'https://' + @site.domain + doc.url
       xml2.pubDate doc.created_at.rfc822

       if doc.main_photo.present? && !doc.main_photo.is_a?(Photo)
          xml2.enclosure({:url => ('https://' + @site.domain + url_for_file_column(doc.main_photo, "image", "medium")), :type => "image/jpeg"})
       end

       if doc.photos.present?
         doc.photos.limit(5).each do |photo|
          xml2.enclosure({:url => ('https://' + @site.domain + url_for_file_column(photo, "image", "medium")), :type => "image/jpeg"})
         end
       end

       #кошмар ((
       doc_text = strip_tags(CGI.unescapeHTML(doc.is_a?(Gallery) ? doc.annotation : doc.text)).gsub("\t", '').gsub(/(\r\n)( )*&nbsp;( )*(\r\n)/, "\r\n").gsub(/(\r\n)+/, "\r\n").gsub(/(\n)+/, "\n").gsub("\r\n", "\r\n\r\n").strip

       (description, text) = doc_text.split("\n", 2)

       xml2.description do
         xml2.cdata! raw(description.try(:strip))
       end

       xml2. << raw('<mailru:full-text><![CDATA[' + (text ? text.strip : '') + ']]></mailru:full-text>')
     end
   end
 end
end
