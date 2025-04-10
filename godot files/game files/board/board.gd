extends Node2D

const WINDOW_SIZE = Vector2(1280, 720)
const SIDE_PANEL_WIDTH = 400
const SIDE_PANEL_SPACING = 5
const MIN_CELL_SIZE = 20
const MAX_CELL_SIZE = 64
const MAP_MARGIN = 15
const MAP_HEIGHT = SIDE_PANEL_WIDTH * 0.6

# Select the current level number (can also be set dynamically)
@export var current_level: int = 1

var level_settings = Settings.new()
var level_data

func _ready():
	# Retrieve level data from level_settings
	level_data = level_settings.get_level_data(current_level)
	if level_data:
		setup_board(level_data)
		
		# Initialize Player 1 Selector
		$selector_p1.scale_selector()
		$selector_p1.update_selector_position()

		# Initialize Player 2 Selector
		$selector_p2.scale_selector()
		$selector_p2.update_selector_position()
	else:
		push_error("Level data not found for level %d" % current_level)

	setup_overlay_instructions()


func setup_board(data):
	# Set fixed window size
	DisplayServer.window_set_size(WINDOW_SIZE)
	
	# Calculate available board area size (subtracting side panel width and margins)
	var available_width = WINDOW_SIZE.x - SIDE_PANEL_WIDTH - 40 # padding on each side
	var available_height = WINDOW_SIZE.y - 40 # top/bottom padding
	
	var grid_x = data.grid_size.x
	var grid_y = data.grid_size.y
	
	# Calculate ideal cell size based on available space
	var cell_size_x = available_width / grid_x
	var cell_size_y = available_height / grid_y
	
	# Choose the smaller of the two to ensure grid fits within available space
	var cell_size = min(cell_size_x, cell_size_y)
	
	# Clamp cell size between min and max to prevent extreme visuals
	cell_size = clamp(cell_size, MIN_CELL_SIZE, MAX_CELL_SIZE)
	
	# Setup cell manager accordingly
	var cell_manager = $"cell manager"
	cell_manager.cell_size = cell_size
	cell_manager.width = grid_x
	cell_manager.height = grid_y
	cell_manager.mines = data.mines
	cell_manager.create_grid()
	
	# Dynamically position and center the board/grid vertically and horizontally
	position_board(grid_x, grid_y, cell_size)
	
	# Setup side panel with fixed size and formatting
	position_side_panel()
	
	# Update side-panel content
	$"side panel/map".texture = load(data.map)
	update_facts_label(data)
	
	# Background sizing & positioning clearly here:
	setup_background(data)

func position_board(grid_x, grid_y, cell_size):
	var cell_manager = $"cell manager"
	
	var total_grid_width = grid_x * cell_size
	var total_grid_height = grid_y * cell_size
	
	var board_area_width = WINDOW_SIZE.x - SIDE_PANEL_WIDTH
	var board_area_height = WINDOW_SIZE.y
	
	# Center board horizontally and vertically within the available area
	var board_x = (board_area_width - total_grid_width) / 2
	var board_y = (board_area_height - total_grid_height) / 2
	
	cell_manager.position = Vector2(board_x, board_y)

func position_side_panel():
	var side_panel = $"side panel"
	side_panel.position = Vector2(WINDOW_SIZE.x - SIDE_PANEL_WIDTH, 0)
	side_panel.custom_minimum_size = Vector2(SIDE_PANEL_WIDTH, WINDOW_SIZE.y)
	
	# fixed layout for side panel nodes
	var map_node = side_panel.get_node("map")
	map_node.position = Vector2(MAP_MARGIN, MAP_MARGIN)
	map_node.custom_minimum_size = Vector2(SIDE_PANEL_WIDTH - MAP_MARGIN * 2, MAP_HEIGHT)

	var facts_node = side_panel.get_node("facts")
	var facts_margin_top = MAP_MARGIN * 2 + MAP_HEIGHT
	facts_node.position = Vector2(MAP_MARGIN, facts_margin_top)
	facts_node.custom_minimum_size = Vector2(SIDE_PANEL_WIDTH - MAP_MARGIN*2, WINDOW_SIZE.y - facts_margin_top - MAP_MARGIN)
	facts_node.add_theme_font_size_override("normal_font_size", 22)
	facts_node.add_theme_constant_override("line_separation", 8)
	facts_node.add_theme_constant_override("content_margin_left", 5)
	facts_node.add_theme_constant_override("content_margin_top", 5)
	facts_node.add_theme_constant_override("content_margin_right", 5)
	facts_node.add_theme_constant_override("content_margin_bottom", 5)
	
func update_facts_label(data):
	var facts_formatted = "[b]%s[/b]\n" % data.country
	for fact in data.facts:
		facts_formatted += "• %s\n" % fact

	var facts_node = $"side panel/facts"
	facts_node.bbcode_enabled = true
	facts_node.text = facts_formatted

func setup_background(data):
	var bg_node = $background
	var bg_width = WINDOW_SIZE.x - SIDE_PANEL_WIDTH - SIDE_PANEL_SPACING
	var bg_height = WINDOW_SIZE.y

	bg_node.position = Vector2(0, 0) # top-left corner
	bg_node.size = Vector2(bg_width, bg_height)
	bg_node.stretch_mode = TextureRect.STRETCH_SCALE # ensures texture fills size
	
	# Set up the transparent country overlay
	bg_node.texture = load(data.background)
	bg_node.modulate = Color(1, 1, 1, 0.3)

func setup_overlay_instructions():
	var instructions_node = $instructions
	var instructions_text = "[color=yellow]Player1 [/color] Move: WASD | Reveal: E | Mark: Q     "
	instructions_text += "[color=orange]Player2 [/color] Move: IJKL | Reveal: O | Mark: U"
	instructions_node.bbcode_enabled = true
	instructions_node.text = instructions_text
	instructions_node.position = Vector2(60, WINDOW_SIZE.y - 30)
	instructions_node.add_theme_font_size_override("normal_font_size", 18)
	instructions_node.add_theme_constant_override("line_separation", 2)
	instructions_node.add_theme_color_override("default_color", Color.WHITE)
