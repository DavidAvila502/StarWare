extends Node

signal move_up
signal move_down
signal start_charge
signal shoot



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_pressed('up'):
		emit_signal('move_up')
	
	if Input.is_action_pressed('down'):
		emit_signal('move_down')
	
	#Si preciona espacio iniciamos la carga
	if Input.is_action_pressed('ctrl_A'):
		emit_signal('start_charge')
		
	#Si suelta espacio disparamos con la carga acomulada
	if Input.is_action_just_released('ctrl_A'):
		emit_signal('shoot')
	
	
