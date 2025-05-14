extends Node

var game_running: bool = false
var worms: int = 0
var worms_collected:int = 0
var game_over:bool = false
var level_number:int = 1


func add_worm():
	worms += 1

func reset_worms_amount():
	worms = 0


func start_game():
	worms = 0
	game_over = false
	game_running = true
	
	
func  stop_game():
	game_over = true
	game_running = false
	worms_collected = worms

func  start_level():
	worms = 0
	game_running = true
	level_number += 1
	
	
func stop_level():
	game_running = false
	worms_collected += worms
	
