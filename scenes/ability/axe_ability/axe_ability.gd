extends Node2D

const MAX_RADIUS = 100

@onready var hitbox_component = $HitboxComponent


func _ready():
	var tween = create_tween()
	tween.tween_method(tween_method, 0.0, 2.0, 3.0)
	tween.tween_callback(queue_free)

func tween_method(rotations : float):
	var player = get_tree().get_first_node_in_group("player")
	if player == null: 
		return
		
	var angle_to_player = player.global_position.angle_to_point(global_position) + (PI / 4)
	
	rotation = angle_to_player

	var percent = rotations / 2
	var current_radius = percent * MAX_RADIUS
	
	var current_direction = Vector2.RIGHT.rotated(rotations * TAU)
	
	global_position = player.global_position + (current_direction * current_radius)
	


