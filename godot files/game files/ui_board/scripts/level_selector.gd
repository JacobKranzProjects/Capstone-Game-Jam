extends Control

@onready var scroller = $VBoxContainer/ScrollContainer
@onready var container = $VBoxContainer/ScrollContainer/LevelContainer
var thumnail_scene = preload("res://game files/ui_board/scenes/level_thumbnail.tscn")
var board_scene = preload("res://game files/ui_board/scenes/board.tscn")

var level_settings = Settings.new()
var previously_selected = null
var selected_level = 1

func _ready() -> void:
	for level in level_settings.levels.keys():
		var data = level_settings.get_level_data(level)
		var thumbnail = thumnail_scene.instantiate()
		configure_thumbnail(thumbnail, level, data)
		container.add_child(thumbnail)
	await get_tree().process_frame
	scroller.get_h_scroll_bar().value_changed.connect(_on_scroll_changed)
	_update_selection()
	
func configure_thumbnail(thumbnail, level_number, data):
	thumbnail.name = "Level_%s" % data.country
	thumbnail.custom_minimum_size = get_viewport_rect().size / 2
	thumbnail.visible = true

	# Background
	var bg = thumbnail.get_node("background")
	bg.texture = load(data.background)
	bg.modulate = Color(1, 1, 1, 0.5)

	# Country Name
	var name_label = thumbnail.get_node("name")
	name_label.text = data.country

	# Dummy Board
	var dummy = board_scene.instantiate()
	thumbnail.get_node("VBoxContainer").add_child(dummy)
	await dummy.ready
	dummy.setup_board(thumbnail.custom_minimum_size * 0.75, data, null, 0, true)

	# Selection event
	thumbnail.gui_input.connect(func(event):
		if event is InputEventMouseButton and event.pressed:
			select_level(level_number, thumbnail)
	)

func _on_scroll_changed(_value):
	_update_selection()

func _update_selection():
	var viewport_center_x = scroller.get_global_rect().get_center().x
	var closest_thumbnail = null
	var min_dist = INF
	
	for thumbnail in container.get_children():
		var dist = abs(thumbnail.global_position.x + thumbnail.size.x / 2 - viewport_center_x)
		if dist < min_dist:
			min_dist = dist
			closest_thumbnail = thumbnail
	
	if closest_thumbnail and closest_thumbnail != previously_selected:
		select_level(_get_level_number_from_thumbnail(closest_thumbnail), closest_thumbnail)

func select_level(level_number, thumbnail):
	selected_level = level_number
	if previously_selected:
		var prev_panel = previously_selected as PanelContainer
		prev_panel.add_theme_stylebox_override("panel", preload("res://game files/ui_board/assets/default.tres"))

	var current_panel = thumbnail as PanelContainer
	current_panel.add_theme_stylebox_override("panel", preload("res://game files/ui_board/assets/selected.tres"))
	previously_selected = thumbnail

func _get_level_number_from_thumbnail(thumbnail):
	var country_name = thumbnail.get_node("name").text
	for number in level_settings.levels:
		if level_settings.levels[number].country == country_name:
			return number
	return null

func _on_next_button_pressed() -> void:
	GameState.selected_level = selected_level
	get_tree().change_scene_to_file("res://game files/ui_board/scenes/tool_selector.tscn")

func queue_free_children():
	for child in get_children():
		child.queue_free()
	
