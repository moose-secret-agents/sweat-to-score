require 'rubygems'
require 'rufus-scheduler'
require_relative '../../lib/tasks/task_helpers'

rufus_sched = Rufus::Scheduler.singleton

rufus_sched.every '30s', :overlap => false do
  SchedulingTasks.start_overdue_leagues
  SchedulingTasks.end_finished_leagues
  SchedulingTasks.start_overdue_matches
end

rufus_sched.cron '0 0 * * mon', :overlap => false do
  SchedulingTasks.clear_weekly_tokens
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
  def self.start_overdue_matches
    #semaphore.synchronize s{
    TaskHelpers::start_overdue_matches
    #}
  end

  def self.clear_weekly_tokens
    #semaphore.synchronize s{
    TaskHelpers::clear_tokens
    #}
  end

end

#rufus_sched.join #not sure if needed, works without