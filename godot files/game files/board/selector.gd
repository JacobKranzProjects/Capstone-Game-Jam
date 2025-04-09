extends Sprite2D

@onready var cell_manager: Node2D = $"../cell manager"

@export var player = 1
var player_tag = "p"+str(player)+"_"
var grid_position = Vector2(0,0)

func _ready() -> void:
	pass

func move(dir):
	if cell_manager.cell_dict.get(grid_position + dir) != null:
		grid_position += dir
		position += dir * cell_manager.cell_size

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(player_tag + "up"): move(Vector2(0,-1))
	if Input.is_action_just_pressed(player_tag + "down"): move(Vector2(0,1))
	if Input.is_action_just_pressed(player_tag + "left"): move(Vector2(-1,0))
	if Input.is_action_just_pressed(player_tag + "right"): move(Vector2(1,0))
	
	if Input.is_action_just_pressed(player_tag + "clear"): cell_manager.cell_dict[grid_position].reveal()
