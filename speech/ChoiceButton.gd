extends Button

var node
var leaf # leaf

func _on_ChoiceButton_pressed():
	node.speechTree.shownLeaf = leaf
	node.showDialogue(leaf)
