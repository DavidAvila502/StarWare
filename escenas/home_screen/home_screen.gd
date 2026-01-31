extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		if Input.is_action_just_released("ui_accept") or Input.is_action_just_released("ctrl_A"):
			
			$AnimatedSprite2D.play("spaces")
			await  $AnimatedSprite2D.animation_finished
			get_tree().change_scene_to_file("res://escenas/loading_screen/loading_screen.tscn")
			
			
