extends HBoxContainer
class_name Inventory


@export var items:Array[int]
var selected_item:int = 0

@export var player:Player
@onready var inventory_slot_preload = preload("res://scenes/inventory_slot.tscn")


func collect_item(poison_type:int) -> bool:
	if(items.size()==player.MAXINVENTORYSIZE): 
		return false
	else:
		items.append(poison_type)
		show_items()
		print(items)
		return true

func remove_item(index:int):
	if(index==items.size()-1 and index==selected_item):
		select_previous()
	items.remove_at(index)
	if(index==selected_item and index!=selected_item):
		select_item(index)
	show_items()


func select_item(index:int):
	if(index>=self.get_children().size() or items.size()==0): return
	var new_selected_slot:Inventoryslot = self.get_children()[index]
	var old_selected_slot:Inventoryslot = self.get_children()[selected_item]
	old_selected_slot.deselect()
	new_selected_slot.select()
	selected_item = index

func select_next():
	if(selected_item==items.size()-1):
		select_item(0)
	else:
		select_item(selected_item+1)
func select_previous():
	if(selected_item==0):
		select_item(items.size()-1)
	else:
		select_item(selected_item-1)


func show_items():
	for i in self.get_children():
		if(i is Inventoryslot):
			i.queue_free()
	for i in range(0, items.size()):
		var instance:Inventoryslot = inventory_slot_preload.instantiate()
		self.add_child(instance)
		instance.item_type = items[i]
		instance.item_color = player.poison_effects.effect_colors[items[i]]
		instance.show_item()
		if(i!=selected_item): instance.deselect()
