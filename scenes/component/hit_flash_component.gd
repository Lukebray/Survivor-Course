extends Node

@export var health_component : Node
@export var sprite : Sprite2D
@export var hit_flash_material : ShaderMaterial

var hit_flash_tween : Tween

func _ready():
	health_component.health_changed.connect(_on_health_changed)
	sprite.material = hit_flash_material
	

func _on_health_changed():
	if hit_flash_tween != null && hit_flash_tween.is_valid():
		hit_flash_tween.kill() #if we have a tween still running, invalidate the tween so we don't have 2 running
	
	#set value to 1 then tween it down to 0 over 0.2 seconds
	(sprite.material as ShaderMaterial).set_shader_parameter("lerp_percent", 1.0)
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(sprite.material, "shader_parameter/lerp_percent", 0.0, 0.2)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)

