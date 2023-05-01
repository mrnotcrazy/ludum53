extends Label

# Your dialogue lines
var dialogue_lines = [
	"TRANSMISSION FROM LAYLA: GOOSE I NEED YOU TO MAKE A DELIVERY FOR ME. THE HUMANS ARE UNDER SIEGE AND THEY NEED OUR HELP",
	"TRANSMISSION FROM GILLY GOOSE: \n Didn't we dump those losers after they stopped feeding us fish? also why the cap locks?",
	"TRANSMISSION FROM LAYLA: \n Sorry, I had my tail on the shift key. Look Goose Humans and Cats have had a long relationship. Thousands of years of fish are worth something.",
	"TRANSMISSION FROM GILLY GOOSE: \n ok then call in the Armada and let me get back to my nap.",
	"TRANSMISSION FROM LAYLA: \n High command has something better in store, we have a package. You just need to get it to the surface and then the humans can take it from there.",
	"TRANSMISSION FROM GILLY GOOSE: \n fine... but I expect a long nap after this",
	"Go ahead and press skip"
]

var audioFiles = ["res://layla1.wav","res://goose1.wav","res://layla2.wav","res://goose2.wav","res://laylafinal.wav","res://goosefinal.wav"]

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
