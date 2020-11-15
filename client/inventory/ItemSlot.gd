extends Panel
class_name InventoryItemSlot

export(Global.SlotType) var slotType = Global.SlotType.SLOT_DEFAULT;

var slotIndex;
var item = null;
var style;

signal on_update_slot(item)

onready var item_root = $"/root/World/CanvasLayer/InventoryGui/Items"

func _ready():
	if not item_root:
		item_root = get_tree().get_root()

func _init():
	mouse_filter = Control.MOUSE_FILTER_PASS;
	rect_min_size = Vector2(34, 34);
	style = StyleBoxFlat.new();
	refreshColors();
	style.set_border_width_all(2);
	set('custom_styles/panel', style);

func setItem(newItem):
	add_child(newItem);
	item = newItem;
	item.itemSlot = self;
	refreshColors();
	emit_signal("on_update_slot", item)

func pickItem():
	item.pickItem();
	remove_child(item);
	item_root.add_child(item);
	item = null;
	refreshColors();
	emit_signal("on_update_slot", null)

func putItem(newItem):
	item = newItem;
	item.itemSlot = self;
	item.putItem();
	item_root.remove_child(item);
	add_child(item);
	refreshColors();
	emit_signal("on_update_slot", item)

func removeItem():
	remove_child(item);
	item = null;
	refreshColors();
	emit_signal("on_update_slot", null)

func equipItem(newItem, rightClick =  true):
	item = newItem;
	item.itemSlot = self;
	item.putItem();
	if !rightClick:
		item_root.remove_child(item);
	add_child(item);
	refreshColors();
	emit_signal("on_update_slot", item)

var colors = preload("res://items/colors.gd")
func refreshColors():
	if item:
		#style.bg_color = Global.itemColor(item.rarity)
		style.border_color = colors.itemColor(int(item.rarity));
	else:
		#style.bg_color = Color("#8B7258");
		style.border_color = Color("#534434");
