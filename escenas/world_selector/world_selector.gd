extends Node2D
@onready var world_background = $world_background
### Banderas de seleccion
var is_preselect_world=false
var world_select=false
#### Variables 
var selected_world=''
var preselected_world_node
#### Timer 
var timer_select_world

# Called when the node enters the scene tree for the first time.
func _ready():
	#Configuracion del timer
	timer_select_world=Timer.new()
	timer_select_world.wait_time=2
	timer_select_world.one_shot=true
	add_child(timer_select_world)
	
	#General muse entered
	$green_wolrd.connect("mouse_entered",_general_mouse_entered.bind('green_world', $green_wolrd/green_wolrd))
	$mundo2.connect("mouse_entered",_general_mouse_entered.bind('mundo2',$mundo2/mundo2 ))
	#General mouse exited
	$green_wolrd.connect("mouse_exited",_general_mouse_exited.bind('green_world'))
	$mundo2.connect("mouse_exited",_general_mouse_exited.bind('mundo2'))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if world_select ==  true:
		return
		
	if Input.is_action_just_pressed ("clickizq")and is_preselect_world==true:
			world_select=true
			#print('mundo seleccionado  ',selected_world)
			play_selection_animation()
			play_timer()

####################  Funciones de las señales  ####################

func _general_mouse_entered(current_node_name,current_node):
	preselected_world_node = current_node
	selected_world=current_node_name
	is_preselect_world=true
	play_pre_selection_animation()
	#print('entro a ',current_node_name)


func _general_mouse_exited(current_node_name):
	is_preselect_world = false
	cancel_pre_selection_animation()
	#print('salio de ',current_node_name )


############# Funciones para gestionar animaciones y timer ############

func play_timer():
	timer_select_world.start()
	await timer_select_world.timeout
	get_tree().change_scene_to_file('res://escenas/worlds/world.tscn')

func play_pre_selection_animation():
	if world_select:
		return
	preselected_world_node.play("pre_selection")
	world_background.play(selected_world)
	
func cancel_pre_selection_animation():
	if world_select:
		return
	preselected_world_node.play("default")
	world_background.play('empty')

func play_selection_animation():
	preselected_world_node.play("final_select")
