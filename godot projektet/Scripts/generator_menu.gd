extends Control

@export var energy: float = 10
@export var energyGainBase: float = 0
@export var generatorsBought: int = 0
@export var generatorBoost: float = 1
@export var energyGain: float = 0
@export var multBase: float = 2
@export var multipliers: int = 0
@export var energyLimit: float = 500
@export var overflow: float = 0

@export var radar: Control

signal energyChanged
signal generatorBought

func _ready():
	if !radar.deploy.is_connected(generateEnergy):
		radar.deploy.connect(generateEnergy)

func _process(delta):
	energyGainBase = generatorsBought*pow(generatorBoost,generatorsBought)
	energyGain = energyGainBase*pow(multBase, multipliers)

func generateEnergy(seconds) -> void:
	changeEnergy(energyGain*seconds)

func changeEnergy(extraEnergy) -> void:
	energy += extraEnergy
	if energy > energyLimit:
		var excess = energy-energyLimit
		energyLimit += excess*overflow
		energy = energyLimit
	emit_signal("energyChanged")
	Globals.stats.energy = energy
