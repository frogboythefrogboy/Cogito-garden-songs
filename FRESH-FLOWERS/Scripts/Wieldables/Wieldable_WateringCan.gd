extends Wieldable 

@export var water_capacity: float = 100.0
@export var drainage_rate: float = 1.0
var current_water_level: float

func action_primary(is_pressed, is_released):
	print("Watering Can: Primary action")
	if is_pressed:
		start_watering()
	elif is_released:
		stop_watering()

var is_watering: bool = false
var watering_timer: Timer

func _ready():
	super()
	current_water_level = water_capacity
	watering_timer = Timer.new()
	watering_timer.wait_time = 1.0  # Adjust this to change how often water is used
	watering_timer.one_shot = false
	watering_timer.timeout.connect(_on_watering_timer_timeout)
	add_child(watering_timer)

var original_rotation: Vector3

func start_watering():
	if not is_watering:
		is_watering = true
		original_rotation = rotation_degrees
		rotate_x(45)
		watering_timer.start()

func stop_watering():
	if is_watering:
		is_watering = false
		rotation_degrees = original_rotation
		watering_timer.stop()

func _on_watering_timer_timeout():
	use_water()

func use_water():
	if current_water_level > 0:
		current_water_level -= drainage_rate
		if current_water_level < 0:
			current_water_level = 0
		print("Watering Can: Used water. Current water level: ", current_water_level)
	else:
		print("Watering Can: Can is empty.")

# Function called when wieldable is unequipped.
func equip(_player_interaction_component: PlayerInteractionComponent):
	wieldable_mesh.show()
	player_interaction_component = _player_interaction_component
	print("Wieldable equipped")
	pass


# Function called when wieldable is unequipped.
func unequip():
	wieldable_mesh.hide()
	print("Wieldable unequipped")
	pass