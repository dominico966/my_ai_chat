extends Control

@onready var user_input = $Panel/VSplitContainer/PanelContainer/HBoxContainer/UserInputTextEdit
@onready var chatlog_container = $Panel/VSplitContainer/ConversationPanel/ScrollContainer/ChatLogContainer
@onready var send_button = $Panel/VSplitContainer/PanelContainer/HBoxContainer/Button
var chat_message_scene = preload("res://components/chat_message.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event is InputEventKey:
		print_debug("event: %s" % [event])
		if user_input.has_focus() and (event.keycode == KEY_ENTER and event.pressed and event.shift_pressed):
			print_debug("TextEdit에서 누른 키: ", event.keycode)
			_on_button_pressed()

func _on_button_pressed() -> void:
	if not user_input.text:
		return;
		
	print_debug(user_input.text)
	var message = chat_message_scene.instantiate()
	chatlog_container.add_child(message)
	message.set_text(ChatMessage.TYPE.User, user_input.text)
	user_input.text = ""
	
	# 한 프레임 기다렸다가 스크롤 내려야 layout이 반영됨
	await get_tree().process_frame
	await get_tree().process_frame
	var scroll: ScrollContainer = chatlog_container.get_parent()  # ScrollContainer
	scroll.scroll_vertical = scroll.get_v_scroll_bar().max_value
