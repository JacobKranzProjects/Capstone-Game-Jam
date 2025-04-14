extends Control

@onready var timer = $VBoxContainer/VBoxContainer/Timer
@onready var lives = $VBoxContainer/VBoxContainer/Lives/value
@onready var flagged = $VBoxContainer/VBoxContainer/Flagged/value
@onready var moves = $VBoxContainer/VBoxContainer/Moves/value
@onready var cleared = $VBoxContainer/VBoxContainer/Cleared/value
@onready var efficiency = $VBoxContainer/VBoxContainer/Efficiency/value

var elapsed : float = 0.0
var running : bool = false

func _process(delta):
	if running:
		elapsed += delta
		update_timer_label()

func update_timer_label():
	timer.text = "%02d:%02d" % [floor(elapsed / 60), int(elapsed) % 60]

func refresh_stats(p1_stats, p2_stats):
	if p1_stats and p2_stats:
		lives.text = "%3d | %-3d" % [p1_stats.lives, p2_stats.lives]
		flagged.text = "%3d | %-3d" % [p1_stats.flagged, p2_stats.flagged]
		moves.text = "%3d | %-3d" % [p1_stats.moves, p2_stats.moves]
		cleared.text = "%3d | %-3d" % [p1_stats.cleared, p2_stats.cleared]
		efficiency.text = "%3d | %-3d" % [p1_stats.efficiency, p2_stats.efficiency]

func reset_timer():
	elapsed = 0.0
	update_timer_label()

func stop_timer():
	running = false

func start_timer():
	running = true
