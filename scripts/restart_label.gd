extends Label

func _ready() -> void:
	await get_tree().process_frame
	pivot_offset = size / 2.0
	
func _process(delta: float) -> void:
	var t := Time.get_ticks_msec() / 1000.0
	scale = Vector2.ONE * (1.0 + 0.08 * sin(t * 5.0))
	rotation = 0.05 * sin(t * 3.0)
