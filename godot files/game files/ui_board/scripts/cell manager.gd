extends GridContainer

var cell_scene = preload("res://game files/ui_board/scenes/cell.tscn")
var cell_dict = {}


func _ready() -> void:
	pass

# excludes existing mines and any cells in exclude_cells
func create_mines(num_mines, exclude_cells): 
	var valid_cells = []
	for cell in cell_dict.values():
		if !cell.is_mine and cell not in exclude_cells:
			valid_cells.append(cell)
	if num_mines > valid_cells.size(): num_mines = valid_cells.size() # check to make sure we dont add too many mines
	valid_cells.shuffle() # randomize valid positions
	for i in num_mines: # now make a mine in the first 'num_mines' cells
		valid_cells[i].is_mine = true
		valid_cells[i].update()



func create_grid(grid_size, cell_size):
	# Clear existing grid if reloading
	for existing_cell in get_children():
		existing_cell.queue_free()
	cell_dict.clear()
		
	columns = grid_size
	for i in grid_size:
		for j in grid_size:
			var new_cell = cell_scene.instantiate() # Instantiate cell
			new_cell.grid_position = Vector2(j,i) # set cell grid position
			new_cell.custom_minimum_size = Vector2(cell_size, cell_size)
			
			new_cell.mine_triggered.connect(get_parent().get_parent()._on_mine_triggered)
			
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


func mark(cell_position):
	cell_dict[cell_position].mark()
