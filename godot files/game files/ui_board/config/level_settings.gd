extends Resource

class_name Settings

var levels = {
	1: {
		"country": "Bosnia",
		"grid_size": Vector2(8,8),
		"mines": [10, 10],
		"facts": [
			"War legacy from 1992–1995 conflict",
			"~838 km² still contaminated",
			"Over 65,000 casualties since 1979",
			"Demining to continue until 2027"
		],
		"helper": {
			"name": "Mine Detection Dog",
			"icon": "🐕",
			"effect": "Reveal safe cells in a random 2x2 area",
			"description": "Trained at the Norwegian People's Aid's Global Training Centre in Sarajevo, these Belgian Shepherds undergo an 18-month program to detect landmines. Deployed in Bosnia and beyond, they've helped reduce mine contamination from 8% to 2% of the territory."
		},
		"global": {
			"medic_kit": "Gain 1 extra life",
			"coop_reveal": "Partner reveals 3 cells for you",
			"send_mine": "Send 1 of your mines to partner's board"
		}
	},
	2: {
		"country": "Colombia",
		"grid_size": Vector2(9,9),
		"mines": [12, 12],
		"facts": [
			"Over 11,000 victims since 1990",
			"Clearance ongoing since 2016 peace accords",
			"Farmers face deadly fields",
			"Ranks 2nd globally for mine casualties"
		],
		"helper": {
			"name": "Army Deminer",
			"icon": "🛡️",
			"effect": "Flag 2 random mines",
			"description": "The Colombian Army's First Brigade of Humanitarian Demining Engineers has cleared over 43,000 km², declaring 37 municipalities mine-free in 2018, reducing Colombia’s victim ranking from 2nd to 10th globally."
		},
		"global": {
			"medic_kit": "Gain 1 extra life",
			"coop_reveal": "Partner reveals 3 cells for you",
			"send_mine": "Send 1 of your mines to partner's board"
		}
	},
	3: {
		"country": "Cambodia",
		"grid_size": Vector2(10,10),
		"mines": [15, 15],
		"facts": [
			"Scars from 1970s Khmer Rouge era",
			"~1,700 km² yet to be cleared",
			"65,000+ casualties since 1979",
			"Global aid targets 2030 freedom"
		],
		"helper": {
			"name": "APOPO HeroRAT",
			"icon": "🐀",
			"effect": "Reveal safe cells in a random 3x3 area",
			"description": "APOPO’s HeroRATs, trained African giant pouched rats, work with Cambodia’s CMAC since 2014, clearing 300-400 m² daily, making land safe for farming and communities."
		},
		"global": {
			"medic_kit": "Gain 1 extra life",
			"coop_reveal": "Partner reveals 4 cells for you",
			"send_mine": "Send 1 of your mines to partner's board"
		}
	},
	4: {
		"country": "Afghanistan",
		"grid_size": Vector2(11,11),
		"mines": [20, 20],
		"facts": [
			"War-torn since 1979",
			"1,700+ communities at risk",
			"Tops global mine casualty list",
			"45,000+ civilian losses since 1989"
		],
		"helper": {
			"name": "HALO Trust Deminer",
			"icon": "🚩",
			"effect": "Flag 3 random mines",
			"description": "Since 1988, HALO Trust’s 2,000+ Afghan staff have cleared 1,346 km², equal to 20,000 football pitches, enabling safe farming and rebuilding despite 2021 attacks."
		},
		"global": {
			"medic_kit": "Gain 1 extra life",
			"coop_reveal": "Partner reveals 4 cells for you",
			"send_mine": "Send 2 of your mines to partner's board"
		}
	},
	5: {
		"country": "Angola",
		"grid_size": Vector2(12,12),
		"mines": [25, 25],
		"facts": [
			"Relics of 1975–2002 civil war",
			"Cripples farming and trade",
			"Over 88,000 mine victims since 1994",
			"Princess Diana’s 1997 spotlight"
		],
		"helper": {
			"name": "MAG Demining Expert",
			"icon": "🦺",
			"effect": "Reveal 5 random safe cells",
			"description": "MAG has cleared 10M m² in Angola since 1994, equal to 1,400 football pitches, in Lunda Norte, Sul, and Moxico, aiding farming and community recovery."
		},
		"global": {
			"medic_kit": "Gain 2 extra lives",
			"coop_reveal": "Partner reveals 5 cells for you",
			"send_mine": "Send 2 of your mines to partner's board"
		}
	},
	6: {
		"country": "Vietnam",
		"grid_size": Vector2(13,13),
		"mines": [30, 30],
		"facts": [
			"Vietnam War’s deadly leftovers",
			"~6.3 million hectares hazardous",
			"Over 100,000 casualties post-war",
			"U.S. aids UXO cleanup efforts"
		],
		"helper": {
			"name": "Project RENEW Technician",
			"icon": "🕊️",
			"effect": "Reveal 6 random safe cells",
			"description": "In Quang Tri, Project RENEW has removed 105,000+ UXOs since 2008, educating communities and aiding victims with prosthetics for safer lives."
		},
		"global": {
			"medic_kit": "Gain 2 extra lives",
			"coop_reveal": "Partner reveals 5 cells for you",
			"send_mine": "Send 2 of your mines to partner's board"
		}
	},
	7: {
		"country": "Ukraine",
		"grid_size": Vector2(14,14),
		"mines": [35, 35],
		"facts": [
			"Spiked by 2022 Russian invasion",
			"Over 2,100 km² contaminated",
			"Fields and towns booby-trapped",
			"Fastest-growing mine crisis"
		],
		"helper": {
			"name": "Clearance Robot",
			"icon": "🤖",
			"effect": "Reveal safe cells in a random 4x4 area",
			"description": "Robots like Uran-6 and Gnome Kamikaze clear mines in Ukraine’s conflict zones, reducing risks despite challenges like equipment losses."
		},
		"global": {
			"medic_kit": "Gain 2 extra lives",
			"coop_reveal": "Partner reveals 6 cells for you",
			"send_mine": "Send 3 of your mines to partner's board"
		}
	},
	8: {
		"country": "Iraq",
		"grid_size": Vector2(15,15),
		"mines": [40, 40],
		"facts": [
			"Legacy from wars since 1980s",
			"~2,100 km² contaminated",
			"Stalls rebuilding and growth",
			"ISIS left deadly traps"
		],
		"helper": {
			"name": "UNMAS Specialist",
			"icon": "👷",
			"effect": "Flag 4 random mines",
			"description": "UNMAS cleared 2,500+ ERW and 87 IEDs in Iraq in 2024, training police, including women, to safely rebuild communities."
		},
		"global": {
			"medic_kit": "Gain 2 extra lives",
			"coop_reveal": "Partner reveals 6 cells for you",
			"send_mine": "Send 3 of your mines to partner's board"
		}
	},
	9: {
		"country": "Somalia",
		"grid_size": Vector2(16,16),
		"mines": [45, 45],
		"facts": [
			"Instability since early 1990s",
			"Contamination hinders recovery",
			"Impacts pastoral communities",
			"Conflict blocks demining"
		],
		"helper": {
			"name": "DDG Demining Team",
			"icon": "🚧",
			"effect": "Reveal 8 random safe cells",
			"description": "Since 1999, DDG clears mines in Somalia’s Somaliland and Puntland, using manual and mechanical methods to aid community safety."
		},
		"global": {
			"medic_kit": "Gain 3 extra lives",
			"coop_reveal": "Partner reveals 7 cells for you",
			"send_mine": "Send 4 of your mines to partner's board"
		}
	},
	10: {
		"country": "Laos",
		"grid_size": Vector2(17,17),
		"mines": [50, 50],
		"facts": [
			"Most bombed country per capita",
			"80 million unexploded bombs",
			"Impacts rural economy, safety",
			"Casualties high despite efforts"
		],
		"helper": {
			"name": "UXO Laos Team",
			"icon": "🎖️",
			"effect": "Reveal 10 random safe cells",
			"description": "UXO Lao, since 1996, clears 80M bombs in Laos, surveying and educating to make land safe, with a century-long task ahead."
		},
		"global": {
			"medic_kit": "Gain 3 extra lives",
			"coop_reveal": "Partner reveals 7 cells for you",
			"send_mine": "Send 4 of your mines to partner's board"
		}
	},
	11: {
		"country": "South Sudan",
		"grid_size": Vector2(18,18),
		"mines": [55, 55],
		"facts": [
			"Decades of civil conflict",
			"Over 5,000 casualties since 2004",
			"Blocks development, stability",
			"International demining aid ongoing"
		],
		"helper": {
			"name": "UNMAS Peacekeeper",
			"icon": "⛑️",
			"effect": "Flag 5 random mines",
			"description": "UNMAS peacekeepers with UNMISS clear mines in South Sudan, protecting civilians and enabling safe humanitarian access."
		},
		"global": {
			"medic_kit": "Gain 3 extra lives",
			"coop_reveal": "Partner reveals 8 cells for you",
			"send_mine": "Send 4 of your mines to partner's board"
		}
	}
}

