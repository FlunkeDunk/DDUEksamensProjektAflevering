extends CombinationItemScene
class_name EffectScene

var currentEnergy: int
var energyNeeded: int
signal effectSignal()

func doEffect() -> void:
	pass

func addEnergy(amount: int) -> void:
	currentEnergy += amount
	var realEnergyNeeded = energyNeeded-Globals.stats.flatEffectEnergyDecrease
	while currentEnergy >= realEnergyNeeded:
		currentEnergy -= realEnergyNeeded
		doEffect()
		effectSignal.emit()
