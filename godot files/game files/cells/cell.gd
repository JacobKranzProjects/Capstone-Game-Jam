extends AnimatedSprite2D

var revealed = false
var is_marked = false
var number
var is_mine

var grid_position

func _ready() -> void:
	update()

func mark():
	is_marked = !is_marked
	update()
	

func reveal():
	if revealed: return
	revealed = true
	if is_mine:
		trigger_loss()
		return
	update()
	if number == 0 and !is_mine:
		for cell in get_parent().get_cell_neighbors(grid_position):
			cell.reveal()


func update():
	number = 0
	for cell in get_parent().get_cell_neighbors(grid_position): # get the sum of mines in neighbors
		if cell.is_mine:
			number += 1
	if revealed and !is_mine: frame = number
	elif !revealed and !is_marked: frame = 9 # frame 9 is the un revealed one
	elif revealed and is_mine: frame = 10
	elif !revealed and is_marked: frame = 11 # frame 11 is the flag

func trigger_loss():
	update()
	print("trigger a loss here")
