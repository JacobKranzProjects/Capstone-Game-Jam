extends Control

const WINDOW_SIZE = Vector2(1280, 720)
const INFO_PANEL_HEIGHT = 160
const STAT_PANEL_WIDTH = 150
const BOARD_PADDING = 10

@export var current_level: int = 11

@onready var board1 = $VBoxContainer/BoardContainer/board1
@onready var board2 = $VBoxContainer/BoardContainer/board2
@onready var info_panel = $VBoxContainer/info
@onready var stat_panel = $VBoxContainer/BoardContainer/stats
@onready var background = $VBoxContainer/BoardContainer/Background

var level_settings = Settings.new()
var level_data

func _ready():
	DisplayServer.window_set_size(WINDOW_SIZE)
	size = WINDOW_SIZE
	
	stat_panel.start_timer()
	
	level_data = level_settings.get_level_data(current_level)
	if level_data:
		setup_background(level_data)
		setup_layout(level_data)
	else:
		push_error("No data found for level: %d" % current_level)

func setup_background(data):
	background.texture = load(data.background)
	background.modulate = Color(1, 1, 1, 0.3)
	background.size = $VBoxContainer/BoardContainer.size

func setup_layout(data):
	info_panel.custom_minimum_size = Vector2(WINDOW_SIZE.x, INFO_PANEL_HEIGHT)
	#info_panel.size_flags_horizontal = Control.SIZE_FILL
	#info_panel.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	info_panel.setup_panel(data)

	var available_width = floor((WINDOW_SIZE.x - STAT_PANEL_WIDTH - 4 * BOARD_PADDING) / 2)
	var available_height = WINDOW_SIZE.y - INFO_PANEL_HEIGHT
	var board_size = Vector2(available_width, available_height)
	
	board1.setup_board(board_size, data)
	board2.setup_board(board_size, data)

	stat_panel.custom_minimum_size = Vector2(STAT_PANEL_WIDTH, available_height)
	stat_panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	stat_panel.size_flags_vertical = Control.SIZE_SHRINK_CENTER

func _process(_delta):
	background.size = $VBoxContainer/BoardContainer.size
	
	stat_panel.refresh_stats(board1.player_stats, board2.player_stats)
	
func end_game():
	stat_panel.stop_timer()
