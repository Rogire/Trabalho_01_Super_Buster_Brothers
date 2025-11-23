extends Area2D
@export var VELOCITY : float

func _ready() -> void:
	pass 

func _physics_process(delta: float) -> void:
	position.y += VELOCITY*delta
	
func setVelocity_By_Factor(val:float):
	VELOCITY*=val


func _on_area_entered(_area: Area2D) -> void:
	queue_free()
