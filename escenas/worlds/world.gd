extends Node2D

@onready var P1 = $player1
@onready var P2 = $player2
@onready var ui = $MarginContainer
@onready var Spawner = $ItemSpawner
var p1_perfect = true
var p2_perfect = true
var p1_is_die = false
var p2_is_die = false
var some_one_wins = false
var local_is_draw = false
var wins_timer
var draw_timer
#Timers de recarga de balas
var reLoadShotP1Timer
var reLoadShotP2Timer

#Diccionarios indexados para de los timers de los power UPS
var Players_box_x3_timers = {}
var Players_box_infinite_timers ={}

# Called when the node enters the scene tree for the first time.
func _ready():
	
	hide_wins_animation() # Ocultamos las animaciones de WIN
	
	# Wins timer
	wins_timer = Timer.new()
	add_child(wins_timer)
	wins_timer.connect('timeout',_on_wins)
	wins_timer.wait_time = 3
	
	# DRAW timer
	draw_timer = Timer.new()
	draw_timer.wait_time = 0.2
	draw_timer.one_shot = true
	add_child(draw_timer)
	
	#Connect Signals
	#Spawner 
	Spawner.connect('connect_item_signal',_on_connect_item_signal)
	
	################## Players #####################
	
		####### Seteamos las vidas de nestros jugadores #####

	if Global.is_draw:
		P1.set_lives(1)
		P2.set_lives(1)
		Global.is_draw = false
		local_is_draw = true
	else:
		P1.set_lives(3)
		P2.set_lives(3)
	
	#Set LiveCounter
	ui.set_initial_lives_counter(P1.get_lives(),P2.get_lives())
	P1.connect('update_p1_lives_counter',_on_update_p1_lives_counter)
	P2.connect('update_p2_lives_counter',_on_update_p2_lives_counter)
	
	#Signals for update Shots bar
	P1.connect('update_shots_bar_p1',_on_update_shots_bar_p1)
	P2.connect('update_shots_bar_p2',_on_update_shots_bar_p2)
	
	#Signal for player die
	P1.connect('p1_die',_on_p1_die)
	P2.connect('p2_die',_on_p2_die)
	
	
	#Connect stop all timers
	P1.connect('stop_timers',_on_stopTimers)
	P2.connect('stop_timers',_on_stopTimers)

	#Timer for reload Shots
	#For player 1
	reLoadShotP1Timer = Timer.new()
	add_child(reLoadShotP1Timer)
	reLoadShotP1Timer.connect('timeout',on_reload_shot_p1_timeout)
	reLoadShotP1Timer.wait_time = 0.3
	reLoadShotP1Timer.one_shot = true
	
	#For player 2
	reLoadShotP2Timer = Timer.new()
	add_child(reLoadShotP2Timer)
	reLoadShotP2Timer.connect('timeout',on_reload_shot_p2_timeout)
	reLoadShotP2Timer.wait_time = 0.3
	reLoadShotP2Timer.one_shot = true
	
	#Stop timer reload shots
	#For player1
	P1.connect('stop_reload_shots_p1',on_stop_reload_shots_p1)
	#For player2
	P2.connect('stop_reload_shots_p2',on_stop_reload_shots_p2)
	
	
	# Conectar Timers y señales para los buffos
	########## BOX_X3 #################
	for i in range(2):
		var box3BuffTimer = Timer.new()
		add_child(box3BuffTimer)
		box3BuffTimer.connect('timeout',_on_timeout_box_x3_timer.bind(i),i)
		Players_box_x3_timers[i] = box3BuffTimer
		
	########## BOX INFINITE ##############
	for i in range(2):
		var box_infinite_buff_timer = Timer.new()
		add_child(box_infinite_buff_timer)
		box_infinite_buff_timer.connect('timeout',_on_timeout_box_infinite_timer.bind(i),i)
		Players_box_infinite_timers[i] = box_infinite_buff_timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

########### WINS ANIMATIONS  ############
func hide_wins_animation():
	$black_background.visible = false
	$p1_wins.stop()
	$p1_wins.visible = false
	$p2_wins.stop()
	$p2_wins.visible = false
	$draw.visible = false
	$perfect.visible = false

func show_wins_animation(player_index):
	#Timer de empate
	draw_timer.start()
	await draw_timer.timeout
	
	$black_background.visible = true
	if some_one_wins:
		return
	if p1_is_die and p2_is_die:
		$draw.visible = true
		$draw.play("default")
		Global.is_draw = true
		some_one_wins = true
		return
		
	if player_index == 0:
		$p1_wins.visible = true
		$p1_wins.play("default")
	else:
		$p2_wins.visible = true
		$p2_wins.play("default")
	
	if local_is_draw != true and (p1_perfect or p2_perfect):
		$perfect.visible = true
		$perfect.play("default")
		
	some_one_wins = true
	
################# WINS ############

