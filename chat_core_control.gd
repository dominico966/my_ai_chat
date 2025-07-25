extends Control

@export var openai_endpoint : LineEdit
@export var openai_token : LineEdit
@export var user_input : TextEdit
@export var chatlog_container : VBoxContainer
@export var send_button : Button

var chat_message_scene = preload("res://components/chat_message.tscn")
var ai_response_scene = preload("res://components/ai_response.tscn")

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
	var message : ChatMessage = chat_message_scene.instantiate()
	chatlog_container.add_child(message)
	message.set_text(user_input.text)
	send_chat_completion(user_input.text)
	user_input.text = ""
	
	_refresh_scroll()
	user_input.grab_focus()
	

func send_chat_completion(user_message : String):
	var messages := [
		{ "role": "system", "content": "You are a helpful assistant." },
		{ "role": "user", "content": user_message }
	]

	var body = {
		"model": "gpt-3.5-turbo",  # 또는 llama.cpp에서는 "gpt-3.5-turbo"로 이름만 맞추면 됨
		"messages": messages,
		"temperature": 0.5
	}

	var json_body = JSON.stringify(body)

	var headers = [
		"Content-Type: application/json"
	]
	
	if openai_token.text != "":
		headers.append("Authorization: Bearer %s" % openai_token.text)

	var http := HTTPRequest.new()
	add_child(http)

	http.request_completed.connect(_on_request_completed)
	var err = http.request(openai_endpoint.text, headers, HTTPClient.METHOD_POST, json_body)

	if err != OK:
		push_error("Failed to send request: %s" % err)

func _on_request_completed(result, response_code, headers, body):
	if response_code != 200:
		push_error("Error: %s" % response_code)
		return

	var json = JSON.parse_string(body.get_string_from_utf8())
	if json == null:
		push_error("Invalid JSON response")
		return

	var reply = json["choices"][0]["message"]["content"]
	print_debug("💬 ChatGPT: %s" % reply)
	
	var message : AiResponse = ai_response_scene.instantiate()
	chatlog_container.add_child(message)
	message.set_text(reply)
	message.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_refresh_scroll()
	
func _refresh_scroll():
	# 한 프레임 기다렸다가 스크롤 내려야 layout이 반영됨
	await get_tree().process_frame
	await get_tree().process_frame
	var scroll: ScrollContainer = chatlog_container.get_parent()  # ScrollContainer
	scroll.scroll_vertical = scroll.get_v_scroll_bar().max_value
