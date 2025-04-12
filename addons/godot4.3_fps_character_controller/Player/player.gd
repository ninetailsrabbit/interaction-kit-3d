class_name Player extends CharacterBody3D



@export_category("Player Settings")
@export var Move_Speed : float = 1.5
@export var Sprint_Speed : float = 10.0

@export var PlayerInventory : Array[Dictionary] = []

@export_category("Inputs")
# @export var UserInputForward : String = &"ui_up"
# @export var UserInputBackward : String = &"ui_down"
# @export var UserInputLeft : String = &"ui_left"
# @export var UserInputRight : String = &"ui_right"

@export var InputDictionary : Dictionary = {
	"Forward": "ui_up",
	"Backward": "ui_down",
	"Left": "ui_left",
	"Right": "ui_right",
	"Jump": "ui_accept",
	"Escape": "ui_cancel",
	"Sprint": "ui_accept",
	"Interact": "ui_accept"
}

@export_category("Mouse Settings")
@export_range(0.09, 0.1) var Mouse_Sens : float = 0.09
@export_range(1.0, 50.0) var Mouse_Smooth : float = 50.0

@export_category("Camera Settings")
@export_subgroup("Tilt Settings")
@export_range(0.0, 1.0) var TiltThreshhold : float = 0.2

# Onready
@onready var head : Node3D = $Head
@onready var camera : Camera3D = $Head/Camera3D
@onready var ltilt : Marker3D = $Tilt/LTilt
@onready var rtilt : Marker3D = $Tilt/RTilt


# Vectors
var direction : Vector3 = Vector3.ZERO
var Camera_Inp : Vector2 = Vector2()
var Rot_Vel : Vector2 = Vector2()

# Private
var _speed : float = Move_Speed
var _isMouseCaptured : bool = true

const JUMP_VELOCITY : float = 4.5

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	ltilt.rotation.z = TiltThreshhold
	rtilt.rotation.z = -TiltThreshhold

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Camera_Inp = event.relative
		
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed(InputDictionary["Escape"]) and _isMouseCaptured:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		_isMouseCaptured = false
	elif Input.is_action_just_pressed(InputDictionary["Escape"]) and not _isMouseCaptured:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		_isMouseCaptured = true


func _process(delta: float) -> void:
	# Camera Lock

	# Camera Smooth look
	Rot_Vel = Rot_Vel.lerp(Camera_Inp * Mouse_Sens, delta * Mouse_Smooth)
	head.rotate_x(-deg_to_rad(Rot_Vel.y))
	rotate_y(-deg_to_rad(Rot_Vel.x))
	head.rotation.x = clamp(head.rotation.x, -1.5, 1.5)
	Camera_Inp = Vector2.ZERO

	camera_tilt(delta)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed(InputDictionary["Jump"]) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	#	Modified standard input for smooth movements.
	var input_dir : Vector2 = Input.get_vector(InputDictionary["Left"], InputDictionary["Right"], InputDictionary["Forward"], InputDictionary["Backward"])
	direction = lerp(direction,(transform.basis * Vector3(input_dir.x,0,input_dir.y)).normalized(), delta * 7.0)
	_speed = lerp(_speed, Move_Speed, min(delta * 5.0, 1.0))
	Sprint()
	if direction:
		velocity.x = direction.x * _speed
		velocity.z = direction.z * _speed
	else:
		velocity.x = move_toward(velocity.x,0,_speed)
		velocity.z = move_toward(velocity.z,0,_speed)
	
	move_and_slide()

func Sprint() -> void:
	if Input.is_action_pressed(InputDictionary["Sprint"]):
		_speed = lerp(_speed, Sprint_Speed, 0.1)
	else:
		_speed = lerp(_speed, Move_Speed, 0.1)

func camera_tilt(delta: float) -> void:
	#	Camera Tilt
	if Input.is_action_pressed(InputDictionary["Left"]) and Input.is_action_pressed(InputDictionary["Right"]):
		camera.rotation.z = lerp_angle(camera.rotation.z, 0 , min(delta * 5.0,1.0))
	elif Input.is_action_pressed(InputDictionary["Left"]):
		camera.rotation.z = lerp_angle(camera.rotation.z, ltilt.rotation.z , min(delta * 5.0,1.0))
	elif Input.is_action_pressed(InputDictionary["Right"]):
		camera.rotation.z = lerp_angle(camera.rotation.z, rtilt.rotation.z , min(delta * 5.0,1.0))
	else:
		camera.rotation.z = lerp_angle(camera.rotation.z, 0 , min(delta * 5.0,1.0))
