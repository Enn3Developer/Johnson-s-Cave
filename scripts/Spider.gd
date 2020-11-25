extends KinematicBody2D

export var speed = 150

var player_position
var nav = null setget set_nav
var path = []

func _process(delta):
	if path.size() > 1:
		var d = get_position().distance_to(path[0])
		if d > 2:
			set_position(get_position().linear_interpolate(path[0], (speed*delta)/d))
		else:
			path.remove(0)

func _on_Player_position_signal(position):
	self.player_position = position

func _on_Navigation2D_ready():
	nav = get_tree().get_nodes_in_group("nav")[0]

func set_nav(new_nav):
	nav = new_nav
	update_path()

func update_path():
	path = nav.get_simple_path(get_position(), player_position, false)
