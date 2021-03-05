# encoding:utf-8

namespace :regions do

  task :create => :environment do
    regions_data = {"Hlavní město Praha" => ['Praha 1', 'Praha2', 'Praha3', 'Praha4', 'Praha5', 'Praha6', 'Praha7', 'Praha8', 'Praha9', 'Praha10'],
"Jihočeský kraj" => ['České Budějovice', 'Český Krumlov', 'Jindřichův Hradec', 'Písek', 'Prachatice', 'Strakonice', 'Tábor'],
"Jihomoravský kraj" => ['Blansko', 'Břeclav', 'Brno-město', 'Brno-venkov', 'Hodonín', 'Vyškov', 'Znojmo'],
"Karlovarský kraj" => ['Cheb', 'Karlovy Vary', 'Sokolov'],
"Královéhradecký kraj" => ['Hradec Králové', 'Jičín', 'Náchod', 'Rychnov nad Kněžnou', 'Trutnov'],
"Liberecký kraj" => ['Česká Lípa', 'Jablonec nad Nisou', 'Liberec', 'Semily'],
"Moravskoslezský kraj" => ['Bruntál', 'Frýdek-Místek', 'Karviná', 'Nový Jičín', 'Opava', 'Ostrava'],
"Olomoucký kraj" => ['Jeseník', 'Olomouc', 'Přerov', 'Prostějov', 'Šumperk'],
"Pardubický kraj" => ['Chrudim', 'Pardubice', 'Svitavy', 'Ústí nad Orlicí'],
"Plzeňský kraj" => ['Domažlice', 'Klatovy', 'Plzeň-město', 'Plzeň-jih', 'Plzeň-sever', 'Rokycany', 'Tachov'],
"Středočeský kraj" => ['Benešov', 'Beroun', 'Kladno', 'Kolín', 'Kutná Hora', 'Mělník', 'Mladá Boleslav', 'Nymburk', 'Praha-východ', 'Praha-západ', 'Příbram', 'Rakovník'],
"Ústecký kraj" => ['Děčín', 'Chomutov', 'Litoměřice', 'Louny', 'Most', 'Teplice,Ústí nad Labem'],
"Vysočina" => ['Havlíčkův Brod', 'Jihlava', 'Pelhřimov', 'Třebíč', 'Žďár nad Sázavou', 'Okříšky'],
"Zlínský kraj" => ['Kroměříž', 'Uherské Hradiště', 'Vsetín', 'Zlín']}
  
    regions_data.each do |title, cities|
      region = Region.find_or_create_by_title(title)
      puts "region created - #{region.title}" if region.persisted?
      cities.each do |city|
        r_city = region.cities.find_or_create_by_title(city)
        puts "city created - #{r_city.title}" if r_city.persisted?  
      end
    end
  end

end
