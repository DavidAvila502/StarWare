extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	$AnimatedSprite2D2.play("default")
	await $AnimatedSprite2D2.animation_finished
	get_tree().change_scene_to_file("res://escenas/ship_selector/ship_selector.tscn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


