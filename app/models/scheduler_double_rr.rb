class SchedulerDoubleRR
  def schedule_season(teams)
    puts 'scheduled'
    #puts Date.beginning_of_week

    season_start=1.week.from_now.beginning_of_week+20.hour
    season_length=decide_on_season_length(teams.size)

    #puts match_pairings(teams)
    #days=assign_parings_to_days(match_pairings(teams),season_length)
    days=assign_matches(teams,season_length)
    for i in 0..season_length-1
      puts season_start+i.day
      puts days[i]
      puts "\n"
    end

    #puts teams
  end

  private
    #error with only two teams, only one match is scheduled, error with 0 or 1 teams
    def assign_matches(t, season_length)
      schedule=Array.new(season_length){[]}
      teams=Array(t)

      if (teams.length%2!=0)
        teams.push(nil)
      end

      top=teams.take(teams.length/2)
      bottom=teams.drop(teams.length/2)

      #round1
      (0..teams.length-2).each do |day|
        (0..top.length).each do |team|
          schedule[day] << Pairing.new(top[team], bottom[team])
        end
        rotate(top,bottom)
      end
      #round2
      (0..teams.length-2).each do |day|
        (0..top.length).each do |team|
          schedule[teams.length-1+day] << Pairing.new(bottom[team], top[team])
        end
        rotate(top,bottom)
      end

      #delete pauses from match schedule
      schedule.each do |day|
        day.compact
        day.delete_if{|match| match.contains_nil}
      end

      #make sure more or less the same number of matches is scheduled each day
      while (is_badly_distributed(schedule)) do
        if(!redistribute(schedule))
          break
        end
      end

      schedule
    end

    #doesn't distribute perfectly
    def redistribute(schedule)
      max=schedule.max_by {|element| element.length}

      schedule.each do |day|
        if (day.length<max.length-1)
          if(day.all?{|match| !match.contains_same_team(max.last)})
            day<<max.pop
            return true
          end
        end
      end
      return false
    end

    def is_badly_distributed(schedule)
      max=schedule.max_by {|element| element.length}.length
      min=schedule.min_by {|element| element.length}.length
      if(max-min>=2)
        return true
      else
        return false
      end
    end

    def rotate(top, bottom)
      bottom<<top.pop
      top.insert(1,bottom.first)
      bottom.delete_at(0)
    end


    def assign_parings_to_days(parings,season_length)
      days=Array.new(season_length){[]}

      i=0
      tries=0
      while(parings.size!=0)
        twoMatchesPerDay=false
        days[i].each do |match|
          if(match.contains_same_team(parings.last))
            twoMatchesPerDay=true
          end
        end
        if(!twoMatchesPerDay)
          days[i] << parings.pop
          tries=0
        else
          tries=tries+1
        end
        if(tries==season_length)
          puts "no free days"
        end
        i=(i+1)%season_length
      end
      days
    end

    def match_pairings(teams)
      pairings=[]

      teams.each do |a|
        teams.each do |b|
          pairings << Pairing.new(a,b) unless a == b
        end
      end

      pairings
    end

    def decide_on_season_length(number_of_teams)
      best=-1 #problem if no better lenght is found (e.g. n_o_t=0||1) this stays
      matches=number_of_matches(number_of_teams)
      opt=optimal_matches_per_day(number_of_teams)
      [7,14].each do |i|
        if (matches/i-opt).abs<(matches/best-opt).abs
          best=i
        end
      end
      best
    end

    def optimal_matches_per_day(number_of_teams)
      ((number_of_teams/2).floor).abs
    end

    def number_of_matches(number_of_teams)
      number_of_teams*(number_of_teams-1)*2
    end

  class Pairing
    def initialize(a,b)
      @teams=[a,b]
    end

    def contains_same_team(pairing)
      @teams.each do |t1|
        pairing.teams.each do |t2|
          if (t1==t2)
            return true
          end
        end
      end
      false
    end

    def teams
      @teams
    end

    def to_s
      "#{@teams[0]} | #{@teams[1]}"
    end

    def inspect
      "#{@teams[0]} | #{@teams[1]}"
    end

    def contains_nil
      @teams[0]==nil||@teams[1]==nil
    end

  end
end