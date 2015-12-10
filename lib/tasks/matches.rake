require_relative 'task_helpers.rb'

namespace :matches do

  desc 'start overdue matches'
  task start_overdue_matches: :environment do
    TaskHelpers::start_overdue_matches
  end

  desc 'generate GIF'
  task generate_gif: :environment do
    TaskHelpers::encode_gif(Rails.root.join('resources','match-images'))
  end
end