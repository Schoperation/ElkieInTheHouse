extends Node

"""
A speech tree. Each node can have 0-infinity branches (hopefully not too many).

The root node is the start of the conversation. It can be directly accessed at all times, as it can change from time to time.
"""

# Main speech tree
var speechTree

class Leaf:
	var id: String
	var choice: String
	var dialogue: String # Array
	var options = [] # Array
	
	var goesBack: bool
	var goesBackMsg: String
	
	var hasCondition: bool # Check a condition in order to show it
	var condition
	
	# Variables below this comment are set in-game
	var read: bool
	
	func _init(id, choice, dialogue, options, goesBack, goesBackMsg, hasCondition, condition):
		self.id = id
		self.choice = choice
		self.dialogue = dialogue
		self.options = options
		self.goesBack = goesBack
		self.goesBackMsg = goesBackMsg
		self.hasCondition = hasCondition
		self.condition = condition
		

# Actual tree class that stores leaves
class SpeechTree:
	var name: String
	var leaves = []
	
	var rootLeaf: Leaf
	var shownLeaf: Leaf
	
	func _init(name, leaves, rootLeaf):
		self.name = name
		self.leaves = leaves
		self.rootLeaf = rootLeaf
		
	func print():
		for leaf in leaves:
			print(leaf.dialogue)
			
	func getLeafFromId(id) -> Leaf:
		for leaf in leaves:
			if leaf.id == id:
				return leaf
		return null
	
# Called when the node enters the scene tree for the first time.
func _ready():
	speechTree = createSpeechTree("res://speech/sample.json")
	
func _process(delta):
	if Input.is_key_pressed(KEY_E):
		showDialogue(speechTree.rootLeaf)
	
func showDialogue(leaf):
	$Choices.hide()
	$Dialogue.show()
	speechTree.shownLeaf = leaf
	$Dialogue/Body.bbcode_text = leaf.dialogue
	
	# Delete buttons
	for child in $Choices/VBoxContainer.get_children():
		child.queue_free()
	
func showOptions(leaf):
	$Choices.show()
	$Dialogue.hide()
	
	# No options?
	if leaf.options.empty():
		closeDialogue()
	
	# Create buttons
	var choiceButton = load("res://speech/ChoiceButton.tscn")
	for op in leaf.options:
		var button = choiceButton.instance()
		button.leaf = speechTree.getLeafFromId(op)
		button.node = self
		button.get_node("Label").text = speechTree.getLeafFromId(op).choice
		$Choices/VBoxContainer.add_child(button)
		
func closeDialogue():
	$Dialogue.hide()
	
func openJSON(filePath) -> Dictionary:
	var file = File.new()
	file.open(filePath, file.READ)
	
	# Grab contents and put them in a dictionary
	var content = file.get_as_text()
	var dict = {}
	dict = parse_json(content)
	file.close()
	return dict
	
func createSpeechTree(filePath) -> SpeechTree:
	var dict = openJSON(filePath)
	
	var leaves = []
	# Read through dictionary and create leaves
	for n in range(dict.size()):
		# Grab options
		var options = []
		for op in dict[str(n)]["options"]:
			options.append(op)
		var leaf = Leaf.new(str(n), dict[str(n)]["choice"], dict[str(n)]["dialogue"], options, false, "k", false, "k")
		leaves.append(leaf)

	return SpeechTree.new("yes", leaves, leaves[0])

func _on_Next_pressed():
	# Show options
	showOptions(speechTree.shownLeaf)
