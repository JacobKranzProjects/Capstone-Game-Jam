extends TextureRect

signal mine_triggered(by_partner: bool)
signal cell_revealed(by_partner: bool)

var revealed = false
var is_marked = false
var number
var is_mine = false

var grid_position

func _ready() -> void:
	update()

func mark():
	is_marked = !is_marked
	update()
	

func reveal(by_partner: bool = false):
	if is_marked: return
	if revealed: return
	revealed = true
	if is_mine:
		trigger_loss(by_partner)
		return
	update()
	cell_revealed.emit(by_partner)
	if number == 0 and !is_mine:
		for cell in get_parent().get_cell_neighbors(grid_position):
			cell.reveal(by_partner)


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


func trigger_loss(by_partner: bool = false):
	update()
	mine_triggered.emit(by_partner)
	print("trigger a loss here - by_partner=" + str(by_partner))
