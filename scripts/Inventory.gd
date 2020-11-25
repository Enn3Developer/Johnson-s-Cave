extends Control

# 1m³ = 4 horizontal tiles
# 1kg = 4 vertical tiles

export var vertical_tiles = 4
export var horizontal_tiles = 4

var max_weight = vertical_tiles * 4
var max_volume = horizontal_tiles * 4


class Item:
	var volume: int
	var weight: int
	var texture: String
	var display: String
	var is_picked_up: bool
	
	func add(volume, weight, texture, display, is_picked_up):
		self.volume = volume
		self.weight = weight
		self.texture = texture
		self.display = display
		self.is_picked_up = is_picked_up

#var ITEM = {
#	"knife": Item.add(1, 1, "knife", "knife", false),
#	"lamp": Item.add(2, 2, "lamp", "lamp", true)
#}

var items_in = {}  #ITEM.item: coord in the inventory


