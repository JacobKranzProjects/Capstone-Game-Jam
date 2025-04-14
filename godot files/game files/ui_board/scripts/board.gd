extends Control

signal has_mine_triggered(board, by_partner)
signal has_cell_revealed(board, by_partner)
signal request_partner_control(requesting_board)

@export var player_num: int = 1 ## The player number. Can be 1 or 2.
var player_tag = "p" + str(player_num) + "_"

@onready var cell_manager: GridContainer = $"cell manager container/cell manager"
@onready var cell_manager_container: HBoxContainer = $"cell manager container"
#@onready var selector: TextureRect = $selector
@onready var instructions: Label = $instructions
#var selector_grid_position: Vector2 = Vector2(0,0)

var selectors = {}
var selector_grid_positions = {}

var intitial_mines_made = false
var PADDING = 40
var level_settings = Settings.new()
var level_data
var player_stats

var input_enabled = true

func _ready():
	player_tag = "p" + str(player_num) + "_"
	selectors = {'p1_': $selector1, 'p2_': $selector2}
	selectors['p2_'].modulate = Color(1, 0.4, 0.4) # orange
	selectors[player_tag].visible = true

func setup_board(board_size, data, powerup, life_change, is_dummy=false):
	anchors_preset = PRESET_TOP_LEFT
	size = board_size
	level_data = data
	var grid_size = level_data.grid_size.x
	var min_cell_size = 5 if is_dummy else 20
	var max_cell_size = 48
	
	var available_size = min(size.x, size.y) - PADDING
	var cell_size = clamp(floor(available_size / grid_size), min_cell_size, max_cell_size)
	
	cell_manager.columns = grid_size
	cell_manager.custom_minimum_size = Vector2(cell_size, cell_size) * grid_size
	cell_manager.create_grid(grid_size, cell_size)
	await get_tree().process_frame

	cell_manager.position = (size - cell_manager.size) / 2

	# Initial grid positions per selector
	selector_grid_positions["p1_"] = Vector2(0,0)
	selector_grid_positions["p2_"] = Vector2(0,0)

	# Set initial position
	update_selector_position("p1_")
	update_selector_position("p2_")
	
	player_stats = PlayerStats.new(grid_size * grid_size, powerup)
	player_stats.lives += life_change
	if player_stats.tool:
		setup_instructions()
	
	selectors[player_tag].visible = not is_dummy
	instructions.visible = not is_dummy
	
func update_selector_position(tag):
	selectors[tag].size = cell_manager.get_child(0).size
	selectors[tag].position = cell_manager_container.position + cell_manager.position + selector_grid_positions[tag] * selectors[tag].size

func move_selector(tag, dir):
	var new_pos = selector_grid_positions[tag] + dir
	if cell_manager.cell_dict.get(new_pos):
		selector_grid_positions[tag] = new_pos
		update_selector_position(tag)

func _process(_delta: float) -> void:
	if not input_enabled:
		return
	
	for tag in selectors.keys():
		if selectors[tag].visible:
			if Input.is_action_just_pressed(tag + "up"): move_selector(tag, Vector2(0,-1))
			if Input.is_action_just_pressed(tag + "down"): move_selector(tag, Vector2(0,1))
			if Input.is_action_just_pressed(tag + "left"): move_selector(tag, Vector2(-1,0))
			if Input.is_action_just_pressed(tag + "right"): move_selector(tag, Vector2(1,0))

			if Input.is_action_just_pressed(tag + "mark"):
				cell_manager.mark(selector_grid_positions[tag])
				player_stats.moves += 1
				$action.play()
				update_stats()
			
			if Input.is_action_just_pressed(tag + "clear"):
				if !intitial_mines_made:
					var exclusions = cell_manager.get_cell_neighbors(selector_grid_positions[tag])
					exclusions.append(cell_manager.cell_dict[selector_grid_positions[tag]])
					cell_manager.create_mines(level_data.mines[player_num-1], exclusions)
					intitial_mines_made = true
				cell_manager.cell_dict[selector_grid_positions[tag]].reveal(tag != player_tag)
				player_stats.moves += 1
				$action.play()
				update_stats()
				
	if Input.is_action_just_pressed(player_tag + "powerup"):
		if player_stats.tool_used:
			return
		$action.play()
		activate_powerup()
	
func _on_mine_triggered(by_partner: bool):
	$mine.play()
	emit_signal("has_mine_triggered", self, by_partner)

