extends Control



#@export var board_size: float = 512 ## The size of one side of the square board, in pixels. can be any float, although decimals may mess it up
@export var grid_size: int = 8 ## The number of cells to a side of the board. Will create a square with grid_size^2 total cells
#var cell_scale: float
const cell_sprite_size: float = 64 ## should not be changed unless the sprites are changed, otherwise set it to the size of a grid cell

@export var num_mines: int = 16 ## The number of mines to start the board with. Default is 16

@export var player_num: int = 1 ## The player number. Can be 1 or 2.
var player_tag = "p" + str(player_num) + "_"

@onready var cell_manager: GridContainer = $"cell manager container/cell manager"

@onready var selector: TextureRect = $selector
var selector_grid_position: Vector2 = Vector2(0,0)

var intitial_mines_made = false

func _ready() -> void:
	player_tag = "p" + str(player_num) + "_"
	cell_manager.create_grid(grid_size)


func move_selector(dir):
	if cell_manager.cell_dict.get(selector_grid_position + dir) != null:
		selector_grid_position += dir
		selector.position +=  cell_manager.get_child(0, true).size * dir

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(player_tag + "up"): move_selector(Vector2(0,-1))
	if Input.is_action_just_pressed(player_tag + "down"): move_selector(Vector2(0,1))
	if Input.is_action_just_pressed(player_tag + "left"): move_selector(Vector2(-1,0))
	if Input.is_action_just_pressed(player_tag + "right"): move_selector(Vector2(1,0))

	if Input.is_action_just_pressed(player_tag + "mark"): cell_manager.mark(selector_grid_position)
	if Input.is_action_just_pressed(player_tag + "clear"):
		if !intitial_mines_made:
			var exclusions = cell_manager.get_cell_neighbors(selector_grid_position)
			exclusions.append(cell_manager.cell_dict[selector_grid_position])
			cell_manager.create_mines(num_mines, exclusions)
			intitial_mines_made = true
		cell_manager.cell_dict[selector_grid_position].reveal()
	selector.size = cell_manager.get_child(0).size
	selector.position = selector_grid_position * selector.size
