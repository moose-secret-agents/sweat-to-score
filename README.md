# Sweat To Score
###### CyberCoach Project in Advanced Software Engineering Course at University of Fribourg
###### [http://sweat-to-score.herokuapp.com/](http://sweat-to-score.herokuapp.com/)
---

Sweat To Score! Found your own team, manage your tactics and sweat your way to fame and glory!

Sweat To Score is a web application developed for the course "Advanced Software Engineering" at the University of Fribourg. It aims to motivate users to get their behinds out of their comfortable chairs and do some exercise! The application features a fantasy soccer system which enables users to manage their teams alone or in pairs. The fitness of the user's players increases when you exercise and track it using our Android application found here:

[Sweat to Score Android App](https://github.com/moose-secret-agents/activity-tracker-2)

<br>

## Installation Guide:
Please follow the following instructions in order to make the application run locally:

* Install Ruby 2.1.3: [Ruby Installation Guide](https://www.ruby-lang.org/en/documentation/installation/)
* Install PostgreSQL: [Postgres Installation Guide](http://www.postgresql.org/download/)
* Clone the Project: [GitHub Repository](https://github.com/moose-secret-agents/sweat-to-score)
* Go to your Terminal and type:
    * `$ cd sweat-to-score`
    * `$ gem install bundler`
    * `$ bundle install`
    * `$ rake db:create db:migrate`
    * `$ rake db:seed`
    * `$ rails s`
    * `$ open "http://localhost:3000"`

<br>

## System Architecture
The System features the following subsystems:
* Sweat To Score webserver: Hosts the web-app, schedules and simulates matches, and allows to manage teams
* Sweat To Score Android App: Tracks the user's activity and sends it to the Activity Tracking Server
* Sweat To Score Activity Server: Receives the workout data from the Android app and computes useful metrics, which are then inserted to Cybercoach and made available to the user for training
* Cybercoach: Provides User management and storage of workout data. Is slow.

See below for links to the other parts of the system

## Links:
* Twitter Account: [https://twitter.com/HiddenDeerSpies](https://twitter.com/HiddenDeerSpies)
* Documentation: [https://github.com/moose-secret-agents/Documentation](https://github.com/moose-secret-agents/Documentation)
* ActivityServer: [https://github.com/moose-secret-agents/ActivityServer](https://github.com/moose-secret-agents/ActivityServer)
* ActivityTracker2: [https://github.com/moose-secret-agents/activity-tracker-2](https://github.com/moose-secret-agents/activity-tracker-2)
* CoachAssist: [https://github.com/moose-secret-agents/coach_assist](https://github.com/moose-secret-agents/coach_assist)


