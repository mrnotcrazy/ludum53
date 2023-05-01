extends Node2D
var step=0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_pressed():
	get_tree().change_scene_to_file("res://intro.tscn")
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_how_pressed():
	step=1
	tutorial()
	pass # Replace with function body.


func _on_next_pressed():
	step+=1
	if step >=4:
		step = 0
	tutorial()
	pass # Replace with function body.

func tutorial():
	match step:
		0:
			$tuts.visible=false
			$tuts/Tut3.visible=false
			$tuts/Tuts2.visible=false
		1:
			$tuts.visible=true
			$tuts/Tut1.visible=true
		2:
			$tuts/Tuts2.visible=true
		3:
			$tuts/Tut3.visible=true
			
	pass
