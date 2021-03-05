xml.instruct!
xml.rss "version" => "2.0" do
 xml.channel do
   xml.title @site.portal_title
   xml.link 'https://' + request.host
   xml.description @site.portal_title

   xml.image do
     xml.url @site.logo.url
     xml.title @site.portal_title
     xml.link 'https://' + request.host
   end

   xml.pubDate @docs.first.created_at.rfc822

   xml.language "ru"
   xml.copyright @site.domain
   xml.webMaster "oleg@evrone.ru"

   @docs.each do |doc|
     xml.item do |xml2|
       xml2.title doc.title
       xml2.link 'https://' + request.host + '/news/' + doc.rubric.link + '/' + doc.id.to_s + '-' + doc.param.to_s
       xml2.pubDate doc.created_at.rfc822
       if doc.main_photo
            xml2.description image_tag(url_for_file_column(doc.main_photo, "image", "medium")) + raw(" <br><br> " + doc.annotation)
            xml2. << '<fulltext>' + CGI.escapeHTML(strip_tags(CGI.unescapeHTML(doc.text))) + '</fulltext>'
            xml2.enclosure({:url => (url_for_file_column(doc.main_photo, "image", "medium")), :type => "image/jpeg"})
            xml2.image url_for_file_column(doc.main_photo, "image", "small")
       else
            xml2.description raw(doc.annotation)
            xml2.fulltext strip_tags(doc.text)
       end

       xml2. << '<author>' + doc.user.fio_or_login + '</author>' if doc.user
     end
   end
 end
end
