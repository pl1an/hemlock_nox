extends Control
class_name Inventoryslot

@export var item_color:Color
@export var item_type:int

var style_box:StyleBoxFlat = StyleBoxFlat.new()


var showing_item = true
var selected = true

func show_item():
	var item:MarginContainer = self.get_child(2)
	style_box.bg_color = item_color
	var color:Panel = self.get_child(2).get_child(0).get_child(0)
	color.add_theme_stylebox_override("panel", style_box)
	item.show()
	showing_item = true
func hide_item():
	var item:MarginContainer = self.get_child(2)
	item.hide()
	showing_item = false

func select():
	var selected_border:TextureRect = self.get_child(3)
	selected_border.show()
	selected = true
func deselect():
	var selected_border:TextureRect = self.get_child(3)
	selected_border.hide()
	selected = false
