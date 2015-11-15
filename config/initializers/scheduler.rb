require 'rubygems'
require 'rufus-scheduler'
require_relative '../../lib/tasks/task_helpers'

rufus_sched = Rufus::Scheduler.singleton

rufus_sched.every '3s' do
  #puts '1Hello... Rufus1'
  TaskHelpers::start_overdue_leagues
end

rufus_sched.every '10s' do
  #puts '2Hello... Rufus2'
  TaskHelpers::end_finished_leagues
end

#rufus_sched.join