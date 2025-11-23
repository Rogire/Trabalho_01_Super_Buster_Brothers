extends Area2D
@export var VELOCITY : float
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	audio_stream_player_2d.play() 

func _physics_process(delta: float) -> void:
	position.y += VELOCITY*delta
	
func setVelocity_By_Factor(val:float):
	VELOCITY*=val


func _on_area_entered(_area: Area2D) -> void:
	queue_free()
