extends CanvasLayer

func _ready() -> void:
	EventBus.game_started.connect(_on_game_started)
	EventBus.game_over.connect(_on_game_over)
	EventBus.score_updated.connect(_on_score_updated)
	
	$Message.show()
	$Score.hide()
	$GameOver.hide()
	$BestScore.hide()
	$Restart.hide()

func _on_game_started() -> void:
	$Message.hide()
	$Score.show()
	$GameOver.hide()
	$BestScore.hide()
	$Restart.hide()

func _on_game_over() -> void:
	$BestScore.text = "Best: " + str(GameState.best_score)
	
	$Message.hide()
	$Score.show()
	$GameOver.show()
	$BestScore.show()
	
	await get_tree().create_timer(2.0).timeout
	$Restart.show()

func _on_score_updated(new_score: int) -> void:
	$Score.text = str(new_score)
