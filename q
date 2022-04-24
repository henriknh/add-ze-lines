warning: LF will be replaced by CRLF in default_env.tres.
The file will have its original line endings in your working directory
warning: LF will be replaced by CRLF in scenes/game/ui/ui.gd.
The file will have its original line endings in your working directory
warning: LF will be replaced by CRLF in scenes/game/ui/ui.tscn.
The file will have its original line endings in your working directory
warning: LF will be replaced by CRLF in singletons/level.gd.
The file will have its original line endings in your working directory
warning: LF will be replaced by CRLF in singletons/storage.gd.
The file will have its original line endings in your working directory
[1mdiff --git a/scenes/game/ui/ui.gd b/scenes/game/ui/ui.gd[m
[1mindex 2648d5a..488ff49 100644[m
[1m--- a/scenes/game/ui/ui.gd[m
[1m+++ b/scenes/game/ui/ui.gd[m
[36m@@ -25,6 +25,7 @@[m [mfunc _ready():[m
 	_on_theme_changed()[m
 	[m
 	Level.connect("level_changed", self, "on_level_changed")[m
[32m+[m	[32mStorage.connect("storage_changed", self, "on_level_changed")[m
 	on_level_changed()[m
 	[m
 	[m
[36m@@ -59,14 +60,13 @@[m [mfunc on_level_changed():[m
 	$OnLevelComplete/MarginContainer/CenterContainer/VBoxContainer/NextLevel.visible = next_chapter or next_level[m
 	$OnLevelComplete/MarginContainer/CenterContainer/VBoxContainer/NextLevel.text = tr("NEXT_CHAPTER") if next_chapter else tr("NEXT_LEVEL")[m
 	$OnLevelComplete/MarginContainer/CenterContainer/VBoxContainer/NoMoreLevels.visible = not next_chapter and not next_level[m
[32m+[m
 	var level_data = Data.data[Level.chapter].levels[Level.level][m
 	var level_completed = Storage.get_level_completed(level_data.id)[m
 	var level_skipped = Storage.get_level_skipped(level_data.id)[m
[31m-	$TopRight/MarginContainer/HBoxContainer/Skip.visible = not level_completed or level_skipped[m
[31m-	if level_skipped:[m
[31m-		$TopRight/MarginContainer/HBoxContainer/Skip.disabled = true[m
[31m-		$TopRight/MarginContainer/HBoxContainer/Skip.self_modulate.a = 0.38[m
[31m-	[m
[32m+[m	[32mvar skip_disabled = level_completed or level_skipped[m
[32m+[m	[32m$TopRight/MarginContainer/HBoxContainer/Skip.disabled = skip_disabled[m
[32m+[m	[32m$TopRight/MarginContainer/HBoxContainer/Skip.self_modulate.a = 0.38 if skip_disabled else 1[m
 [m
 func _physics_process(delta):[m
 	_show_hide_ui()[m
[36m@@ -77,7 +77,10 @@[m [mfunc _show_hide_ui():[m
 		if line.points.size() >= 2:[m
 			line_has_two_points = true[m
 			break[m
[31m-	$TopRight/MarginContainer/HBoxContainer/Restart.visible = Level.level_ready and line_has_two_points[m
[32m+[m[41m	[m
[32m+[m	[32mvar restart_disabled = not line_has_two_points[m
[32m+[m	[32m$TopRight/MarginContainer/HBoxContainer/Restart.disabled = restart_disabled[m
[32m+[m	[32m$TopRight/MarginContainer/HBoxContainer/Restart.self_modulate.a = 0.38 if restart_disabled else 1[m
 	[m
 	if Storage.get_editor():[m
 		$UIEditor.visible = true[m
[1mdiff --git a/singletons/level.gd b/singletons/level.gd[m
[1mindex 5d80304..24c152a 100644[m
[1m--- a/singletons/level.gd[m
[1m+++ b/singletons/level.gd[m
[36m@@ -85,10 +85,13 @@[m [mfunc update():[m
 	[m
 	level_complete = check_for_level_completed()[m
 	if level_complete:[m
[31m-		var already_completed = Storage.get_level_completed(Level.level_data.id)[m
[31m-		if not already_completed:[m
[32m+[m		[32mif Storage.get_level_skipped(Level.level_data.id):[m
[32m+[m			[32mStorage.set_level_not_skipped(Level.level_data.id)[m
[32m+[m[41m		[m
[32m+[m		[32mif not Storage.get_level_completed(Level.level_data.id):[m
 			Storage.set_level_complete(Level.level_data.id)[m
 			Storage.set_gems(Storage.get_gems() + 10)[m
[32m+[m[41m		[m
 [m
 func check_for_level_completed() -> bool:[m
 	var to_satisfy = 0[m
[1mdiff --git a/singletons/storage.gd b/singletons/storage.gd[m
[1mindex 15840f1..d97c3ec 100644[m
[1m--- a/singletons/storage.gd[m
[1m+++ b/singletons/storage.gd[m
[36m@@ -101,6 +101,11 @@[m [mfunc set_level_skipped(level_id: int):[m
 	if not level_id in skipped_levels:[m
 		skipped_levels.append(level_id)[m
 	_set_config_value("level", "skipped", skipped_levels)[m
[32m+[m[41m	[m
[32m+[m[32mfunc set_level_not_skipped(level_id: int):[m
[32m+[m	[32mvar skipped_levels = _get_config_value("level", "skipped", [])[m
[32m+[m	[32mskipped_levels.erase(level_id)[m
[32m+[m	[32m_set_config_value("level", "skipped", skipped_levels)[m
 [m
 func get_level_skipped(level_id: int) -> bool:[m
 	var skipped_levels = _get_config_value("level", "skipped", [])[m
