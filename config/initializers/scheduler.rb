require 'rubygems'
require 'rufus-scheduler'
require_relative '../../lib/tasks/task_helpers'

rufus_sched = Rufus::Scheduler.singleton
semaphore = Mutex.new

rufus_sched.every '5m' do
  semaphore.synchronize {
    #puts "2"
    SchedulingTasks.start_overdue_leagues
  }
end

rufus_sched.every '5m' do
  semaphore.synchronize {
    #puts "1"
    SchedulingTasks.end_finished_leagues
  }
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