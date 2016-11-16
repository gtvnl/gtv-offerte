require 'roo'
require 'pathname'


calculatieData = Pathname.new("./data/test.xlsx")

# kolommen = ['Aantal producten','Artikelnummer']

if !calculatieData.file?
  puts "\e[31mx Fout tijdens het openen van #{calculatieData}!\e[0m"
elsif ![].empty?
  puts "\e[32m✔ Calculatie is al geïmporteerd.\e[0m"
else
  puts "\e[32m- Verwerken ...\e[0m"

  workbook = Roo::Excelx.new(calculatieData.realpath.to_s)
  workbook.default_sheet = workbook.sheets.first

# Controleer eerst of de opmaak van het bestand in orde is
hash = Hash.new
errors = 0
aantal_posities = 0

offerte_headers = ["Projectnaam", "Omschrijving", "Ordernummer", "Projectnummer", "Locatienaam", "Plaats", "Status",
  "Invoerdatum", "Datum laatste wijzigingen", "Commercieel verantwoordelijk", "Technisch verantwoordelijk"]

artikel_headers = ['Aantal producten','Artikelnummer','Omschrijving','Stuksprijs bruto','Totaalprijs','Korting artikelgroep','Nettoprijs per stuk']

offerte_headers.each_with_index do |header, index|
  if workbook.cell('A',index + 1) == header
    puts "#{header}: \t\e[32mOK\e[0m"

  else
    puts "#{header}: \t\e[31mERROR\e[0m"
    errors += 1
  end
end

puts "----\n"

if errors == 0
  puts "Offerte is OK\n"
  puts "----\n"

  offerte_headers.each_with_index do |header, index|
    cell = workbook.cell('B',index + 1)
    unless cell.to_s.empty?
      hash[header] = cell
    end
  end
else
  puts "Offerte is niet OK\n"
  puts "----\n"

end

(1..workbook.last_row).each do |row|
  puts workbook.cell('A',row)
end

end
