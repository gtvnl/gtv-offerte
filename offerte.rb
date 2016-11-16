require "roo"
require "pathname"
require "awesome_print"

def berekenUren(array)

  hh = 0
  mm = 0
  ss = 0
  totalSeconds = 0

  array.each do |item|
    time = item.split(":")
      if time.size > 3
        return "Please format HH:MM:SS"
      end

    hh += time[0].to_i
    mm += time[1].to_i
    ss += time[2].to_i

  end

  totalSeconds = ss + (mm * 60) + (hh * (60 * 60))


  seconds = totalSeconds % 60
  minutes = (totalSeconds / 60) % 60
  hours = totalSeconds / (60 * 60)

  return format("%02d:%02d:%02d", hours, minutes, seconds)

end

calculatieData = Pathname.new("./data/test.xlsx")

# kolommen = ["Aantal producten","Artikelnummer"]

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
num_pos = 0
verdelers = []
verdeler_materiaal_start = []
verdeler_materiaal_end = []
verdeler_tijd = []

# Standaard tekst definieren
offerte_headers = ["Projectnaam", "Omschrijving", "Ordernummer", "Projectnummer", "Locatienaam", "Plaats", "Status",
  "Invoerdatum", "Datum laatste wijzigingen", "Commercieel verantwoordelijk", "Technisch verantwoordelijk"]

artikel_headers = ["Aantal producten","Artikelnummer","Omschrijving","Stuksprijs bruto","Totaalprijs","Korting artikelgroep","Nettoprijs per stuk"]
artikel_footers = ["Totalen"]
uurtypes = ["Montagekosten","Bedradingskosten","Overig algemene kosten"]

offerte_headers.each_with_index do |header, index|
  if workbook.cell("A",index + 1) == header
    puts "#{header}: \t\e[32mOK\e[0m"

  else
    puts "#{header}: \t\e[31mERROR\e[0m"
    errors += 1
  end
end

puts "*"*80

if errors == 0
  puts "Offerte is OK\n"

puts "*"*80

  offerte_headers.each_with_index do |header, index|
    cell = workbook.cell("B",index + 1)
    unless cell.to_s.empty?
      hash[header] = cell
    end
  end
else
  puts "Offerte is niet OK\n"
puts "*"*80
end

(1..workbook.last_row).each do |row|
  #  Iterate over each row
  cell = workbook.cell("A",row)

  # Check for the first matching articles header which indicates the start of the position article block
  if cell == artikel_headers[0]
    verdeler = Hash.new
    # New position found, increase
    num_pos += 1

    # Determine the names of the distributors
    details = workbook.cell("A",row - 1).split(",")

    verdeler[:positie] = details[0] unless details[0].nil?
    verdeler[:naam] = details[1] unless details[0].nil?

    # Define the start of the block
    verdeler[:materiaal] = {start: row + 1}


    verdelers << verdeler

  end

  if cell == artikel_footers[0]

    tijd = Hash.new

    verdeler_materiaal_end << row - 5

    time1 = workbook.cell("A",row - 4)
    desc1 = workbook.cell("C",row - 4)

    time2 = workbook.cell("A",row - 3)
    desc2 = workbook.cell("C",row - 3)

    time3 = workbook.cell("A",row - 2)
    desc3 = workbook.cell("C",row - 2)

    if /^(?:(?:([01]?\d|2[0-3]):)?([0-5]?\d):)?([0-5]?\d)$/.match(time1)
      tijd["#{desc1}"] = "#{time1}"
    end

    if /^(?:(?:([01]?\d|2[0-3]):)?([0-5]?\d):)?([0-5]?\d)$/.match(time2)
      tijd["#{desc2}"] = "#{time2}"

    end

    if /^(?:(?:([01]?\d|2[0-3]):)?([0-5]?\d):)?([0-5]?\d)$/.match(time3)
      tijd["#{desc3}"] = "#{time3}"
    end


    verdeler_tijd << tijd

  end
end

if verdelers.size == verdeler_materiaal_end.size
  verdelers.each_with_index do |verdeler, index|
    verdelers[index][:materiaal].merge!(end: verdeler_materiaal_end[index])
  end
else
  puts "Fout in het toevoegen van materiaal"
end

if verdelers.size == verdeler_tijd.size
  puts "Montage tijden: OK"
  verdelers.each_with_index do |verdeler, index|
    verdelers[index][:tijd] = verdeler_tijd[index]
  end
else
  puts "Toevoegen Montage tijden: ERROR"
end

verdelers.each do |verdeler|
  totaal_uren = []
  puts verdeler[:naam]
  uurtypes.each do |uurtype|
    totaal_uren << verdeler[:tijd][uurtype]
  end
  verdeler[:tijd].merge!("Totaal" => "#{berekenUren(totaal_uren)}")
end

puts "*"*80

puts "*"*80
puts "Aantal verdelers: #{num_pos}/#{verdelers.size}"

puts "*"*80
ap verdelers
puts "*"*80

(verdelers[0][:materiaal][:start]..verdelers[0][:materiaal][:end]).each do |row|

  aantal = workbook.cell("A",row)
  artikel = workbook.cell("B",row)
  omschrijving = workbook.cell("C",row)
  bruto = workbook.cell("D",row)
  korting = workbook.cell("F",row)
  netto = workbook.cell("G",row)

  total = 0
  per_stuk = 0


  if !netto.nil?
    total = aantal * netto
    
    total_formatted = "%.2f" % total
    netto_formatted = "%.2f" % netto

    puts "%-15s %-80s %-5s %-20s %-20s" % ["#{artikel}","#{omschrijving}","#{aantal}","EUR #{netto_formatted}","EUR #{total_formatted}"]
  else
    korting = (korting.to_f / 100)
    per_stuk =  bruto * korting
    total = aantal * per_stuk

    per_stuk_formatted = "%.2f" % per_stuk
    total_formatted = "%.2f" % total


    puts "%-15s %-80s %-5s %-20s %-20s" % ["#{artikel}","#{omschrijving}","#{aantal}","EUR #{per_stuk_formatted}","EUR #{total_formatted}"]
  end

end

# end
end
