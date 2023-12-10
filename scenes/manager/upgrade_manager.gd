extends Node

@export var upgrade_pool : Array[AbilityUpgrade]
@export var experience_manager : Node
@export var upgrade_screen_scene : PackedScene

var current_upgrades = {}


func _ready():
	experience_manager.level_up.connect(on_level_up)


func apply_upgrade(upgrade : AbilityUpgrade):
	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
		
	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		
		if current_quantity == upgrade.max_quantity:
			upgrade_pool = upgrade_pool.filter(func (pool_upgrade): return pool_upgrade.id != upgrade.id) #if func returns true, keep element. if false, filter it out
	
	
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


func pick_upgrades():
	var chosen_upgrades : Array[AbilityUpgrade] = []
	var filtered_upgrades = upgrade_pool.duplicate()
	
	for i in filtered_upgrades.size():
		var chosen_upgrade = filtered_upgrades.pick_random() as AbilityUpgrade
		chosen_upgrades.append(chosen_upgrade)
		filtered_upgrades = filtered_upgrades.filter(func (upgrade): return upgrade.id != chosen_upgrade.id) #this is saying keep every element in the upgrades that is not the same as what we have picked. 
	
	return chosen_upgrades


func on_upgrade_selected(upgrade : AbilityUpgrade):
	apply_upgrade(upgrade)
	

func on_level_up(current_level : int):
	if pick_upgrades().is_empty(): #Stops the game from freezing with 0 abilities.
		return
		
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	var chosen_upgrades = pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
