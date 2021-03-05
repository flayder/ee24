xml.instruct!
xml.rss "version" => "2.0", "xmlns" => "http://backend.userland.com/rss2", "xmlns:yandex" => "http://news.yandex.ru" do
  xml.channel do
    xml.title @site.portal_title
    xml.link 'https://' + @site.domain
    xml.description @site.portal_title

    xml.image do
      xml.url 'https://' + @site.domain + @site.logo.url
      xml.title @site.portal_title
      xml.link 'https://' + @site.domain
    end

    xml.pubDate @docs.first.created_at.in_time_zone(@site.time_zone).rfc822

    xml.language "ru"
    xml.copyright @site.domain
    xml.webMaster "oleg@evrone.ru"

    @docs.each do |doc|
      xml.item do |xml2|
        xml2.title doc.title
        xml2.link  'https://' + @site.domain + doc.url
        xml2.pubDate doc.created_at.in_time_zone(@site.time_zone).rfc822
        if doc.main_photo
          unless doc.is_a?(Doc) && doc.pictureless?
            xml2.image   'https://' + @site.domain + url_for_file_column(doc.main_photo, "image", "small")
            xml2.enclosure({:url => ('https://' + @site.domain + url_for_file_column(doc.main_photo, "image", "medium")), :type => "image/jpeg"})
          end
        end
        xml2.description doc.annotation

        xml2. << '<yandex:full-text>' + CGI.escapeHTML(strip_tags(CGI.unescapeHTML(doc.text))) + '</yandex:full-text>'
        xml2. << '<full-text>' + CGI.escapeHTML(strip_tags(CGI.unescapeHTML(doc.text))) + '</full-text>'
        xml2. << '<author>' + doc.user.fio_or_login + '</author>' if doc.user.present? and doc.user.present?
      end
    end
  end
end
