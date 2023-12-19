extends Area2D
#var box3Item = preload("res://escenas/items/box_x3/box_x3.tscn")

var Items = ['box_x3','box_infinite']

signal connect_item_signal
#var isDroped = false
# Called when the node enters the scene tree for the first time.
func _ready():
	startTimer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		pass

func startTimer():
	$Timer.wait_time = randf_range(1,15)
	$Timer.start()

func _on_timer_timeout():
	_dropItem()
	startTimer()

func _dropItem():
	var random_item_name = Items[randi() % Items.size()]
	var sceneDirectory = load("res://escenas/items/"+ random_item_name +'/'+ random_item_name + '.tscn')
	var newItem = sceneDirectory.instantiate()
	add_child(newItem)
	var childIndex = len(get_children()) -1
	emit_signal("connect_item_signal",childIndex)
	
