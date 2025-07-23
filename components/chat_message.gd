extends Control
class_name ChatMessage

@onready var label = $HBoxContainer/LabelContainer/MarginContainer/Label
@onready var left_spacer = $HBoxContainer/LeftSpacer
@onready var right_spacer = $HBoxContainer/RightSpacer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.custom_minimum_size.x = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_text(text: String):
	print_debug(text)
	#label.text = "%s" % [text]
	label.text = text
	var font: Font = label.get_theme_default_font()
	var text_size = font.get_string_size(label.text)
	label.custom_minimum_size.x = min(get_viewport_rect().size.x * 0.5, text_size.x)
	if label.custom_minimum_size.x < text_size.x:
		label.autowrap_mode = TextServer.AutowrapMode.AUTOWRAP_WORD_SMART
	left_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
