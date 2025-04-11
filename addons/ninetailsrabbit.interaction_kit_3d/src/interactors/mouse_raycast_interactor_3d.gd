class_name MouseRayCastInteractor3D extends Node3D

@export var origin_camera: Camera3D
@export var ray_length: float = 100.0
@export var interact_mouse_button = MOUSE_BUTTON_LEFT
@export var cancel_interact_input_action: StringName = &"cancel_interaction"

@onready var current_camera: Camera3D = origin_camera:
	set(new_camera):
		if new_camera != current_camera:
			current_camera = new_camera
			
			set_process_unhandled_input(current_camera is Camera3D)
			set_process(current_camera is Camera3D)

var current_interactable: Interactable3D
var focused: bool = false
var interacting: bool = false
var mouse_position: Vector2 = Vector2.ZERO


func _unhandled_input(event: InputEvent) -> void:
	if is_processing() and current_camera is Camera3D:
		if event is InputEventMouseMotion:
			mouse_position = event.position
		
		if interact_mouse_button == MOUSE_BUTTON_LEFT and InteractionKit3DPluginUtilities.is_mouse_left_click(event) \
			or interact_mouse_button == MOUSE_BUTTON_RIGHT and InteractionKit3DPluginUtilities.is_mouse_right_click(event):
				interact(current_interactable)
	
	if is_processing() and InputMap.has_action(cancel_interact_input_action) and Input.is_action_just_pressed(cancel_interact_input_action) and current_interactable is Interactable3D:
		cancel_interact(current_interactable)


func _ready() -> void:
	set_process_unhandled_input(current_camera is Camera3D)
	set_process(current_camera is Camera3D)
	

func _process(_delta: float) -> void:
	var detected_interactable = get_detected_interactable()
	
	if detected_interactable:
		if current_interactable == null and not focused:
			focus(detected_interactable)
	else:
		if focused and not interacting and current_interactable:
			unfocus(current_interactable)


func get_detected_interactable():
	var world_space := get_world_3d().direct_space_state
	var from := origin_camera.project_ray_origin(mouse_position)
	var to := from + origin_camera.project_ray_normal(mouse_position) * ray_length
	
	var ray_query = PhysicsRayQueryParameters3D.create(
		from, 
		to,
		1 | ProjectSettings.get_setting(InteractionKit3DPluginSettings.InteractablesCollisionLayerSetting) | ProjectSettings.get_setting(InteractionKit3DPluginSettings.GrabbablesCollisionLayerSetting) 

	)
	
	ray_query.collide_with_areas = true
	ray_query.collide_with_bodies = true
	
	var result := world_space.intersect_ray(ray_query)
	
	if InteractionKit3DPluginUtilities.is_mouse_visible() and result.has("collider") and result["collider"] is Interactable3D:
		return result.collider as Interactable3D
		
	return null


func interact(interactable: Interactable3D):
	if interactable:
		interacting = true
		
		interactable.interacted.emit()
	

func cancel_interact(interactable: Interactable3D = current_interactable):
	if interactable:
		interacting = false
		focused = false
		
		
		interactable.canceled_interaction.emit()
		

func focus(interactable: Interactable3D):
	current_interactable = interactable
	focused = true
	
	interactable.focused.emit()
	
	
func unfocus(interactable: Interactable3D = current_interactable):
	if interactable and focused:
		current_interactable = null
		focused = false
		interacting = false

		interactable.unfocused.emit()


func change_camera_to(new_camera: Camera3D) -> void:
	current_camera = new_camera


func return_to_original_camera() -> void:
	change_camera_to(origin_camera)


func activate() -> void:
	set_process(true)
	set_process_unhandled_input(true)
	

func deactivate() -> void:
	set_process(false)
	set_process_unhandled_input(false)
	

func on_canceled_interaction(_interactable: Interactable3D) -> void:
	interacting = false
	focused = false
