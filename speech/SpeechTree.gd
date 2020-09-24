extends Node

"""
A speech tree. Each node can have 0-infinity branches (hopefully not too many).

The root node is the start of the conversation. It can be directly accessed at all times, as it can change from time to time.
"""

class Leaf:
	var id: int
	var name: String
	var dialogue: String # Array
	var options: Leaf # Array
	
	var goesBack: bool
	var goesBackMsg: String
	
	var hasCondition: bool # Check a condition in order to show it
	var condition
	
	# Variables below this comment are set in-game
	var read: bool
	
	func _init(name, dialogue, options, goesBack, goesBackMsg, hasCondition, condition):
		self.name = name
		self.dialogue = dialogue
		self.options = options
		self.goesBack = goesBack
		self.goesBackMsg = goesBackMsg
		self.hasCondition = hasCondition
		self.condition = condition
		

# Actual tree class that stores leaves
class SpeechTree:
	var name: String
	var leaves: Leaf # Array
	
	var rootLeaf: Leaf
	
	func _init(name, leaves, rootLeaf):
		self.name = name
		self.leaves = leaves
		self.rootLeaf = rootLeaf
	
# Called when the node enters the scene tree for the first time.
func _ready():
	createSpeechTree("res://speech/sample.json")
	
func openJSON(filePath) -> Dictionary:
	var file = File.new()
	file.open(filePath, file.READ)
	
	# Grab contents and put them in a dictionary
	var content = file.get_as_text()
	var dict = {}
	dict = parse_json(content)
	file.close()
	return dict
	
func createSpeechTree(filePath):
	var dict = openJSON(filePath)
	#print(dict)
	
	print(dict[1]["choice"])
	
	
	
	

	
