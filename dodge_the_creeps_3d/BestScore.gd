extends RichTextLabel

var best_score_array = []

func _ready():
	load_scores()
	initscore()

func _on_final_score(score_number):
	best_score_array.append(score_number)
	save_scores()
	initscore()

func initscore():
	sort_scores_descending()
	text = "Meilleurs scores : \n\n"
	for i in range(5):
		if i < best_score_array.size():
			text += str(i + 1) + " • " + str(best_score_array[i]) + " Point\n"

func save_scores():
	var file = File.new()
	file.open("user://scores.save", File.WRITE)
	for score in best_score_array:
		file.store_line(str(score))
	file.close()

func load_scores():
	var file = File.new()
	if file.file_exists("user://scores.save"):
		file.open("user://scores.save", File.READ)
		best_score_array.clear()
		while not file.eof_reached():
			var line = file.get_line()
			best_score_array.append(int(line))
		file.close()
		best_score_array.sort()
		
func sort_scores_descending():
	best_score_array.sort_custom(self, "_compare_scores")

func _compare_scores(a, b):
	return int(b - a)
