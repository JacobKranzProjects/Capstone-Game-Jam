extends Sprite2D

@onready var cell_manager: Node2D = $"../cell manager"

@export var player = 1
var player_tag = "p"+str(player)+"_"

var grid_position = Vector2(0,0)
var starting = true

func _ready() -> void:
	scale_selector()
	update_selector_position()

func scale_selector():
	var target_size = cell_manager.cell_size
	var current_texture_size = texture.get_size()
	scale = Vector2(target_size / current_texture_size.x, target_size / current_texture_size.y)

func update_selector_position():
	position = cell_manager.position + (grid_position + Vector2(0.5, 0.5)) * cell_manager.cell_size

func move(dir):
	var new_pos = grid_position + dir
	if cell_manager.cell_dict.get(new_pos) != null:
		grid_position = new_pos
		update_selector_position()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(player_tag + "up"): move(Vector2(0,-1))
	if Input.is_action_just_pressed(player_tag + "down"): move(Vector2(0,1))
	if Input.is_action_just_pressed(player_tag + "left"): move(Vector2(-1,0))
	if Input.is_action_just_pressed(player_tag + "right"): move(Vector2(1,0))
	
	if Input.is_action_just_pressed(player_tag + "mine"): 
		cell_manager.cell_dict[grid_position].mark()
	
	if Input.is_action_just_pressed(player_tag + "clear"):
		if starting:
			cell_manager.create_mines()
			starting = false
		cell_manager.cell_dict[grid_position].reveal()