func _on_wins():
	if Global.is_draw:
		get_tree().change_scene_to_file("res://escenas/worlds/world.tscn")
	else:
		get_tree().change_scene_to_file("res://escenas/ship_selector/ship_selector.tscn")


 ########## UPDATE LIVES COUNTER #########
func _on_update_p1_lives_counter():
	ui.update_lives_counter_p1(P1.get_lives())
	p1_perfect= false


func _on_update_p2_lives_counter():
	ui.update_lives_counter_p2(P2.get_lives())
	p2_perfect= false


########## UPDATE SHOTS BAR #########
func _on_update_shots_bar_p1(startTimer):
	ui.update_shots_bar_p1(P1.get_shots())
	
	if startTimer:
		reLoadShotP1Timer.start()
	
func _on_update_shots_bar_p2(startTimer):
	ui.update_shots_bar_p2(P2.get_shots())
	
	if startTimer:
		reLoadShotP2Timer.start()


########## RELOAD SHOTS TIMEOUT #########

func on_reload_shot_p1_timeout():
	if P1.get_shots() < 10:
		P1.add_shots(1)
		ui.update_shots_bar_p1(P1.get_shots())
		reLoadShotP1Timer.start()
		

func on_reload_shot_p2_timeout():
	if P2.get_shots() < 10:
		P2.add_shots(1)
		ui.update_shots_bar_p2(P2.get_shots())
		reLoadShotP2Timer.start()

######### STOP RELOAD SHOTS FOR PLAYERS ########

func on_stop_reload_shots_p1():
	reLoadShotP1Timer.stop()
	
func on_stop_reload_shots_p2():
	reLoadShotP2Timer.stop()


########## SPAWNER AND ITEMS #########

func _on_connect_item_signal(item_index):
	var item = Spawner.get_child(item_index)
	item.connect("destroy_item",_on_destroy_item)


func _on_destroy_item(nameItem,direccion):

	if nameItem == 'box_x3':
		
		if direccion == 1:
			_start_box_x3_timer(0)
		else:
			_start_box_x3_timer(1)
			
	elif nameItem == 'box_infinite':
		
		if direccion == 1:
			_start_box_infinite_timer(0)
		else:
			_start_box_infinite_timer(1)


################# POWER UPS ##################


################### BOX 3 #########################

func _start_box_x3_timer(player_index):
	if player_index == 0:
		P1.add_item('box_x3')
		_calculate_extra_shots(0,5)
		_on_update_shots_bar_p1(false)
		ui.add_box3_icon_P1()
	else: 
		P2.add_item('box_x3')
		_calculate_extra_shots(1,5)
		_on_update_shots_bar_p2(false)
		ui.add_box3_icon_P2()

	Players_box_x3_timers[player_index].wait_time = 5
	Players_box_x3_timers[player_index].one_shot = true
	Players_box_x3_timers[player_index].start()

###### TIMEOUT BOX3
func _on_timeout_box_x3_timer(player_index):
	
	if player_index == 0:
		ui.delete_box3_icon_P1()
		P1.remove_item('box_x3')
	else:
		ui.delete_box3_icon_P2()
		P2.remove_item('box_x3')

################### BOX INFINITE #########################

func _start_box_infinite_timer(player_index):
	if player_index == 0:
		P1.add_item('box_infinite')
		P1.set_shots(10)
		_on_update_shots_bar_p1(false)
		ui.add_box_infinite_P1()
		
	elif player_index == 1:
		P2.add_item('box_infinite')
		P2.set_shots(10)
		_on_update_shots_bar_p2(false)
		ui.add_box_infinite_P2()
		
		
	Players_box_infinite_timers[player_index].wait_time = 3
	Players_box_infinite_timers[player_index].one_shot = true
	Players_box_infinite_timers[player_index].start()


###### TIMEOUT BOX INFINITE

func _on_timeout_box_infinite_timer(player_index):
	if player_index == 0:
		P1.remove_item('box_infinite')
		ui.delete_box_infinite_icon_P1()
		
		
	elif player_index == 1:
		P2.remove_item('box_infinite')
		ui.delete_box_infinite_icon_P2()
		

################## Die functions  #################
func _on_p1_die():
	p1_is_die = true

func _on_p2_die():
	p2_is_die = true
	
	
#################### STOP ALL TIMERS ###########################
func _on_stopTimers(player_index):
	Players_box_x3_timers[player_index].stop()
	Players_box_infinite_timers[player_index].stop()
	
	if player_index == 0:
		reLoadShotP1Timer.stop()
		show_wins_animation(1)
		wins_timer.start()
		
	else:
		reLoadShotP2Timer.stop()
		show_wins_animation(0)
		wins_timer.start()



################################# OTHERS ##############################

func _calculate_extra_shots(player_index,extra_shots):
	
	if player_index == 0:
		if P1.get_shots() + extra_shots <=10:
			P1.add_shots(extra_shots)
		else:
			P1.set_shots(10)
		
	else:
		if P2.get_shots() + extra_shots <=10:
			P2.add_shots(extra_shots)
		else:
			P2.set_shots(10)



