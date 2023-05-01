extends Node2D
var engineGlow
var healthGlow
var sheildGlow
var engineindicator
var healthindicator
var sheildsindicator
@export var timetofinish=8000
var score = 0 
@export var health = 200
@export var sheilds= 200 
# Called when the node enters the scene tree for the first time.
var mediumShip =preload("res://enemies/enemymed.tscn")
var smallShip=preload("res://enemies/enemySmall.tscn")
var tinyShip=preload("res://enemies/enemytiny.tscn")
var bigShip=preload("res://enemies/enemylrg.tscn")
var playerShip

var hardships=[mediumShip,smallShip,tinyShip,bigShip, smallShip, smallShip, smallShip, tinyShip, tinyShip]

var easyships=[mediumShip,smallShip,smallShip,tinyShip]

@export var islevel2=true


func addScore(val):
	score+=val
	$CanvasLayer/Control/scorebox/scorenum.text=str(score)

func _ready():
	randomize()
	engineGlow= $CanvasLayer/Control/engineglow
	healthGlow = $CanvasLayer/Control/healthglow
	sheildGlow = $"CanvasLayer/Control/sheilds glow"
	engineindicator = $CanvasLayer/Control/engine
	healthindicator = $CanvasLayer/Control/health
	sheildsindicator =$CanvasLayer/Control/sheilds
	playerShip=$player
	print(playerShip)
	generateWave()
	$intro.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("jump"):
		if engineGlow.scale < Vector2(.3,.3):
			engineindicator.set_color(Color(1,1,1,1))
			engineGlow.scale+=Vector2(.01,.01)
		pass
	else :
		if engineGlow.scale > Vector2(.15,.15):
			engineindicator.set_color(Color(.3,.3,.3,1))
			engineGlow.scale-=Vector2(.01,.01)

#$func _input(event):
#	if event.is_action_pressed("jump"):
#		pass
func get_random_item(array):
	var random_index = randi_range(0, array.size() - 1)
	return array[random_index]

func _on_timer_timeout():
	timetofinish=timetofinish-1
	$CanvasLayer/Control/altitude/TextureRect/Label.text=str(timetofinish)
	if timetofinish<=0:
		if !islevel2:
			get_tree().change_scene_to_file("res://world_2.tscn")
		else:
			get_tree().change_scene_to_file("res://outro.tscn")
		pass
	#$Timer.start()
	pass # Replace with function body.


func _on_player_damage_taken(amount, is_shield):
	#print(is_shield)
	sheilds-=amount
	if sheilds < 50 :
		$CanvasLayer/Control/engine/warning.visible=true
		pass
	if sheilds <=0:
		sheilds=0 
		$player.sheildEnabled=false
		is_shield=false
	
	if !is_shield:
		health-=amount
		
		
		if health<=0:
			#explode ship and restart level
			restart_current_scene()
			pass
		pass
	print(health, ":", sheilds)
	$CanvasLayer/Control/sheilds.size.y=map_value_to_volume(sheilds)
	$CanvasLayer/Control/health.size.y=map_value_to_volume(health)
	pass # Replace with function body.

func map_value_to_volume(value):
	var min_value = 0.0
	var max_value = 200.0
	var min_volume = 0.0
	var max_volume = 60.0
	var ratio = (value - min_value) / (max_value - min_value)
	return lerp(min_volume, max_volume, ratio)

func generateWave():
	var wave=[]
	
	if !islevel2:
		var random_number = randi_range(3, 7)
		for i in range(random_number):
			wave.append(get_random_item(easyships))
	else:
		var random_number = randi_range(5, 10)
		for i in range(random_number):
			wave.append(get_random_item(hardships))
	spawnWave(wave)
	pass




func spawnWave(wave):
	print(wave)
	for each in wave:
		var ship = each.instantiate()
		
		var random_number = randi_range(1, 2)
		var yvalue=randi_range(-500,500)
		if random_number==1:
			ship.global_position = Vector2(playerShip.global_position.x-1500,playerShip.global_position.y+yvalue)
			ship.setinitialize(playerShip)
		else:
			ship.global_position = Vector2(playerShip.global_position.x+1500,playerShip.global_position.y+yvalue)
			ship.setinitialize(playerShip)
		$enemies.add_child(ship)
		
		pass
	pass





func _on_ballarea_body_entered(body):
	if body.is_in_group("rocket"):
		body.destruct()
	pass # Replace with function body.


func _on_wave_timeout():
	if $enemies.get_child_count() <= 20:
		generateWave()
	pass # Replace with function body.


func _on_sheildcharge_timeout():
	if sheilds < 200:
		sheilds+=2
	if sheilds > 200:
		sheilds=200
	if sheilds>=50:
		$CanvasLayer/Control/engine/warning.visible=false
	$CanvasLayer/Control/sheilds.size.y=map_value_to_volume(sheilds)
	#print("UPDATE ",sheilds)
	pass # Replace with function body.
	
func restart_current_scene():
	get_tree().reload_current_scene()


func _on_intro_finished():
	$loop.play()
	$loop.set_autoplay(true)

	pass # Replace with function body.
