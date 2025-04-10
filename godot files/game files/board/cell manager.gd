extends Node2D

@export var width = 8
@export var height = 8
@export var mines = 16
@export var cell_size = 64

var cell = preload("res://game files/cells/cell.tscn")
var cell_dict = {}

func _ready() -> void:
	#create_grid()
	pass

func create_mines(num_mines=mines, can_spawn_selected=false):
	var valid_positions = []
	for key in cell_dict.keys(): # get the list of valid positions
		if !cell_dict[key].is_mine and (can_spawn_selected or key != $"../selector".grid_position):
			valid_positions.append(key)
	if num_mines > valid_positions.size(): num_mines = valid_positions.size() # check to make sure we dont add too many mines
	valid_positions.shuffle() # randomize valid positions
	for i in num_mines: # now make a mine in the first 'num_mines' positions
		cell_dict[valid_positions[i]].is_mine = true
		cell_dict[valid_positions[i]].update()

func create_grid():
	# Clear existing grid if reloading
	for existing_cell in get_children():
		existing_cell.queue_free()
	cell_dict.clear()
	
	for i in width:
		for j in height:
			var new_cell = cell.instantiate() # Instantiate cell
			new_cell.position = Vector2(i+0.5,j+0.5) * cell_size # set cell screen position
			new_cell.grid_position = Vector2(i,j) # set cell grid position
			new_cell.cell_size = cell_size
			cell_dict[new_cell.grid_position] = new_cell # add cell address to dictionary
			add_child(new_cell) # add the cell as a child


func get_cell_neighbors(grid_position):
	var neighbors = [
		Vector2(-1,-1),Vector2(0,-1),Vector2(1,-1), # this is a grid of relative neighbor positions
		Vector2(-1, 0),              Vector2(1, 0), # we can use and edit it to easily get the list of neighbors
		Vector2(-1, 1),Vector2(0, 1),Vector2(1, 1)
	]
	for index in [7,6,5,4,3,2,1,0]: # we loop backwards to not shift indexes when removing null elements
		neighbors[index] += grid_position # get grid position based on relative one
		neighbors[index] = cell_dict.get(neighbors[index]) # set element to neighbor address
		if neighbors[index] == null: neighbors.remove_at(index) # if element is null (borders for example), then we remove it from the list
	return neighbors # return list
	
	
