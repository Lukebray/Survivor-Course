extends Area2D
class_name HurtboxComponent

@export var health_component : Node



func _on_area_entered(area):
	if not area is HitboxComponent:
		return
		
	if health_component == null:
		return 
	
	print("hit!")
	print(health_component.current_health)
	var hitbox_component = area as HitboxComponent
	health_component.damage(hitbox_component.damage)
