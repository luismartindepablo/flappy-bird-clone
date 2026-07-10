extends Node

const SAVE_PATH := "user://save.cfg"

enum Phase { MENU, PLAYING, DEAD }
var phase: Phase = Phase.MENU

var score: int = 0
var best_score: int = 0

func _ready() -> void:
	_load()
	EventBus.game_started.connect(_on_game_started)
	EventBus.game_over.connect(_on_game_over)

func _on_game_started() -> void:
	phase = Phase.PLAYING

func _on_game_over() -> void:
	phase = Phase.DEAD
	if score > best_score:
		best_score = score
		_save()

func _on_game_reset() -> void:
	phase = Phase.MENU
	score = 0
	
func update_score() -> void:
	score += 1
	EventBus.score_updated.emit(score)

func _save() -> void:
	var config := ConfigFile.new()
	config.set_value("data", "best_score", best_score)
	config.save(SAVE_PATH)

func _load() -> void:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) == OK:
		best_score = config.get_value("data", "best_score", 0)
