extends Camera2D

@onready var menuSwitch: AudioStream = load("res://Assets/AudioFiles/buySucceed.wav")

func tweenToPos(tweenPos):
	var tween: Tween = create_tween()
	var tweenTime: float = 0.5
	tween.tween_property(self, "position", tweenPos, tweenTime).set_trans(Tween.TRANS_QUINT)
	SfxManager.play_sound(menuSwitch)
