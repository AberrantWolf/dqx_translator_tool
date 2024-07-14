extends Control

@export var fileMenu: MenuButton
@export var file_open: FileDialog
@export var file_save_as: FileDialog
@export var list_container: VBoxContainer

@onready var row_template: PackedScene = preload("res://row_template.tscn")
@onready var items: Array = []

@onready var config: ConfigFile = ConfigFile.new()
@onready var config_path: String = "./.dqxTranslatorConfig"

@onready var sys_event_open: InputEvent = preload("res://Events/open_input_event.tres")
@onready var sys_event_save: InputEvent = preload("res://Events/save_input_event.tres")

var file_name: String
var data: Dictionary


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fileMenu.get_popup().index_pressed.connect(_on_file_menu_item_pressed)
	
	file_open.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_open.access = FileDialog.ACCESS_FILESYSTEM
	file_open.filters = ["*.json"]
	file_open.file_selected.connect(_on_file_open)
	
	fileMenu.get_popup().set_item_accelerator(0, KEY_MASK_CMD_OR_CTRL | KEY_O)
	fileMenu.get_popup().set_item_accelerator(1, KEY_MASK_CMD_OR_CTRL | KEY_S)
	
	var open_shortcut = Shortcut.new()
	open_shortcut.events = [sys_event_open]
	fileMenu.get_popup().set_item_shortcut(0, open_shortcut, true)
	
	var save_shortcut = Shortcut.new()
	save_shortcut.events = [sys_event_save]
	fileMenu.get_popup().set_item_shortcut(1, save_shortcut, true)
	
	if !FileAccess.file_exists(config_path):
		var _temp = FileAccess.open(config_path, FileAccess.WRITE)
		_temp.close()
	var err = config.load(config_path)
	if err != OK:
		print("Error loading config file")


func _on_file_menu_item_pressed(index: int):
	match index:
		0: # Open
			file_open.current_dir = config.get_value("GENERAL", "LAST_SEARCH_PATH", ".")
			file_open.popup_centered()
		1: # Save
			_save_file(file_name)
		2: # Save As
			# Open a save as dialog
			pass
		4:
			get_tree().quit()


func _on_file_open(path: String):
	var parent_dir = path.get_base_dir()
	config.set_value("GENERAL", "LAST_SEARCH_PATH", parent_dir)
	config.save(config_path)
	
	items.clear()
	
	for n in list_container.get_children():
		list_container.remove_child(n)
		n.queue_free()
	
	file_name = path

	var json_file = FileAccess.open(path, FileAccess.READ)
	var json_text = json_file.get_as_text()
	json_file.close()
	
	data = JSON.parse_string(json_text)
	for _id: String in data.keys():
		print("ID: " + _id)
		
		var subdict: Dictionary = data[_id]
		for _jp: String in subdict.keys():
			var _en: String = subdict[_jp]
			
			# Now add them to the view...
			var _row =  row_template.instantiate() as RowTemplate
			_row.label.text = str(_id)
			_row.jp_text.text = _jp
			_row.en_text.text = _en
			_row.en_text.syntax_highlighter = DqxHighlighter.new()
			
			var _font: Font = _row.jp_text.get_theme_font("font")
			var _ts = TextParagraph.new()
			
			_ts.add_string(_jp, _font, 16)
			var _size_jp: Vector2 = _ts.get_size()
			var _lines_jp = _jp.count('\n')
			
			_ts.clear()
			_ts.add_string(_en, _font, 16)
			var _size_en: Vector2 = _ts.get_size()
			var _lines_en = _en.count('\n')
			
			_row.custom_minimum_size.y = max(_size_jp.y, _size_en.y) + max(_lines_en, _lines_jp) * 4 + 20
			
			items.append(_row)
			list_container.add_child(_row)


func _save_file(path: String):
	var _out_data: Dictionary = {}
	for _row: RowTemplate in items:
		var sub_dict = {_row.jp_text.text: _row.en_text.text}
		_out_data[_row.label.text] = sub_dict
	var _json_string = JSON.stringify(_out_data, "  ", false)
	#print(JSON.stringify(_out_data, "  ", false))
	var _file = FileAccess.open(file_name, FileAccess.WRITE)
	_file.store_string(_json_string)
	_file.close()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
