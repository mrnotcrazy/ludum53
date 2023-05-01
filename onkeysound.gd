extends AudioStreamPlayer



func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_pressed("jump"):
		if not playing:
			play()
	else:
		stop()
