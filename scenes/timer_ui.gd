extends Node2D

@onready var daylight_timer: Timer = $DaylightTimer
@onready var daylight_label: Label = $UI/Label

func _process(_delta):
	if daylight_timer.is_stopped():
		return
	
	var time_left = int(daylight_timer.time_left)
	daylight_label.text = "Time til Daylight: " + str(time_left)

	# Flash red when under 15 seconds
	if time_left <= 15:
		var flash = int(Time.get_ticks_msec() / 200) % 2 == 0
		if flash:
			daylight_label.modulate = Color(1, 0, 0)  # Red
		else:
			daylight_label.modulate = Color(1, 1, 1)  # White
	else:
		# If more than 15 seconds, keep normal color
		daylight_label.modulate = Color(1, 1, 1)

@onready var fade_rect = $CanvasLayer/ColorRect
# from ChatGPT with promt: how to fade to white
func fade_to_white():
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, 1.0)  # fade alpha 

func _on_daylight_timer_timeout() -> void:
	get_tree().get_nodes_in_group("player")[0].die()
	fade_to_white()
