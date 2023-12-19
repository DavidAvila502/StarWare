extends Node
signal change_right
signal change_left
signal get_ready

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed('ui_a'):
		emit_signal('change_left')
	
	elif  Input.is_action_just_pressed('ui_d'):
		emit_signal('change_right')
		
	if Input.is_action_just_pressed('ui_accept'):
		emit_signal('get_ready')
