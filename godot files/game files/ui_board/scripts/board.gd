extends Control



#@export var board_size: float = 512 ## The size of one side of the square board, in pixels. can be any float, although decimals may mess it up
#@export var grid_size: int = 8 ## The number of cells to a side of the board. Will create a square with grid_size^2 total cells
#var cell_scale: float
#const cell_sprite_size: float = 64 ## should not be changed unless the sprites are changed, otherwise set it to the size of a grid cell

#@export var num_mines: int = 16 ## The number of mines to start the board with. Default is 16

@export var player_num: int = 1 ## The player number. Can be 1 or 2.
var player_tag = "p" + str(player_num) + "_"

@onready var cell_manager: GridContainer = $"cell manager container/cell manager"
@onready var cell_manager_container: HBoxContainer = $"cell manager container"
@onready var selector: TextureRect = $selector
var selector_grid_position: Vector2 = Vector2(0,0)

var intitial_mines_made = false
var PADDING = 40
var level_settings = Settings.new()
var level_data
var player_stats

func _ready() -> void:
	player_tag = "p" + str(player_num) + "_"
	#cell_manager.create_grid(grid_size)
	level_data = level_settings.get_level_data(5)
	setup_board(size, level_data)

func setup_board(board_size, data):
	size = board_size
	level_data = data
	var grid_size = level_data.grid_size.x
	
	var available_size = min(size.x, size.y) - PADDING
	var cell_size = clamp(floor(available_size / grid_size), 20, 48)

	cell_manager.columns = grid_size
	cell_manager.custom_minimum_size = Vector2(cell_size, cell_size) * grid_size
	cell_manager.create_grid(grid_size, cell_size)
	await get_tree().process_frame

	cell_manager.position = (size - cell_manager.size) / 2
	selector.size = Vector2(cell_size, cell_size)
	selector_grid_position = Vector2(0, 0) 
	if player_num == 2:
		selector.modulate = Color(1, 0.4, 0.4)
	update_selector_position()
	
	player_stats = PlayerStats.new(grid_size * grid_size, 3)

func update_selector_position():
	selector.size = cell_manager.get_child(0).size
	selector.position = cell_manager_container.position + cell_manager.position + selector_grid_position * selector.size

func move_selector(dir):
	var new_pos = selector_grid_position + dir
	if cell_manager.cell_dict.get(new_pos):
		selector_grid_position = new_pos
		update_selector_position()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(player_tag + "up"): move_selector(Vector2(0,-1))
	if Input.is_action_just_pressed(player_tag + "down"): move_selector(Vector2(0,1))
	if Input.is_action_just_pressed(player_tag + "left"): move_selector(Vector2(-1,0))
	if Input.is_action_just_pressed(player_tag + "right"): move_selector(Vector2(1,0))

	if Input.is_action_just_pressed(player_tag + "mark"): 
		cell_manager.mark(selector_grid_position)
		player_stats.moves += 1
		update_stats()
	
	if Input.is_action_just_pressed(player_tag + "clear"):
		if !intitial_mines_made:
			var exclusions = cell_manager.get_cell_neighbors(selector_grid_position)
			exclusions.append(cell_manager.cell_dict[selector_grid_position])
			cell_manager.create_mines(level_data.mines, exclusions)
			intitial_mines_made = true
		cell_manager.cell_dict[selector_grid_position].reveal()
		player_stats.moves += 1
		update_stats()

func _on_mine_triggered():
	player_stats.lives -= 1
	update_stats()
	
	if player_stats.lives <= 0:
		print('Player %d game over!' % player_num)
		# TODO: trigger game-over stuff

func update_stats():
	# find out how many cells are revealed & not mines, and how many are flagged
	var n_revealed = 0
	var n_flagged = 0
	for cell in cell_manager.cell_dict.values():
		if cell.revealed and not cell.is_mine:
			n_revealed += 1
		elif cell.is_marked:
			n_flagged += 1
	player_stats.update(n_revealed, n_flagged)
