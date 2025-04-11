extends Node3D


@onready var interactable_information: RichTextLabel = %InteractableInformation
@onready var dot_cursor: Control = $InteractableInformation/Control/CenterContainer/DotCursor
@onready var spawn_point: Marker3D = %SpawnPoint


func _ready() -> void:
	interactable_information.text = ""
	
	GlobalInteractionEvents.interactable_focused.connect(on_interactable_focused)
	GlobalInteractionEvents.interactable_unfocused.connect(on_interactable_unfocused)
	
	for i in 100:
		var grabbable = Grabbable3D.new()
		var mesh: MeshInstance3D = MeshInstance3D.new()
		grabbable.mesh_instance = mesh
		grabbable.mass = randf_range(0.25, 1.5)
		grabbable.add_child(mesh)
		
		match randi_range(1, 4):
			1:
				mesh.mesh = BoxMesh.new()
				mesh.mesh.size = Vector3.ONE * randf_range(0.1, 0.6)
			2:
				mesh.mesh = SphereMesh.new()
				mesh.mesh.radius = randf_range(0.25, 0.35)
				mesh.mesh.height = mesh.mesh.radius * 2.0
			3:
				mesh.mesh = CapsuleMesh.new()
				mesh.mesh.radius = randf_range(0.1, 0.25)
				mesh.mesh.height = mesh.mesh.radius * 4.0
			4:
				mesh.mesh = PrismMesh.new()
				mesh.mesh.size = Vector3.ONE * randf_range(0.3, 0.5)
				
		var collision := CollisionShape3D.new()
		collision.shape = mesh.mesh.create_convex_shape()
		grabbable.add_child(collision)
		
		spawn_point.add_child(grabbable)
		grabbable.position = Vector3(randf_range(-6.0, 6.0), randf_range(-10.0, 1.0), 0)
	
	
func on_interactable_focused(interactable: Interactable3D) -> void:
	dot_cursor.focused = true
	interactable_information.text = "[i]%s[/i]" % interactable.title


func on_interactable_unfocused(_interactable: Interactable3D) -> void:
	dot_cursor.focused = false
	
	interactable_information.clear()
	interactable_information.text = ""
