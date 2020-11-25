extends TextureRect

var order = 0
var tr = "TextureRect"

func add_order():
	order += 1

func sub_order():
	order -= 1

func get_order() -> TextureRect:
	var node: TextureRect
	var name = self.name
	if order == 0:
		if name == tr:
			node = self
	else:
		if name == ("%s%i" % [tr, order]):
			node = self
	
	return node

func set_tex_rect(item):
	if item == "nothing":
		$TextureRect.visible(false)
	if item == "knife":
		# $TextureRect.texture = "res://assets/knife.png" #To add textures
		pass

func _on_Player_set_item_in_hotbar(item: String):
	if get_order() == self:
		set_tex_rect(item)
