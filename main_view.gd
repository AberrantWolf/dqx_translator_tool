extends Control

@export var fileMenu: MenuButton
@export var file_open: FileDialog
@export var file_save_as: FileDialog
@export var tree_view: Tree


@onready var tree_items: Dictionary = {}

var tree_root: TreeItem

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fileMenu.get_popup().index_pressed.connect(_on_file_menu_item_pressed)
	
	file_open.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_open.access = FileDialog.ACCESS_FILESYSTEM
	file_open.filters = ["*.json"]
	file_open.file_selected.connect(_on_file_open)
	
	tree_view.set_column_title(0, "ID")
	tree_view.set_column_expand(0, true)
	tree_view.set_column_expand_ratio(0, 1)
	tree_view.set_column_title(1, "Japanese")
	tree_view.set_column_expand(1, true)
	tree_view.set_column_expand_ratio(1, 2)
	tree_view.set_column_title(2, "English")
	tree_view.set_column_expand(2, true)
	tree_view.set_column_expand_ratio(2, 2)


func _on_file_menu_item_pressed(index: int):
	match index:
		0: # Open
			file_open.popup()
		1: # Save
			pass
		2: # Save As
			pass
		4:
			get_tree().quit()


func _on_file_open(path: String):
	tree_items.clear()
	tree_view.clear()
	tree_root = tree_view.create_item()

	var json_file = FileAccess.open(path, FileAccess.READ)
	var json_text = json_file.get_as_text()
	json_file.close()
	
	var data = JSON.parse_string(json_text)
	for _id in data.keys():
		print("ID: " + str(_id))
		
		var subdict: Dictionary = data[_id]
		for _jp in subdict.keys():
			var _en: String = subdict[_jp]
			
			# Now add them to the tree view...
			var _item = tree_view.create_item(tree_root)
			_item.set_text(0, str(_id))
			_item.set_text(1, str(_jp))
			_item.set_text(2, str(_en))
			_item.set_editable(2, true)
			_item.set_edit_multiline(2, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
