class_name RowTemplate
extends HBoxContainer

@export var label: Label
@export var jp_text: TextEdit
@export var en_text: TextEdit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	en_text.text_changed.connect(_on_text_changed)


func _on_text_changed():
	en_text.syntax_highlighter.update_cache()
	en_text.queue_redraw()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
