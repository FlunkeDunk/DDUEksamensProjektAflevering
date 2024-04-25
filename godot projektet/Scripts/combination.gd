class_name Combination
extends Resource

@export var effect: EffectItem = null
@export var generator: GeneratorItem = null

func addEffect(effectToAdd:EffectItem) -> void:
	effect = effectToAdd

func addGenerator(generatorToAdd:GeneratorItem) -> void:
	generator = generatorToAdd

func getItemOfType(type:String) -> Item:
	if effect != null:
		if effect.type == type:
				return effect
	if generator != null:
		if generator.type == type:
			return generator
	if type != "Effect" and type != "Generator":
		push_error("The item type \"" + type + "\" does not exist")
	return

func removeEffect() -> void:
	effect = null

func removeGenerator() -> void:
	generator = null

func returnEffectTypeToInvetory(type: String) -> void:
	if type == "Effect":
		Globals.inventory.addItem(effect.duplicate())
		removeGenerator()
	else:
		Globals.inventory.addItem(generator.duplicate())
		generator = null

func returnToInventory() -> void:
	Globals.inventory.addItem(effect.duplicate())
	Globals.inventory.addItem(generator.duplicate())
	
func isFull() -> bool:
	return generator != null and effect != null

func clear() -> void:
	removeEffect()
	removeGenerator()
