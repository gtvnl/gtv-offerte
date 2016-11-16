module ApplicationHelper

  def addTime(array)

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
end
