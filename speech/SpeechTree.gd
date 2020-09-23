extends Node

"""
A speech tree. Each node can have 0-infinity branches (hopefully not too many).

The root node is the start of the conversation. It can be directly accessed at all times, as it can change from time to time.
"""

class Leaf:
	var name: String
	var dialogue: String # Array
	var options: Leaf # Array
	
	var goesBack: bool
	var goesBackMsg: String
	
	func _init(name, dialogue, options, goesBack, goesBackMsg):
		self.name = name
		self.dialogue = dialogue
		self.options = options
		self.goesBack = goesBack
		self.goesBackMsg = goesBackMsg
	
# Called when the node enters the scene tree for the first time.
func _ready():
	var array = [0, 1, 2]
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
