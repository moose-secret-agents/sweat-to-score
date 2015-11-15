require_relative 'task_helpers.rb'

namespace :leagues do

  desc 'start overdue leagues'
  task end_overdue: :environment do
    TaskHelpers::start_overdue_leagues
  end

end