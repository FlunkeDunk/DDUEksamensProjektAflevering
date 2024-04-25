extends Node2D
class_name CombinationItemScene


func getGun() -> Node2D:
	return get_parent().get_parent().gun
	
func getPlayer() -> Player:
	return get_parent().get_parent().player

func getSpawner() -> Spawner:
	return get_parent().get_parent().spawner

func getBuffManager() -> BuffManager:
	return getPlayer().buffManager
