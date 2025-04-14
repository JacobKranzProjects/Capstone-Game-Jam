extends Control

@onready var name_node = $Name
@onready var map_node = $Map
@onready var facts_node = $Facts

func _ready():
	var level_settings = Settings.new()
	setup_panel(level_settings.get_level_data(1))
	
func setup_panel(data):
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	anchor_left = 0
	anchor_right = 1
	offset_left = 0
	offset_right = 0
	
	name_node.text = data.country
	map_node.texture = load(data.map)

	var formatted_facts = ""
	for fact in data.facts:
		formatted_facts += "• %s\n" % fact
	facts_node.bbcode_enabled = true
	facts_node.text = formatted_facts
