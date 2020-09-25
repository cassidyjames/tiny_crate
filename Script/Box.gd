tool
extends Actor
class_name Box

var is_pushed = false

var last_floor := false

var node_audio : AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.editor_hint:
		return
	
	node_audio = $AudioHit
	
	if is_area_solid(position.x, position.y + 1):
		is_on_floor = true
		last_floor = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.editor_hint:
		return
	
	if is_on_floor and not last_floor:
		speed_x = 0
		node_audio.pitch_scale = 1 + rand_range(-0.2, 0.2)
		node_audio.play()
	last_floor = is_on_floor
	
	is_pushed = false


# push box
func push(dir : int):
	if is_pushed:
		return
	is_pushed = true
	
	# check for box at destination
	if is_area_solid(position.x + dir, position.y):
		for a in check_area_actors("box", position.x + dir):
			a.push(dir)
	
	# check for box above
	if not is_area_solid(position.x + dir, position.y):
		for a in check_area_actors("box", position.x, position.y - 1):
			a.push(dir)
		move_x(dir)
