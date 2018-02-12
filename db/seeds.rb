# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
	User.create(f_name: 'Admin',l_name:'Bleapp',cell_phone:'9998887770', email: 'admin@bleapp.com', password: 'admin123', role: 'SUPER ADMIN')
	Beacon.create(uuid: '699ebc80-e1f3-11e3-9a0f-0cf3ee3bc012', name: 'Kitchen')
	Beacon.create(uuid: '0x000b6ef7-0000-0000-xxxxxxxxxxxx', name: 'Home')
	Beacon.create(uuid: '0x000b6ef7-0000-0001-xxxxxxxxxxxx', name: 'Kitchen')
	Beacon.create(uuid: '0x000b6ef7-0000-0002-xxxxxxxxxxxx', name: 'Living Room')
	Beacon.create(uuid: '0x000b6ef7-0000-0003-xxxxxxxxxxxx', name: 'Bedroom')
	Beacon.create(uuid: '0x000b6ef7-0000-0004-xxxxxxxxxxxx', name: 'Bathroom')
	Beacon.create(uuid: '0x000b6ef7-0000-0005-xxxxxxxxxxxx', name: 'Wildcard')