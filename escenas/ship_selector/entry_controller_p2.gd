extends Node
signal change_right
signal change_left
signal get_ready

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed('left'):
		emit_signal('change_left')
	
	elif  Input.is_action_just_pressed('right'):
		emit_signal('change_right')

	if Input.is_action_just_pressed('ctrl_A'):
		emit_signal('get_ready')
