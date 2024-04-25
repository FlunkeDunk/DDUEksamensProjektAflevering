extends Button

@onready var levelManager: Control = get_tree().get_root().get_node("MainScene/LevelManager")
@onready var mainMenuClick: AudioStream = load("res://Assets/AudioFiles/buy.wav")

func _pressed() -> void:
	levelManager.get_tree().reload_current_scene()
