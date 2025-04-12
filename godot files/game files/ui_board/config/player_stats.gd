extends Resource

class_name PlayerStats

var lives = 3
var flagged = 0
var moves = 0
var cleared = 0
var efficiency = 0

var n_cells = 64

func _init(total_cells: int, starting_lives: int = 3):
	n_cells = total_cells
	lives = starting_lives

func update(n_revealed_non_mines: int, n_flagged: int):
	flagged = n_flagged
	cleared = int(100.0 * n_revealed_non_mines / n_cells)
	efficiency = 0 if moves == 0 else int(float(cleared) / moves)
	
