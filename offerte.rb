require 'roo'
require 'pathname'


calculatieData = Pathname.new("./data/test.xlsx")


if !calculatieData.file?
  puts "\e[31mx Fout tijdens het openen van #{calculatieData}!\e[0m"
elsif ![].empty?
  puts "\e[32m✔ Calculatie is al geïmporteerd.\e[0m"
else
  puts "\e[32m- Bezig met importeren ...\e[0m"

  xlsx = Roo::Excelx.new(calculatieData.realpath.to_s)
  puts xlsx.parse(:header_search => ['Aantal producten','Omschrijving','Stuksprijs bruto','Totaalprijs','Korting artikelgroep','Nettoprijs per stuk']).size

  # sheet.parse(header_search: [/UPC*SKU/,/ATS*\sATP\s*QTY\z/])
  # sheet.each_row_streaming do |row|
  #   puts row.inspect # Array of Excelx::Cell objects
  # end
  # xlsx.each_row_streaming do |row|
  #   # puts row.inspect
  #   row.each do |cell|
  #     cell = Roo::Excelx::Cell
  #     puts cell.type
  #   end
  # end

end
