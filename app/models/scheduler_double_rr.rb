class SchedulerDoubleRR
  def schedule_season(teams)
    puts 'scheduled'
    #puts Date.beginning_of_week

    season_start=1.week.from_now.beginning_of_week+20.hour
    season_length=decide_on_season_length(teams.size)
    for i in 0..season_length-1
      puts season_start+i.day
    end

    #puts match_pairings(teams)
    days=assign_parings_to_days(match_pairings(teams),season_length)
    for i in 0..season_length-1
      puts days[i]
      puts "\n"
    end

    #puts teams
  end

  private
    def assign_parings_to_days(parings,season_length)
      days=Array.new(season_length){[]}

      i=0
      while(parings.size!=0)
        twoMatchesPerDay=false
        days[i].each do |match|
          if(match.contains_same_team(parings.last))
            twoMatchesPerDay=true
          end
        end
        if(!twoMatchesPerDay)
          days[i] << parings.pop
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
      best=-1
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

  end
end