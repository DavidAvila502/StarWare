extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$top_selector.connect('animation_finished',_on_transition_finished)
	$bottom_selector.connect("animation_finished",_on_transition_finished)
	$ready.visible = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_player(player_index):
	if player_index == 0:
		pass
	elif  player_index == 1:
		$right_arrow.play("p2")
		$left_arrow.play("p2")
		$player_icon.play("p2")
		$ready.play('p2')

func play_default():
	$top_selector.play("default")
	$bottom_selector.play('default')

func play_transition():
	$top_selector.play("transition")
	$bottom_selector.play('transition')
	
func _on_transition_finished():
		$top_selector.play("default")
		$bottom_selector.play('default')
		
func play_infinite_transition():
	$top_selector.stop()
	$bottom_selector.stop()
	$top_selector.play("infinite_transition")
	$bottom_selector.play('infinite_transition')

func get_ready():
	$ready.visible = true
	
func cancel_ready():
	$ready.visible = false
	
	