func _on_cell_revealed(by_partner: bool):
	update_stats()
	emit_signal("has_cell_revealed", self, by_partner)

func update_stats():
	# find out how many cells are revealed & not mines, and how many are flagged
	var n_revealed = 0
	var n_flagged = 0
	for cell in cell_manager.cell_dict.values():
		if cell.revealed:
			n_revealed += 1
		elif cell.is_marked:
			n_flagged += 1
	player_stats.update(n_revealed, n_flagged)

func setup_instructions():
	# Set instructions dynamically based on player number
	if player_num == 1:
		instructions.text = '"WASD":Move | "Q":Clear | "E":Flag'
		if not player_stats.tool_used:
			instructions.text += ' | "Z":' + player_stats.tool.icon
	else:
		instructions.text = '"IJKL":Move | "U":Clear | "O":Flag'
		if not player_stats.tool_used:
			instructions.text += ' | "M":' + player_stats.tool.icon
	# Match width to grid and horizontally center
	instructions.size.x = cell_manager.size.x
	instructions.position.x = cell_manager.position.x
	instructions.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	# Position directly below the grid
	instructions.position.y = cell_manager.position.y + cell_manager.size.y + 3

func activate_powerup():
	# Generate mines first if they haven't been created yet
	if !intitial_mines_made:
		var initial_pos = selector_grid_positions[player_tag]
		var exclusions = cell_manager.get_cell_neighbors(initial_pos)
		exclusions.append(cell_manager.cell_dict[initial_pos])
		cell_manager.create_mines(level_data.mines[player_num-1], exclusions)
		intitial_mines_made = true
	
	if player_stats.tool.effect.ends_with("area"):
		# Reveal safe cells in a random NxN area
		var area = int(player_stats.tool.effect.split("random ")[1][0])
		reveal_safe_cells_in_area(area)
	elif player_stats.tool.effect.ends_with("random safe cells"):
		# Reveal n random safe cells
		var cell_count = int(player_stats.tool.effect.split("Reveal ")[1].split(" ")[0])
		reveal_n_random_safe_cells(cell_count)
	elif player_stats.tool.effect.begins_with("Flag "):
		var mine_count = int(player_stats.tool.effect.split("Flag ")[1].split(" ")[0])
		flag_n_random_mines(mine_count)
	elif player_stats.partner_reveal > 0:
		emit_signal("request_partner_control", self)
		
	player_stats.tool_used = true
	setup_instructions()

func reveal_n_random_safe_cells(n: int):
	var cells = []
	for cell in cell_manager.cell_dict.values():
		if not cell.revealed and not cell.is_mine:
			cells.append(cell)

	cells.shuffle()

	var old = player_stats.cleared
	var target_cleared = min(old + n, 100)
	
	var idx = 0
	while player_stats.cleared < target_cleared and idx < cells.size():
		var cell = cells[idx]
		idx += 1
		if not cell.revealed:
			cell.reveal(false)
			update_stats()
	
	print('%d cells cleared by the powerup tool' % (player_stats.cleared - old))

func reveal_safe_cells_in_area(area_size: int):
	var max_start = level_data.grid_size.x - area_size
	var candidate_areas = []
	var old = player_stats.cleared

	for x in range(max_start + 1):
		for y in range(max_start + 1):
			var safe_cells = []
			for dx in range(area_size):
				for dy in range(area_size):
					var pos = Vector2(x + dx, y + dy)
					var cell = cell_manager.cell_dict.get(pos)
					if cell and not cell.revealed and not cell.is_mine:
						safe_cells.append(cell)
			if safe_cells.size() > 0:
				candidate_areas.append(safe_cells)

	if candidate_areas.is_empty():
		print("No suitable safe area available!")
		return

	var selected_area = candidate_areas.pick_random()
	for cell in selected_area:
		cell.reveal(false)

	update_stats()
	print('%d cells revealed by the powerup tool' % (player_stats.cleared - old))
	
func flag_n_random_mines(n: int):
	var unflagged_mines = []
	for cell in cell_manager.cell_dict.values():
		if cell.is_mine and not cell.is_marked and not cell.revealed:
			unflagged_mines.append(cell)

	if unflagged_mines.size() == 0:
		print("No unflagged mines available!")
		return

	unflagged_mines.shuffle()
	var mines_to_flag = unflagged_mines.slice(0, min(n, unflagged_mines.size()))
	for mine_cell in mines_to_flag:
		mine_cell.mark()
	
	update_stats()
