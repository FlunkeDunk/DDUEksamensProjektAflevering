extends Control


func _ready():
	var settings = ResourceLoader.load("user://Settings.tres")
	if !settings:
		return
	Globals.settings = settings
	Globals.database = %DatabaseManager
	AudioServer.set_bus_volume_db(0, Globals.settings.master)
	AudioServer.set_bus_volume_db(1, Globals.settings.SFX)
	AudioServer.set_bus_volume_db(2, Globals.settings.music)
