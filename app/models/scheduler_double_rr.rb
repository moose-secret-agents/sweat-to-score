class SchedulerDoubleRR
  def schedule_season(league)
    teams=league.teams
    season_start=league.starts_at
    season_length=actual_league_length(league)
    schedule=assign_matches(teams,season_length,league)

    for i in 0..season_length-1
      date=season_start+i.day
      schedule[i].each do |match|
        league.schedule_match(match.teams[0],match.teams[1],date)
      end
    end
    schedule
  end

  def actual_league_length(league)
    [league.league_length!=nil ? league.league_length : 0, min_league_length(league)].max
  end

  def min_league_length(league)
    2*(league.teams.length%2+league.teams.length-1)
  end

  private
    def assign_matches(t, season_length, league)


      schedule=Array.new(season_length){[]}
      teams=t.inject([]){|teams,team| teams<<team}

      if(teams.length==2)
        schedule[0]<<Pairing.new(teams[0],teams[1])
        schedule[1]<<Pairing.new(teams[1],teams[0])
        return schedule
      end

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
        day.compact!
        day.delete_if{|match| match.contains_nil}
      end

      schedule=split_rounds(schedule, league)

      #make sure more or less the same number of matches is scheduled each day
      #while (is_badly_distributed(schedule.take((schedule.size-schedule.size%2)/2))) do
        #if(!redistribute(schedule.take((schedule.size-schedule.size%2)/2)))
      while (is_badly_distributed(schedule.take((schedule.size-schedule.size%2)/2))) do
        if(!redistribute(schedule.take((schedule.size-schedule.size%2)/2)))
          break
        end
      end

      while (is_badly_distributed(schedule.last((schedule.size-schedule.size%2)/2))) do
        if(!redistribute(schedule.last((schedule.size-schedule.size%2)/2)))
          break
        end
      end
      schedule
    end


    def split_rounds(schedule, league)
      schedule_split=Array.new(schedule.size){[]}
      round_length=min_league_length(league)/2

      (0..(round_length-1)).each do |i|
        schedule_split[i]=schedule[i]
      end

      (0..(round_length-1)).each do |i|
        schedule_split[schedule.size-round_length+i]=schedule[round_length+i]
      end

      schedule_split
    end

    #doesn't distribute perfectly
    def redistribute(schedule)
      max=schedule.max_by {|element| element.length}



      schedule.each do |day|
        if (day.length<max.length-1)
          max.each do |max_match|
            if(day.all?{|match| !match.contains_same_team(max_match)})
              max.delete(max_match)
              day<<max_match
              return true
            end
          end
        end
      end
      return false
    end

    def is_badly_distributed(schedule)
      if schedule.length==0
        return false
      end

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

    def decide_on_season_length(number_of_teams)
      best=0 #problem if no better lenght is found (e.g. n_o_t=0||1) this stays
      matches=number_of_matches(number_of_teams)
      opt=optimal_matches_per_day(number_of_teams)
      [7,14].each do |i|
        if best==0||(matches/i-opt).abs<(matches/best-opt).abs
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