extends MarginContainer

@onready var levelManager = $"../../LevelManager"
@onready var settingsMenu = $Panel/SettingsMenu
@onready var pauseMenu = $Panel/PauseMenu
@onready var pauseScreenClick: AudioStream = load("res://Assets/AudioFiles/buy.wav")

signal stopPause

func _on_return_button_pressed():
	unpause()
	SfxManager.play_sound(pauseScreenClick)

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		unpause()

func unpause() -> void:
	stopPause.emit()
	get_tree().paused = false
	levelManager.unpause()


func _on_settings_button_pressed():
	settingsMenu.show()
	pauseMenu.hide()
	SfxManager.play_sound(pauseScreenClick)


func _on_back_button_pressed():
	stopPause.emit()
	settingsMenu.hide()
	pauseMenu.show()
	SfxManager.play_sound(pauseScreenClick)
