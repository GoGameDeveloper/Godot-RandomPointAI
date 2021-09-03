extends KinematicBody

onready var nav : Navigation = get_parent().get_parent()
var path : Array = []
var path_node : int = 0
var speed : int = 7
const GRAVITY : int = 10
var vertical_vel : Vector3 = Vector3()
var target_to_follow : Vector3 = Vector3()

func _ready():
	randomize()


func move_down(delta):
	if not is_on_floor():
		vertical_vel.y -= GRAVITY * delta

func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, nav.get_closest_point(target_pos))
	path_node = 0



func _physics_process(delta):
	move_down(delta)
	if path_node < path.size():
		var direction = (path[path_node] - global_transform.origin)
		if direction.length() < 1:
			path_node += 1
		else:
			move_and_slide((direction.normalized() * speed) + vertical_vel, Vector3.UP)



func get_random_pos_in_sphere (radius : float) -> Vector3:
	var x1 = rand_range (-1, 1)
	var x2 = rand_range (-1, 1)

	while x1*x1 + x2*x2 >= 1:
		x1 = rand_range(-1, 1)
		x2 = rand_range(-1, 1)

	var random_pos_on_unit_sphere = Vector3 (
	2 * x1 * sqrt(1 - x1*x1 - x2*x2),
	2 * x2 * sqrt(1 - x1*x1 - x2*x2),
	1 - 2 * (x1*x1 + x2*x2))

	return random_pos_on_unit_sphere * rand_range (0, radius)


func _on_Timer_timeout():
	target_to_follow = Vector3(get_random_pos_in_sphere(80).x,0,get_random_pos_in_sphere(80).z) + get_parent().global_transform.origin
	move_to(target_to_follow)
	print(target_to_follow)
