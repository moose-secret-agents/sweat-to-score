require 'rubygems'
require 'rufus-scheduler'
require_relative '../../lib/tasks/task_helpers'

rufus_sched = Rufus::Scheduler.singleton

rufus_sched.every '5m' do
  SchedulingTasks.start_overdue_leagues
  SchedulingTasks.end_finished_leagues
end

class SchedulingTasks
  def self.start_overdue_leagues
    #semaphore.synchronize {
      TaskHelpers::start_overdue_leagues
    #}
  end
  def self.end_finished_leagues
    #semaphore.synchronize s{
      TaskHelpers::end_finished_leagues
    #}
  end
end

#rufus_sched.join #not sure if needed, works without