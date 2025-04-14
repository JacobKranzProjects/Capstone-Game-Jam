extends Resource
class_name PlayerStats

var lives: int = 1
var flagged: int = 0
var moves: int = 0
var cleared: int = 0
var efficiency: int = 0
var n_cells: int = 64

var tool = null
var tool_used = false
var partner_reveal = 0

func _init(total_cells: int, selected_tool=null):
	n_cells = total_cells
	tool = selected_tool
	
	if tool:
		match tool.name:
			"Medic Kit":
				lives += int(tool.effect.split(" ")[1])
				tool_used = true
			"Conflict Surge":
				tool_used = true
			"Helping Hand":
				# Partner reveals n cells for you
				partner_reveal = int(tool.effect.split(" ")[2])

func update(n_revealed: int, n_flagged: int):
	flagged = n_flagged
	cleared = int(100.0 * (n_revealed + n_flagged) / n_cells)
	efficiency = 0 if moves == 0 else int(float(cleared) / moves)
	
