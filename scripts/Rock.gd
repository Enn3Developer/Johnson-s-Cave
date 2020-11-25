extends KinematicBody2D

func _on_Player_move_rock(direction, rock_name):
	if rock_name == self.name:
		var _unused = move_and_collide(direction.normalized())
