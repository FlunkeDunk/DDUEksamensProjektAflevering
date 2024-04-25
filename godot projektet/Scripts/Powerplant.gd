extends TabContainer




func _on_tab_clicked(tab):
	SfxManager.play_sound(load("res://Assets/AudioFiles/UIBeepLighter.mp3"))
