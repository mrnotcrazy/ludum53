extends Line2D
@export  var line1s = [Node]

# Called when the node enters the scene tree for the first time.
func _ready():
	for each in line1s:
		add_point(get_node(each).global_position)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var i=0
	for each in line1s:
		set_point_position(i,get_node(each).global_position)
		i+=1
		
	pass

func reset():
	clear_points()
	for each in line1s:
		add_point(get_node(each).global_position)
