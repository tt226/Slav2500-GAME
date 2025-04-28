extends ProgressBar

class_name CustomHealthBar

var change_value_tween: Tween 
var opacity_tween: Tween 

func _setup_health_bar(max_val: float):
	value = max_val 
	max_value = max_val 
	$ProgressBar.value = max_val 
	$ProgressBar.max_value = max_val 
	
	
func change_value(new_value: float):
	_change_opacity(1.0)
	
	value = new_value 
	if change_value_tween:
		change_value_tween.kill()
	change_value_tween = create_tween()
	change_value_tween.finished.connect($ResetVisibility.start)
	change_value_tween.tween_property($ProgressBar, "value", new_value, 0.35).set_trans(Tween.TRANS_SINE)
		
	
	
func _change_opacity(new_amount: float): 
	if opacity_tween: 
		opacity_tween.kill()
	opacity_tween = create_tween()
	opacity_tween.tween_property(self, "modulate:a", new_amount, 0.12).set_trans(Tween.TRANS_SINE)
	 
	
	

func _on_reset_visibility_timeout() -> void:
	_change_opacity(0.0)  
