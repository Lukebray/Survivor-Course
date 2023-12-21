extends Area2D
class_name HurtboxComponent

signal hit

@export var health_component : Node

var float_text_scene = preload("res://scenes/ui/floating_text.tscn")

func _on_area_entered(area):
	if not area is HitboxComponent:
		return
		
	if health_component == null:
		return 
	
	var hitbox_component = area as HitboxComponent
	health_component.damage(hitbox_component.damage)
	
	var floating_text = float_text_scene.instantiate() as Node2D
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	
	floating_text.global_position = global_position + (Vector2.UP * 16)
	var format_string = "%0.1f"
	if round(hitbox_component.damage) == hitbox_component.damage:
		format_string = "%0.0f"
		
	floating_text.start(format_string % hitbox_component.damage)
	hit.emit()