var global_tools = {
	"medic_kit": {
		"name": "Medic Kit",
		"icon": "🩺",
		"description": "Emergency care saves deminers’ lives."
	},
	"coop_reveal": {
		"name": "Helping Hand",
		"icon": "🤝",
		"description": "Partner risks life to reveal cells for you."
	},
	"send_mine": {
		"name": "Conflict Surge",
		"icon": "💣",
		"description": "Sharing is caring - send your mines to partner's board (fineprint: they get 1 extra life for every 2 mines you send though.)"
	}
}

func get_level_data(level_number):
	var level = levels.get(level_number, null)
	if level:
		level["background"] = "res://game files/ui_board/assets/backgrounds/%s.png" % level.country
		level["map"] = "res://game files/ui_board/assets/maps/%s.png" % level.country
		
		var tools = []
		
		for key in global_tools.keys():
			var global_tool = global_tools[key]
			var effect_description = level.global.get(key, "")
			if effect_description:
				tools.append({
					"type": key,
					"name": global_tool.name,
					"icon": global_tool.icon,
					"effect": effect_description,
					"description": global_tool.description
				})

		var helper = level.get("helper")
		if helper:
			tools.append({
				"type": "helper",
				"name": helper.name,
				"icon": helper.icon,
				"effect": helper.effect,
				"description": helper.description
			})
		
		level["tools"] = tools
		
	return level
