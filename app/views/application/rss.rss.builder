prepared_root_url = root_url[0..-2] # Without a trailing slash

xml.instruct!
xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
 xml.channel do
   xml.title @xml["title"]
   xml.description raw(@xml["description"])
   xml.link root_url

   xml.image do
     xml.url prepared_root_url + image_path('header_logo.png')
     xml.title @site.portal_title
     xml.link root_url
   end

   xml.pubDate @xml["created_at"]

   xml.language "ru"
   xml.copyright @site.domain
   xml.webMaster "oleg@evrone.ru"

   @docs.each do |doc|
     xml.item do |xml2|
        xml2.guid({isPermaLink: true}, prepared_root_url + doc.url(only_id: true))
        xml2.title doc.title
        xml2.link prepared_root_url + doc.url
        xml2.category doc.rubric.try(:title) if doc.rubric.present?

        if defined?(doc.main_photo) && doc.main_photo
          xml2.image prepared_root_url + url_for_file_column(doc.main_photo, "image", "small")
          xml2.enclosure({:url => (prepared_root_url + url_for_file_column(doc.main_photo, "image", "medium")), :type => "image/jpeg"})
          xml2.description do
            xml2.cdata! image_tag(prepared_root_url + url_for_file_column(doc.main_photo, "image", "medium")) + raw(" <br><br> " + doc.annotation.to_s)
          end
        else
          xml2.description do
            xml2.cdata! raw(doc.annotation)
          end if doc.respond_to? :annotation
        end

        xml2.fulltext do
          xml2.cdata! raw(doc.text)
        end if doc.respond_to? :text

        doc.tags.each do |tag|
          xml2.tag do
            xml2.cdata! tag.name
          end
        end if doc.respond_to?(:tags) and doc.tags.present?

        xml2.pubDate doc.created_at.rfc822
        xml2. << '<yandex:full-text>' + strip_tags(CGI.unescapeHTML(doc.text)) + '</yandex:full-text>' if @full
        xml2. << '<full-text>' + strip_tags(CGI.unescapeHTML(doc.text)) + '</full-text>' if @full
        xml2. << '<author>' + doc.user.fio_or_login+ '</author>' if doc.respond_to?(:user) && doc.user.present?
     end
   end
 end
end