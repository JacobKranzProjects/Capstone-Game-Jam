extends AnimatedSprite2D

var revealed = false
var number
var is_mine

var grid_position

func _ready() -> void:
	update()



func reveal():
	if revealed: return
	revealed = true
	update()
	if number == 0:
		for cell in get_parent().get_cell_neighbors(grid_position):
			cell.reveal()


func update():
	number = 0
	for cell in get_parent().get_cell_neighbors(grid_position): # get the sum of mines in neighbors
		if cell.is_mine:
			number += 1
	if revealed and !is_mine: frame = number
	elif revealed and is_mine: frame = 10
	else: frame = 9 # frame 9 is the un revealed one
