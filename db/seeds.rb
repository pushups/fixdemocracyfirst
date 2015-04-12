# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# admin user
User.create first_name: 'Questionr',
            last_name: 'Admin',
            email: 'admin@questionr.org',
            location: 'San Francisco, CA',
            fb_uid: nil,
            fb_token: nil,
            admin: true,
            postal_code: '94114',
            latitude: 37.798144,
            longitude: -122.401915

potus2016 = Election.create rwu_id: nil,
                            name: '2016 Presidential Election',
                            state: nil,
                            office_type_id: 'POTUS',
                            special: false,
                            election_year: 2016

carly_the_person = Person.create rwu_id: nil,
                                 first_name: 'Carly',
                                 nickname: nil,
                                 middle_name: nil,
                                 last_name: 'Fiorina',
                                 suffix: nil

carly_the_candidate = Candidate.create rwu_id: nil,
                                       person_id: carly_the_person.id,
                                       office_id: 'US',
                                       position: 'President',
                                       district: nil

carly_for_potus2016 = Campaign.create rwu_id: nil,
                                      candidate_id: carly_the_candidate.id,
                                      election_id: potus2016.id

radisson_manchester = Venue.create rwu_id: nil,
                                   name: 'Radisson Hotel',
                                   street_address1: '700 Elm Street',
                                   street_address2: nil,
                                   unit: nil,
                                   city: 'Manchester',
                                   state: 'NH',
                                   postal_code: '03217', 
                                   url: 'http://www.radisson.com/manchester-hotel-nh-03101/nhmanch',
                                   latitude: 42.989984,
                                   longitude: -71.463760

eoy = Event.create rwu_id: nil,
                   title: 'NH High Tech Council',
                   description:"Carly Fiorina will deliver a keynote address for the New Hampshire High Tech Council’s Entrepreneur of the Year (EOY) award event May 8 at the Radisson in Manchester.", 
                   venue_id: radisson_manchester.id,
                   public: nil

eoy_day = EventDay.create rwu_id: nil,
                          event_id: eoy.id,
                          date: '2015-05-08',
                          start_time: '2015-05-08 18:30:00 EDT',
                          end_time: '2015-05-08 20:00:00 EDT'