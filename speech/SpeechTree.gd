extends Node

"""
A speech tree. Each node can have 0-infinity branches (hopefully not too many).

The root node is the start of the conversation. It can be directly accessed at all times, as it can change from time to time.
"""

# Attach json file here
export var speechJson = " "

# Main speech tree
var speechTree
var showtest = false

class Leaf:
	var id: String
	var choice: String
	var dialogue: String # Array
	var options = [] # Array
	
	var hasCondition: bool # Check a condition in order to show it
	var condition
	
	var hasTrigger: bool # Does clicking on this trigger a function?
	var trigger
	
	# Variables below this comment are set in-game
	var read: bool
	
	func _init(id, choice, dialogue, options, hasCondition, condition, hasTrigger, trigger):
		self.id = id
		self.choice = choice
		self.dialogue = dialogue
		self.options = options
		self.hasCondition = hasCondition
		self.condition = condition
		self.hasTrigger = hasTrigger
		self.trigger = trigger
		

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
	speechTree = createSpeechTree("res://speech/sample.json") # "res://speech/sample.json"
	pass
	
func _process(delta):
	if Input.is_key_pressed(KEY_E):
		showDialogue(speechTree.rootLeaf)
	
func showDialogue(leaf):
	$Choices.hide()
	$Dialogue.show()
	speechTree.shownLeaf = leaf
	$Dialogue/Body.bbcode_text = leaf.dialogue
	
	# Trigger a function, if applicable
	if leaf.hasTrigger:
		pass
	
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
		# Check condition
		if speechTree.getLeafFromId(op).hasCondition:
			var expr = str2var(speechTree.getLeafFromId(op).condition)
			print(expr)
			var thisistrue = (expr == true)
			print(thisistrue)
			if expr:
				var button = choiceButton.instance()
				button.leaf = speechTree.getLeafFromId(op)
				button.node = self
				button.get_node("Label").text = speechTree.getLeafFromId(op).choice
				$Choices/VBoxContainer.add_child(button)
			else:
				pass
					
			"""
			var expr = Expression.new()
			
			var error = expr.parse(speechTree.getLeafFromId(op).condition, [])
			if error != OK:
				print(\"Error evaluating the condition for \" + str(speechTree.getLeafFromId(op)) + \"  \" + expr.get_error_text())
			else:
				var result = expr.execute([], null, true)
				print(expr.parse(speechTree.getLeafFromId(op).condition, []))
				print(result)
				if not expr.has_execute_failed() and result:
					var button = choiceButton.instance()
					button.leaf = speechTree.getLeafFromId(op)
					button.node = self
					button.get_node(\"Label\").text = speechTree.getLeafFromId(op).choice
					$Choices/VBoxContainer.add_child(button)
				else:
					pass
			"""
		else:
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
		var leaf
		# Grab options
		var options = []
		for op in dict[str(n)]["options"]:
			options.append(op)
			
		# Find optional vars (conditions, function triggers, etc)
		if dict[str(n)].has("condition"):
			if dict[str(n)].has("trigger"):
				leaf = Leaf.new(str(n), dict[str(n)]["choice"], dict[str(n)]["dialogue"], options, true, dict[str(n)]["condition"], true, dict[str(n)]["trigger"])
			else:
				leaf = Leaf.new(str(n), dict[str(n)]["choice"], dict[str(n)]["dialogue"], options, true, dict[str(n)]["condition"], false, "k")
		elif dict[str(n)].has("trigger"):
			leaf = Leaf.new(str(n), dict[str(n)]["choice"], dict[str(n)]["dialogue"], options, false, "k", true, dict[str(n)]["trigger"])
		else:
			leaf = Leaf.new(str(n), dict[str(n)]["choice"], dict[str(n)]["dialogue"], options, false, "k", false, "k")
			
		leaves.append(leaf)
		
	return SpeechTree.new("yes", leaves, leaves[0])

func _on_Next_pressed():
	# Show options
	showOptions(speechTree.shownLeaf)
	
func bigFunnyHaHa():
	print("Hello nerd")
