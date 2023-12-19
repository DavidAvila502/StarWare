extends Node
var selected_character_p1 = "res://escenas/ships/yellow_beetle/yellow_beetle.tscn"
var selected_character_p2 = "res://escenas/ships/yellow_beetle/yellow_beetle.tscn"
var is_draw = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func sound_shoot():
	$ShootSound.play()

func sound_hit():
	$HitSound.play()

func sound_destroy():
	$DestroySound.play()
	
func sound_item():
	$ItemSound.play()
