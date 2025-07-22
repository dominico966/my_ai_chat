extends Control
class_name ChatMessage

@onready var label = $HBoxContainer/Label
@onready var left_spacer = $HBoxContainer/LeftSpacer
@onready var right_spacer = $HBoxContainer/RightSpacer

enum TYPE {
	AI, User
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_text(type: TYPE, text: String):
	print_debug(text)
	#label.text = "%s" % [text]
	label.text = text
	match type:
		TYPE.AI:
			right_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		TYPE.User:
			left_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
