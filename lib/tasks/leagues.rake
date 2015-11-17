require_relative 'task_helpers.rb'

namespace :leagues do

  desc 'start overdue leagues'
  task start_overdue_leagues: :environment do
    TaskHelpers::start_overdue_leagues
  end

  desc 'end finished leagues'
  task end_finished_leagues: :environment do
    TaskHelpers::start_overdue_leagues
  end

end