extends Label

# Your dialogue lines
var dialogue_lines = [
	
	"TRANSMISSION FROM GILLY GOOSE: \n DOGS! I flew through an Armada to deliver dogs... Wow... I thought this was a megabomb or something to help the humans",
	"TRANSMISSION FROM LAYLA: \n It will help the humans! Dogs are their best friends, they are better with dogs. Plus we dont want to give those idiots anything valuable. WE HAD to get rid of the dogs anyway.",
	"TRANSMISSION FROM GILLY GOOSE: \n My ship will smell for months.",
	"TRANSMISSION FROM LAYLA: \n The humans will remember far after the smell fades... also I've already approved a new ship. We're going to have to send that one into the sun after you dock.",
	"TRANSMISSION FROM GILLY GOOSE: \n ......ok. Well while you find me a new ship I think I have some nap time in my future",
		"TRANSMISSION FROM LAYLA: \n Not so fast! We have another ship fueled up and ready for delivery. The cows in the pegasus galaxy have requsted our aid. They are paying us a lot of milk so were going to do this one right",
		"TRANSMISSION FROM GILLY GOOSE: \n ......oh... Ok... sure",
	"That's it! Thanks for playing, relaunch to play again"
]

var audioFiles = ["res://catdialog2/goose1.wav","res://catdialog2/layla1.wav","res://catdialog2/goose2.wav","res://catdialog2/layla2.wav","res://catdialog2/goose3.wav","res://catdialog2/laylaFinal.wav","res://catdialog2/goosefinal.wav"]

var current_line = 0

# Cache reference to the timer


func _ready():
	text = dialogue_lines[current_line]
	if current_line < len(audioFiles):
		$"../sounds".stream =load(audioFiles[current_line])
		$"../sounds".play()
	# Set the first dialogue line
	text = dialogue_lines[current_line]
	# Start the timer


func _on_DialogueTimer_timeout():
	current_line += 1

	# Check if there are more dialogue lines
	if current_line < len(dialogue_lines):
		text = dialogue_lines[current_line]
		if current_line < len(audioFiles):
			$"../sounds".stream =load(audioFiles[current_line])
			$"../sounds".play()
	else:
		# End of dialogue, hide the label or do any other desired action
		hide()


func _on_timer_timeout():
	_on_DialogueTimer_timeout()
	pass # Replace with function body.
