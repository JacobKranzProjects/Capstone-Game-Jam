extends Control

@onready var container = $VBoxContainer/PanelContainer/ToolListContainer
@onready var tool_template = container.get_node("ToolTemplate")
@onready var start_button = $VBoxContainer/HBoxContainer/StartButton

var level_settings = Settings.new()
var current_level = GameState.selected_level

var selected_tool_p1 = null
var selected_tool_p2 = null

const COLOR_HINT = Color(0.1, 0.1, 0.1, 0.1)  # greyish hint
const COLOR_P1 = Color(1, 1, 0, 1)          # yellow
const COLOR_P2 = Color(1, 0.6, 0.4, 1)        # orange

var blinking_tween_p1 = null
var blinking_tween_p2 = null
var blinking_stopped_p1 = false
var blinking_stopped_p2 = false

func _ready():
	load_tools()
	tool_template.visible = false
	
	if container.get_child_count() > 1:
		var first_item = container.get_child(1)
		var first_tool = level_settings.get_level_data(current_level).tools[0]

		selected_tool_p1 = first_item
		selected_tool_p2 = first_item

		# Set visual indicators
		first_item.get_node("p1").modulate = COLOR_P1
		first_item.get_node("p2").modulate = COLOR_P2

		# Update global state
		GameState.selected_tool_p1 = first_tool
		GameState.selected_tool_p2 = first_tool
		
		blink(first_item.get_node("p1"), COLOR_P1, 1)
		blink(first_item.get_node("p2"), COLOR_P2, 2)

func load_tools():
	var level_data = level_settings.get_level_data(current_level)
	for tool in level_data.tools:
		var tool_item = tool_template.duplicate()
		tool_item.visible = true
		
		tool_item.get_node("p1").modulate = COLOR_HINT
		tool_item.get_node("p2").modulate = COLOR_HINT
		
		populate_tool_item(tool_item, tool)
		container.add_child(tool_item)
		
		# Handle selection
		tool_item.gui_input.connect(func(event):
			if event is InputEventMouseButton and event.pressed:
				handle_tool_selection(tool_item, tool, event.position.x)
		)

func populate_tool_item(item, tool):
	item.get_node("ToolDetails/effect").text = tool.icon + " " + tool.name + "  (" + tool.effect + ")"
	item.get_node("ToolDetails/description").text = tool.description

func handle_tool_selection(item, tool, click_x_pos):
	var item_width = item.size.x
	var player_side = 1 if click_x_pos < item_width / 2 else 2

	if player_side == 1:
		if not blinking_stopped_p1:
			stop_blinking(1)
		if selected_tool_p1:
			selected_tool_p1.get_node("p1").modulate = COLOR_HINT
		selected_tool_p1 = item
		item.get_node("p1").modulate = COLOR_P1
		GameState.selected_tool_p1 = tool
	else:
		if not blinking_stopped_p2:
			stop_blinking(2)
		if selected_tool_p2:
			selected_tool_p2.get_node("p2").modulate = COLOR_HINT
		selected_tool_p2 = item
		item.get_node("p2").modulate = COLOR_P2
		GameState.selected_tool_p2 = tool
	
func blink(indicator_node, target_color, player_number):
	indicator_node.modulate = COLOR_HINT
	var tween = get_tree().create_tween().set_loops()
	tween.tween_property(indicator_node, "modulate", target_color, 0.6).set_trans(Tween.TRANS_SINE)
	tween.tween_property(indicator_node, "modulate", COLOR_HINT, 0.6).set_trans(Tween.TRANS_SINE)

	if player_number == 1:
		blinking_tween_p1 = tween
	elif player_number == 2:
		blinking_tween_p2 = tween

func stop_blinking(player_number):
	if player_number == 1 and blinking_tween_p1:
		blinking_tween_p1.kill()
		blinking_tween_p1 = null
		blinking_stopped_p1 = true
	elif player_number == 2 and blinking_tween_p2:
		blinking_tween_p2.kill()
		blinking_tween_p2 = null
		blinking_stopped_p2 = true
		
func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://game files/ui_board/scenes/main.tscn")

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game files/ui_board/scenes/level_selector.tscn")


	
