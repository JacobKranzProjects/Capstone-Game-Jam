extends Resource

class_name Settings

var levels = {
	1: {
		"country": "Bosnia",
		"grid_size": Vector2(8,8),
		"mines": 10,
		"facts": [
			"War legacy from 1992–1995 conflict",
			"~838 km² still contaminated",
			"Over 65,000 casualties since 1979",
			"Demining to continue until 2027"
		]
	},
	2: {
		"country": "Colombia",
		"grid_size": Vector2(9,9),
		"mines": 12,
		"facts": [
			"Over 11,000 victims since 1990",
			"Clearance ongoing since 2016 peace accords",
			"Farmers face deadly fields",
			"Ranks 2nd globally for mine casualties"
		]
	},
	3: {
		"country": "Cambodia",
		"grid_size": Vector2(10,10),
		"mines": 15,
		"facts": [
			"Scars from 1970s Khmer Rouge era",
			"~1,700 km² yet to be cleared",
			"65,000+ casualties since 1979",
			"Global aid targets 2030 freedom"
		]
	},
	4: {
		"country": "Afghanistan",
		"grid_size": Vector2(11,11),
		"mines": 20,
		"facts": [
			"War-torn since 1979",
			"1,700+ communities at risk",
			"Tops global mine casualty list",
			"45,000+ civilian killed or injured since 1989"
		]
	},
	5: {
		"country": "Angola",
		"grid_size": Vector2(12,12),
		"mines": 25,
		"facts": [
			"Relics of 1975–2002 civil war",
			"Cripples farming and trade",
			"Over 88,000 mine victims since 1994",
			"Princess Diana’s 1997 spotlight"
		]
	},
	6: {
		"country": "Vietnam",
		"grid_size": Vector2(13,13),
		"mines": 30,
		"facts": [
			"Vietnam War’s deadly leftovers",
			"~6.3 million hectares still hazardous",
			"Over 100,000 casualties post-war",
			"U.S. aids UXO cleanup efforts"
		]
	},
	7: {
		"country": "Ukraine",
		"grid_size": Vector2(14,14),
		"mines": 35,
		"facts": [
			"Spiked by 2022 Russian attack",
			"Over 2,100 km² contaminated",
			"Fields and towns booby-trapped",
			"World’s fastest-growing mine crisis"
		]
	},
	8: {
		"country": "Iraq",
		"grid_size": Vector2(15,15),
		"mines": 40,
		"facts": [
			"Mine legacy from multiple wars since 1980s",
			"~2,100+ km² contaminated",
			"Stalls rebuilding and growth",
			"ISIS left deadly traps behind"
		]
	},
	9: {
		"country": "Somalia",
		"grid_size": Vector2(16,16),
		"mines": 45,
		"facts": [
			"Instability since early 1990s",
			"Large-scale contamination hinders recovery",
			"Mines severely impact pastoral communities",
			"Conflict blocks demining progress"
		]
	},
	10: {
		"country": "Laos",
		"grid_size": Vector2(17,17),
		"mines": 50,
		"facts": [
			"Most bombed country per capita in history",
			"80 million unexploded bombs remain",
			"Heavy impact on rural economy and safety",
			"Annual casualties remain high despite efforts"
		]
	},
	11: {
		"country": "South Sudan",
		"grid_size": Vector2(18,18),
		"mines": 55,
		"facts": [
			"Mines from decades of civil conflict",
			"Over 5,000 casualties since 2004",
			"Significant barrier to development and stability",
			"Ongoing international demining assistance"
		]
	}
}

func get_level_data(level_number):
	var level = levels.get(level_number, null)
	if level:
		level["background"] = "res://game files/assets/backgrounds/%s.png" % level.country
		level["map"] = "res://game files/assets/maps/%s.png" % level.country
	return level
	
