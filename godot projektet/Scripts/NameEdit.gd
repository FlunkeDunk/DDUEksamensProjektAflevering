extends LineEdit

var allowedCharacters = "[A-Za-z0-9]"

func _on_text_changed(new_text):
	var word = ''
	var regex = RegEx.new()
	regex.compile(allowedCharacters)
	for valid_character in regex.search_all(new_text):
		word += valid_character.get_string()
	if word == text:
		return
	clear()
	insert_text_at_caret(word)
	#self.set_text(word)
