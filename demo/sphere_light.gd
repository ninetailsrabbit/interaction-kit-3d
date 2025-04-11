class_name SphereLight extends MeshInstance3D

## Set to zero to allow infinite amount of times
@export var interaction_times: int = 0

@export var interactable_3d: Interactable3D
@export var omni_light_3d: OmniLight3D
@export var label_3d: Label3D


func _ready() -> void:
	interactable_3d.number_of_times_can_be_interacted = interaction_times
	interactable_3d.interacted.connect(on_sphere_interacted)
	
	if interaction_times > 0 and label_3d:
		label_3d.visible = interaction_times > 0
		update_remaining_interactions()


func update_remaining_interactions() -> void:
	if label_3d:
		label_3d.text = "%d times remaining" % (interaction_times - interactable_3d.times_interacted)
		
		if not interactable_3d.can_be_interacted and interactable_3d.deactive_after_reach_interaction_limit:
			label_3d.text += " [Focus & Interaction disabled]"


func on_sphere_interacted() -> void:
	omni_light_3d.visible = !omni_light_3d.visible
	update_remaining_interactions()
