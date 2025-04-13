extends Control

const WINDOW_SIZE = Vector2(1280, 720)
const INFO_PANEL_HEIGHT = 160
const STAT_PANEL_WIDTH = 150
const BOARD_PADDING = 10

@onready var board1 = $VBoxContainer/BoardContainer/board1
@onready var board2 = $VBoxContainer/BoardContainer/board2
@onready var info_panel = $VBoxContainer/info
@onready var stat_panel = $VBoxContainer/BoardContainer/stats
@onready var background = $VBoxContainer/BoardContainer/Background

var level_settings = Settings.new()
var level_data
var helping_hand_state = null

func _ready():
	DisplayServer.window_set_size(WINDOW_SIZE)
	size = WINDOW_SIZE
	
	stat_panel.start_timer()
	
	level_data = level_settings.get_level_data(GameState.selected_level)
	if level_data:
		setup_background(level_data)
		setup_layout(level_data)
	else:
		push_error("No data found for level: %d" % GameState.selected_level)
	
func setup_background(data):
	background.texture = load(data.background)
	background.modulate = Color(1, 1, 1, 0.3)
	background.size = $VBoxContainer/BoardContainer.size

func setup_layout(data):
	info_panel.custom_minimum_size = Vector2(WINDOW_SIZE.x, INFO_PANEL_HEIGHT)
	info_panel.setup_panel(data)

	var available_width = floor((WINDOW_SIZE.x - STAT_PANEL_WIDTH - 4 * BOARD_PADDING) / 2)
	var available_height = WINDOW_SIZE.y - INFO_PANEL_HEIGHT
	var board_size = Vector2(available_width, available_height)
	
	var p1_tool = GameState.selected_tool_p1
	var p2_tool = GameState.selected_tool_p2
	var send_mine = 0
	if p1_tool.name == "Conflict Surge":
		send_mine = int(p1_tool.effect.split(" ")[1])
	if p2_tool.name == "Conflict Surge":
		send_mine -= int(p2_tool.effect.split(" ")[1])
	if send_mine != 0:
		data["mines"][0] -= send_mine
		data["mines"][1] += send_mine
	
	board1.setup_board(board_size, data, p1_tool)
	board2.setup_board(board_size, data, p2_tool)

	stat_panel.custom_minimum_size = Vector2(STAT_PANEL_WIDTH, available_height)
	stat_panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	stat_panel.size_flags_vertical = Control.SIZE_SHRINK_CENTER

func _process(_delta):
	background.size = $VBoxContainer/BoardContainer.size
	stat_panel.refresh_stats(board1.player_stats, board2.player_stats)
	
func end_game():
	stat_panel.stop_timer()

func activate_partner_control(requester_board):
	var partner_board = board2 if requester_board == board1 else board1
	print("Activating partner control for ", requester_board.name)

	# Enable partner's selector on requester's board
	requester_board.selectors[partner_board.player_tag].visible = true
	requester_board.selector_grid_positions[partner_board.player_tag] = Vector2(0, 0)
	requester_board.update_selector_position(partner_board.player_tag)

	# Temporarily disable partner board controls
	partner_board.input_enabled = false
	partner_board.selectors['p1_'].visible = false
	partner_board.selectors['p2_'].visible = false

	# Track this temporary state
	helping_hand_state = {
		"requester_board": requester_board,
		"partner_board": partner_board,
		"partner_reveal": requester_board.player_stats.partner_reveal
	}
	
	# Instructions update for clarity
	partner_board.instructions.text = "HELPING HAND: reveal %d cells on the other board!" % requester_board.player_stats.partner_reveal

func on_board_mine_triggered(board, by_partner):
	if by_partner and helping_hand_state:
		# Partner loses a life instead of requester
		helping_hand_state.partner_board.player_stats.lives -= 1
		helping_hand_state.partner_board.update_stats()
		print("Partner lost a life for triggering mine!")

		if helping_hand_state.partner_board.player_stats.lives <= 0:
			print('Player %d game over!' % helping_hand_state.partner_board.player_num)
			# TODO: trigger game-over stuff
		else:
			helping_hand_state.partner_reveal -= 1
			if helping_hand_state.partner_reveal <= 0:
				restore_normal_control()
	else:
		# Regular scenario
		board.player_stats.lives -= 1
		board.update_stats()

		if board.player_stats.lives <= 0:
			print('Player %d game over!' % board.player_num)
			# TODO: trigger game-over stuff

func on_board_cell_revealed(_board, by_partner):
	print('on_board_cell_revealed')
	if by_partner and helping_hand_state:
		helping_hand_state.partner_reveal -= 1
		if helping_hand_state.partner_reveal <= 0:
			restore_normal_control()

func restore_normal_control():
	print('restore_normal_control')
	if helping_hand_state == null:
		return

	var requester_board = helping_hand_state.requester_board
	var partner_board = helping_hand_state.partner_board

	# Reset selectors visibility to normal
	requester_board.selectors[partner_board.player_tag].visible = false
	partner_board.selectors[partner_board.player_tag].visible = true
	partner_board.input_enabled = true

	# Restore instructions
	requester_board.setup_instructions()
	partner_board.setup_instructions()
	# Clear state
	helping_hand_state = null
