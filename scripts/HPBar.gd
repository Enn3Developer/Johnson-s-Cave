extends ProgressBar

var old_hp = 100

func _on_Player_hp_signal(hp):
	set_value(hp)
	if old_hp < hp:
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("Restore")
	elif old_hp > hp:
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("Damage")
	old_hp = hp
