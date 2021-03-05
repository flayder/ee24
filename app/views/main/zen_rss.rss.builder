xml.instruct!
xml.rss :version => '2.0', 'xmlns:content' => "http://purl.org/rss/1.0/modules/content/", 'xmlns:dc' => "http://purl.org/dc/elements/1.1/", 'xmlns:media' => "http://search.yahoo.com/mrss/", 'xmlns:atom' => "http://www.w3.org/2005/Atom", 'xmlns:georss' => "http://www.georss.org/georss" do
  xml.channel do
    xml.title 'Все о Чехии: новости, афиша, аналитика на 420on.cz'
    xml.link 'https://420on.cz'
    xml.description 'Информационный портал 420on.cz предоставляет самую подробную информацию о Праге и
      Чехии: афиша, прогноз погоды, каталог компаний, новости достопримечательности, информация для туристов
      и иммигрантов'
    xml.language 'ru'

    @docs.each do |doc|
      xml.item do
        xml.title doc.title
        xml.link 'https://420on.cz' + doc.url
        xml.pdalink 'https://420on.cz' + doc.url
        xml.amplink 'https://420on.cz' + doc.url
        xml.pubDate doc.created_at
        xml.tag!('media:rating', 'scheme' => "urn:simple") { xml.text! 'nonadult' }
        xml.author doc.user.login
        xml.category doc.global_rubric.title
        xml.enclosure 'url' => 'https://420on.cz' + doc.main_photo.image.url, 'type' => "image/jpeg"
        xml.description { xml.cdata! doc.annotation }
        xml.tag!('content:encoded') { xml.cdata! doc.text }
      end
    end
  end
end
