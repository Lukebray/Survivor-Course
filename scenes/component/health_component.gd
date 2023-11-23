extends Node
class_name HealthComponent

signal died # emit this when the owner of this component dies

@export var max_health : float = 10
var current_health

func _ready():
	current_health = max_health


func damage(damage_amount : float):
	current_health = max(current_health - damage_amount, 0) # makes sure the health can't be negative
	Callable(check_death).call_deferred()


func check_death():
	if current_health == 0:
		died.emit()
		owner.queue_free()
