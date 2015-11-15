require 'rubygems'
require 'rufus-scheduler'
require_relative '../../lib/tasks/task_helpers'

rufus_sched = Rufus::Scheduler.singleton

rufus_sched.every '3s' do
  #puts 'Hello... Rufus'
  TaskHelpers::start_overdue_leagues
end

#rufus_sched.join