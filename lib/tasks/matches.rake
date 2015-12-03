require_relative 'task_helpers.rb'

namespace :matches do

  desc 'start overdue matches'
  task start_overdue_matches: :environment do
    TaskHelpers::start_overdue_matches
  end

end