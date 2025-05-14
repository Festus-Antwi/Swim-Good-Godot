extends Node

var game_running: bool = false
var worms: int = 0
var worms_collected:int = 0
var game_over:bool = false
var level_number:int = 1
var leveled_up = false


func add_worm():
	worms += 1
	worms_collected += 1
	print("worms collected: ", worms)
	if worms == 30:
		level_up()

func level_up():
	worms = 0
	level_number += 1
	leveled_up = true
