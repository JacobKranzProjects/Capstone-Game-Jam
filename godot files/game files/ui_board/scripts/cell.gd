extends TextureRect


var revealed = false
var is_marked = false
var number
var is_mine = false

var grid_position
var cell_size = 64  # default, overridden from cell manager

func _ready() -> void:
	var current_texture = sprite_frames.get_frame_texture(animation, frame)
	var texture_size = current_texture.get_size()
	scale = Vector2(cell_size / texture_size.x, cell_size / texture_size.y)
	update()

func mark():
	is_marked = !is_marked
	update()
	

func reveal():
	if is_marked: return
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
	
	if revealed and !is_mine:
		if 1<=number and number<=8: texture.region = Rect2(((number-1)%4)*64,floor((number-1)/4)*64,64,64) # first two rows of numbers
		elif number == 0: texture.region = Rect2(0,128,64,64) # empty number
	elif !revealed and !is_marked: texture.region = Rect2(64,128,64,64) # unknown cell
	elif revealed and is_mine: texture.region = Rect2(128,128,64,64) # mine
	elif !revealed and is_marked: texture.region = Rect2(192,128,64,64) # flag


func trigger_loss():
	update()
	print("trigger a loss here")
