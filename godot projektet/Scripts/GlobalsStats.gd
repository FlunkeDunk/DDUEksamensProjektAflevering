extends Resource
class_name GlobalStats

##Upgrade button stats
@export var playerSpeedMult: float = 1.0
@export var playerDamageMult: float = 1.0
@export var playerFireRateMult: float = 1.0
@export var playerFlatDamage: float = 0.0
@export var playerEnergyMult: float = 1.0
@export var playerRegenMult: float = 0.0
@export var playerHealthIncrease: int = 0

##Artifact stats
@export var flatEnergyIncrease: int = 0
@export var flatEffectEnergyDecrease: int = 0
@export var artifactsResetOnReload: bool = false
@export var damageScaleWithDistance: bool = false
@export var fullHealthDamage: float = 1.0
@export var oneshotChance: float = 0.00
@export var bulletsExplode: bool = false
@export var bulletsSplit: bool = false
@export var extraUpgrades: int = 0
@export var energyToGold: float = 0.0

##Buffs
var speedMultBuff: float = 0
var fireRateMultBuff: float = 0

##Resources
@export var energy: float = 0
@export var money: int = 100
@export var score: int = money*5
@export var totalDistance = 0

@export var availableArtifacts: Array[Artifact]
@export var availableGenerators: Array[GeneratorItem]
@export var availableEffects: Array[EffectItem]
@export var availableGuns: Array[Gun]
var allArtifacts: Array[String] = ["res://Data/Artifacts/BuffsResetOnReload.tres", "res://Data/Artifacts/BulletsSplit.tres", "res://Data/Artifacts/CheaperEffectsArtifact.tres", "res://Data/Artifacts/DamageScaleWithDistance.tres", "res://Data/Artifacts/ExplodingBullets.tres", "res://Data/Artifacts/FullHealthDamage.tres", "res://Data/Artifacts/GoldFromEnergy.tres", "res://Data/Artifacts/MoreEnergyArtifact.tres", "res://Data/Artifacts/OneshotChance.tres", "res://Data/Artifacts/RebuyUpgrades.tres"]
var allGenerators: Array[String] = ["res://Data/Generators/on_damage_taken.tres", "res://Data/Generators/on_distance_travelled.tres", "res://Data/Generators/on_enemy_killed.tres", "res://Data/Generators/on_enemy_taken_damage.tres", "res://Data/Generators/on_reload.tres", "res://Data/Generators/on_shoot.tres"]
var allEffects: Array[String] = ["res://Data/Effects/fire_rate_buff.tres", "res://Data/Effects/heal_amount.tres", "res://Data/Effects/heal_to_full.tres", "res://Data/Effects/kill_one_enemy.tres", "res://Data/Effects/move_speed_buff.tres", "res://Data/Effects/next_enemy_killed_explodes.tres", "res://Data/Effects/reload.tres", "res://Data/Effects/shoot_again.tres"]
var allGuns: Array[String] = ["res://Data/Guns/Revolver.tres", "res://Data/Guns/Shotgun.tres"]

signal gotArtifact(artifact: Artifact)

func _init():
	setAvailableItems()

func setAvailableItems() -> void:
	availableArtifacts.clear()
	availableGenerators.clear()
	availableEffects.clear()
	availableGuns.clear()
	for item in getItemsFrom(allArtifacts):
		availableArtifacts.append(item)
	for item in getItemsFrom(allGenerators):
		availableGenerators.append(item)
	for item in getItemsFrom(allEffects):
		availableEffects.append(item)
	for item in getItemsFrom(allGuns):
		availableGuns.append(item)

func getItemsFrom(itemArray: Array) -> Array:
	var items: Array = []
	for item in itemArray:
		items.append(load(item))
	return items

func getNewArtifact() -> Artifact:
	return availableArtifacts.pick_random()

func artifactObtained(artifact:Artifact):
	gotArtifact.emit(artifact)
	availableArtifacts.erase(artifact)

func getNewGun() -> Gun:
	return availableGuns.pick_random()

func gunObtained(gun: Gun) -> void:
	availableGuns.erase(gun)

func weightedRandomReward() -> Item:
	while true:
		var roll = randf()
		if roll < 0.4:
			if availableGenerators.size() > 0:
				return availableGenerators.pick_random()
		elif roll < 0.8:
			if availableEffects.size() > 0:
				return availableEffects.pick_random()
		elif roll < 0.9:
			if availableGuns.size() > 0:
				return getNewGun()
		else:
			if availableArtifacts.size() > 0:
				return getNewArtifact()
	return
	
func resetArtifactStats() -> void:
	flatEnergyIncrease = 0
	flatEffectEnergyDecrease = 0
	artifactsResetOnReload = false
	damageScaleWithDistance = false
	fullHealthDamage = 1.0
	oneshotChance = 0
	bulletsExplode = false
	bulletsSplit = false
	extraUpgrades = 0
	energyToGold = 0
	money = 100
	score = money * 5
