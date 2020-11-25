extends StaticBody2D

func _on_Player_destroy_web(name):
	if name == self.name:
		get_tree().queue_delete(self)
