extends Node

var time_since_ad = 5*60*1000
var ad_frequenzy = 5*60*1000

onready var ad_mob: AdMob = get_tree().root.get_node_or_null("Admob")

func _ready():
	ad_mob.is_real = !OS.is_debug_build()
	prints("Running AdMob in:", ad_mob.is_real)
	
	ad_mob.rewarded_id = "ca-app-pub-3940256099942544/5224354917"
	ad_mob.interstitial_id = "ca-app-pub-3940256099942544/8691691433"
	ad_mob.load_interstitial()
	
	ad_mob.connect("interstitial_closed", self, "_on_interstitial_closed")

func _physics_process(delta):
	if get_tree().get_current_scene().get_name() == "Game":
		time_since_ad += delta

func show_ad(force: bool = false):
	if time_since_ad >= ad_frequenzy or force:
		ad_mob.show_interstitial()

func _on_interstitial_closed():
	ad_mob.load_interstitial()
	time_since_ad = 0
	
	
