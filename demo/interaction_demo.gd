extends Node3D


@onready var interactable_information: RichTextLabel = %InteractableInformation

@onready var dot_cursor: Control = $InteractableInformation/Control/CenterContainer/DotCursor


func _ready() -> void:
	interactable_information.text = ""
	
	for interactable: Interactable3D in get_tree().get_nodes_in_group(Interactable3D.GroupName):
		interactable.focused.connect(on_interactable_focused.bind(interactable))
		interactable.unfocused.connect(on_interactable_unfocused.bind(interactable))


func on_interactable_focused(interactable: Interactable3D) -> void:
	dot_cursor.focused = true
	interactable_information.text = "[i]%s[/i]" % interactable.title


func on_interactable_unfocused(_interactable: Interactable3D) -> void:
	dot_cursor.focused = false
	
	interactable_information.clear()
	interactable_information.text = ""
