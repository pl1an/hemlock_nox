extends Control
class_name UpgradeManager


@export var rarity_prob:Array[float] = [55, 85, 95, 100]

@export var rarity_color_array:Array[Color]
var rarity_order = ["Common", "Rare", "Epic", "Legendary"]

@export var level_up:LevelUpManager


var possible_choices
# values used in upgrades (list of ["name", "description", common, rare, epic, legendary, potions_necessary])
# min rarity occurs when there are values after index 2 equal to zero
@export var UPGRADE_VALUES = [
	["Poisonous", "Gas poisons deal X more damage over time
	\nMore damage to them, more damage to you.", 10, 20, 40, 80, 1],
	["Poison stays", "Gas poisons last X more seconds after leaving it's area of effect.\n
	The longer something remains hidden within the body, the deadlier it is.", 1, 2, 3, 5, 1],
	["Poison, do not vanish", "Gas poison zones last X more seconds.\n
	Staying longer in this world means more potential to harm, both you and your enemies.", 3, 4, 6, 8, 1],
	["Keep your body vulnerable", "Gas zones created by gas poisons are X times biger.\n
	Vulnerability does not always leads to bad things. Although this time it probably will.", 1.1, 1.2, 1.3, 1.5, 1],
	
	["Thou shalt feel the cold", "Slowness poisons may appear in the world.\n
	Showing the cold to them means you might feel the cold yourself.", 1, 1, 1, 1, -1],
	["Freezing", "Slowness poisons remove more X of affected target speed
	\nThe slower they are, the slower you will be.", 0.5, 0.75, 1.2, 3, 0],
	["Cold remains", "Slowness poisons last X more seconds after leaving it's area of effect.\n
	Cold takes root even in the bones.", 1, 2, 3, 5, 0],
	["Cold, do not leave", "Slowness poison zones last X more seconds.\n
	Cold never goes away. It only hides.", 3, 4, 6, 8, 0],
	["Keep your heart cold", "Slowness zones created by slowness poisons are X times biger.\n
	Cold is as much a physical sensation as it is a feeling.", 1.1, 1.2, 1.3, 1.5, 0],
	
	["Thou shalt feel the flame", "Burning poisons may appear in the world.\n
	Showing the flame to them means you might feel the flame yourself.", 0, 1, 1, 1, -2],
	["Flaming", "Burning poisons deal X more damage over time
	\nThe more they burn, the more you will.", 20, 30, 40, 60, 2],
	["Flames linger", "Burning poisons last X more seconds after leaving it's area of effect.\n
	The stronger they are, the longer they will burn.", 1, 2, 4, 5, 2],
	["Flames, do not go out", "Burning poison zones last X more seconds.\n
	As long as there is fuel, there will be fire.", 3, 4, 6, 8, 2],
	["Keep your skin warm", "Burning zones created by burning poisons are X times biger.\n
	The bigger the fire, the stronger the heat.", 1.1, 1.2, 1.3, 1.5, 2],
	
	["Thou shalt feel the fear", "Fear poisons may appear in the world.\n
	Showing the fear to them means you might feel the fear yourself.", 0, 0, 1, 1, -3],
	["Frightening", "Fear poisons make enemies run away X times faster.\n
	The more you scare them, the more you will be scared of yourself.", 0.2, 0.3, 0.5, 0.8, 3],
	["Fear lasts", "Fear poisons last X more seconds after leaving it´s area of effect.\n
	Fear and trauma linger around more then one might exepect.", 1, 2, 3, 5, 3],
	["Fear, do not weaken", "Fear poison zones last X more seconds.\n
	As long as one is awake, there might be fear.", 3, 4, 6, 8, 3],
	["Keep your eyes open", "Fear zones created by fear poisons are X times biger.\n
	Awareness might make one see things that shouldn't be seen.", 1.1, 1.2, 1.3, 1.5, 3],
	
	["Thou shalt feel life", "Health poisons may appear in the world.\n
	Making yourself aware of life also means attracting the attention of your enemies to it.", 0, 0, 1, 1, -4],
	["Healing", "Health poisons heal X more.\n
	Life is also a poison, to some. Not to you, though. Neither to your enemies.", 50, 100, 150, 300, 4],
	["Keep your heart beating", "Heal zones created by health poisons are X times biger.\n
	Bigger also means easier to acces. To both you, and your enemies.", 1.1, 1.2, 1.3, 1.5, 4],
	
	["Thou shalt feel the growth", "Regeneration poisons may appear in the world.\n
	Making yourself able to grow means that your enemies might be able to.", 0, 0, 1, 1, -5],
	["Growing", "Regeneration poisons regenerate X more health per second.\n
	The hope to keep living is the biggest poison.", 20, 30, 50, 100, 5],
	["Growth remains", "Regeneration poisons last X more seconds after leaving it´s area of effect.\n
	Growing always leaves a mark. In a way, or in another.", 1, 2, 3, 5, 5],
	["Growth, do not stop", "Regeneration poison zones last X more seconds.\n
	As long as one oportunity presents it self, growth is always possible.", 3, 4, 6, 8, 5],
	["Keep your body strong", "Regeneration zones created by regeneration poisons are X times biger.\n
	With strenght, comes growth. With growth, comes strenght.", 1.1, 1.2, 1.3, 1.5, 5],
	
	["Thou shalt feel the weakness", "Weakness poisons may appear in the world.\n
	Weakening them might also mean weakening your self.", 0, 1, 1, 1, -6],
	["Weakening", "Weakness poisons make enemies deal X less damage.\n
	The weaker they are, the weaker you will become.", 20, 30, 40, 60, 6],
	["Weakness never leaves", "Weakness poisons last X more seconds after leaving it´s area of effect.\n
	Weakness never disappears. It just remains hidden within one.", 1, 2, 3, 5, 6],
	["Weakness, do not leave", "Weakness poison zones last X more seconds.\n
	As long as there is strenght, there will be weakness.", 3, 4, 6, 8, 6],
	["Keep your body frail", "Weakness zones created by weakness poisons are X times biger.\n
	Keep their body frail as well. A small price to pay.", 1.1, 1.2, 1.3, 1.5, 6],
	
	["Thou shalt feel the fracture", "Fracture poisons may appear in the world.\n
	Felling the fracture means they can also do it.", 0, 0, 1, 1, -7],
	["Fracturing", "Fracture poisons make enemies suffer X percent more damage form their speed.\n
	The faster they are, the more they will suffer.", 0.5, 0.8, 1, 2, 7],
	["Scars remain", "Fracture poisons last X more seconds after leaving it´s area of effect.\n
	Broken bones always leave scars. Either in one's body, or in one's mind.", 1, 2, 3, 5, 7],
	["Wounds, do not heal", "Fracture poison zones last X more seconds.\n
	As long as something exists, it can be broken.", 3, 4, 6, 8, 7],
	["Keep your bones weakened", "Fracture zones created by fracture poisons are X times biger.\n
	Keep their bones weakened as well. A small price to pay.", 1.1, 1.2, 1.3, 1.5, 7],
	
	["Thou shalt feel death", "Decay poisons may appear in the world.\n
	Death spreads.", 0, 0, 0, 1, -8],
	["Decaying", "Decay poisons make enemies suffer X more damage per second.\n
	Dying is the ultimate end. Thus, dying is also the ultimate poison.", 10, 20, 30, 50, 8],
	["Death is forever", "Decay poisons last X more seconds after leaving it´s area of effect.\n
	There is no escape.", 1, 2, 3, 5, 8],
	["Death, begin", "Decay poison zones last X more seconds.\n
	As long as there is life, there will also be death.", 3, 4, 6, 8, 8],
	["Keep yourself mortal", "Decay zones created by decay poisons are X times biger.\n
	The closer one is to a god, the more they will be remembered that they are mortal, still.", 1.1, 1.2, 1.3, 1.5, 8],
]


# upgrade functions
var upgrades = [
	func poisonous(rarity:int):
		level_up.player.EFFECTS_POTENCY["poison"][0] += UPGRADE_VALUES[0][rarity+2]
		,
	func poison_stays(rarity:int):
		level_up.player.EFFECTS_POTENCY["poison"][1] += UPGRADE_VALUES[1][rarity+2]
		,
	func poison_do_not_decay(rarity:int):
		level_up.player.EFFECTS_POTENCY["poison"][2] += UPGRADE_VALUES[2][rarity+2]
		,
	func keep_your_body_vulnerable(rarity:int):
		level_up.player.EFFECTS_POTENCY["poison"][3] = UPGRADE_VALUES[3][rarity+2]*level_up.player.EFFECTS_POTENCY["poison"][3]
		,
	
	func thou_shalt_feel_the_cold(rarity:int):
		level_up.player.UNLOCKEDPOISONS.append(0)
		level_up.player.UNLOCKEDPOISONS = level_up.player.UNLOCKEDPOISONS.filter(func(element): return element!=-1)
		,
	func freezing(rarity:int):
		level_up.player.EFFECTS_POTENCY["slow"][0] += UPGRADE_VALUES[5][rarity+2]
		,
	func cold_remains(rarity:int):
		level_up.player.EFFECTS_POTENCY["slow"][1] += UPGRADE_VALUES[6][rarity+2]
		,
	func cold_do_not_leave(rarity:int):
		level_up.player.EFFECTS_POTENCY["slow"][2] += UPGRADE_VALUES[7][rarity+2]
		,
	func keep_your_heart_cold(rarity:int):
		level_up.player.EFFECTS_POTENCY["slow"][3] = UPGRADE_VALUES[8][rarity+2]*level_up.player.EFFECTS_POTENCY["slow"][3]
		,
	
	func thou_shalt_feel_the_flame(rarity: int):
		level_up.player.UNLOCKEDPOISONS.append(2)
		level_up.player.UNLOCKEDPOISONS = level_up.player.UNLOCKEDPOISONS.filter(func(element): return element!=-2)
		,
	func flaming(rarity:int):
		level_up.player.EFFECTS_POTENCY["burn"][0] += UPGRADE_VALUES[10][rarity+2]
		,
	func flames_linger(rarity:int):
		level_up.player.EFFECTS_POTENCY["burn"][1] += UPGRADE_VALUES[11][rarity+2]
		,
	func flames_do_not_go_out(rarity:int):
		level_up.player.EFFECTS_POTENCY["burn"][2] += UPGRADE_VALUES[12][rarity+2]
		,
	func keep_your_skin_warm(rarity:int):
		level_up.player.EFFECTS_POTENCY["burn"][3] = UPGRADE_VALUES[13][rarity+2]*level_up.player.EFFECTS_POTENCY["burn"][3]
		,

	func thou_shalt_feel_the_fear(rarity: int):
		level_up.player.UNLOCKEDPOISONS.append(3)
		level_up.player.UNLOCKEDPOISONS = level_up.player.UNLOCKEDPOISONS.filter(func(element): return element!=-3)
		,
	func frightening(rarity:int):
		level_up.player.EFFECTS_POTENCY["confusion"][0] += UPGRADE_VALUES[15][rarity+2]
		,
	func fear_lasts(rarity:int):
		level_up.player.EFFECTS_POTENCY["confusion"][1] += UPGRADE_VALUES[16][rarity+2]
		,
	func fear_do_not_weaken(rarity:int):
		level_up.player.EFFECTS_POTENCY["confusion"][2] += UPGRADE_VALUES[17][rarity+2]
		,
	func keep_your_eyes_open(rarity:int):
		level_up.player.EFFECTS_POTENCY["confusion"][3] = UPGRADE_VALUES[18][rarity+2]*level_up.player.EFFECTS_POTENCY["confusion"][3]
		,

	func thou_shalt_feel_the_life(rarity: int):
		level_up.player.UNLOCKEDPOISONS.append(4)
		level_up.player.UNLOCKEDPOISONS = level_up.player.UNLOCKEDPOISONS.filter(func(element): return element!=-4)
		,
	func healing(rarity:int):
		level_up.player.EFFECTS_POTENCY["heal"][0] += UPGRADE_VALUES[20][rarity+2]
		,
	func keep_your_heart_beating(rarity:int):
		level_up.player.EFFECTS_POTENCY["heal"][3] = UPGRADE_VALUES[21][rarity+2]*level_up.player.EFFECTS_POTENCY["heal"][3]
		,

	func thou_shalt_grow(rarity: int):
		level_up.player.UNLOCKEDPOISONS.append(5)
		level_up.player.UNLOCKEDPOISONS = level_up.player.UNLOCKEDPOISONS.filter(func(element): return element!=-5)
		,
	func growing(rarity:int):
		level_up.player.EFFECTS_POTENCY["regeneration"][0] += UPGRADE_VALUES[23][rarity+2]
		,
	func growth_remains(rarity:int):
		level_up.player.EFFECTS_POTENCY["regeneration"][1] += UPGRADE_VALUES[24][rarity+2]
		,
	func growth_do_not_stop(rarity:int):
		level_up.player.EFFECTS_POTENCY["regeneration"][2] += UPGRADE_VALUES[25][rarity+2]
		,
	func keep_your_body_strong(rarity:int):
		level_up.player.EFFECTS_POTENCY["regeneration"][3] = UPGRADE_VALUES[26][rarity+2]*level_up.player.EFFECTS_POTENCY["regeneration"][3]
		,

	func thou_shalt_feel_the_weakness(rarity: int):
		level_up.player.UNLOCKEDPOISONS.append(6)
		level_up.player.UNLOCKEDPOISONS = level_up.player.UNLOCKEDPOISONS.filter(func(element): return element!=-6)
		,
	func weakening(rarity:int):
		level_up.player.EFFECTS_POTENCY["weak"][0] += UPGRADE_VALUES[28][rarity+2]
		,
	func weakness_remains(rarity:int):
		level_up.player.EFFECTS_POTENCY["weak"][1] += UPGRADE_VALUES[29][rarity+2]
		,
	func weakeness_do_not_go_away(rarity:int):
		level_up.player.EFFECTS_POTENCY["weak"][2] += UPGRADE_VALUES[30][rarity+2]
		,
	func keep_your_body_weak(rarity:int):
		level_up.player.EFFECTS_POTENCY["weak"][3] = UPGRADE_VALUES[31][rarity+2]*level_up.player.EFFECTS_POTENCY["weak"][3]
		,

	func thou_shalt_feel_the_fracture(rarity: int):
		level_up.player.UNLOCKEDPOISONS.append(7)
		level_up.player.UNLOCKEDPOISONS = level_up.player.UNLOCKEDPOISONS.filter(func(element): return element!=-7)
		,
	func fracturing(rarity:int):
		level_up.player.EFFECTS_POTENCY["cripple"][0] += UPGRADE_VALUES[33][rarity+2]
		,
	func scars_remain(rarity:int):
		level_up.player.EFFECTS_POTENCY["cripple"][1] += UPGRADE_VALUES[34][rarity+2]
		,
	func wounds_do_not_heal(rarity:int):
		level_up.player.EFFECTS_POTENCY["cripple"][2] += UPGRADE_VALUES[35][rarity+2]
		,
	func keep_your_bones_weak(rarity:int):
		level_up.player.EFFECTS_POTENCY["cripple"][3] = UPGRADE_VALUES[36][rarity+2]*level_up.player.EFFECTS_POTENCY["cripple"][3]
		,

	func thou_shalt_feel_death(rarity: int):
		level_up.player.UNLOCKEDPOISONS.append(8)
		level_up.player.UNLOCKEDPOISONS = level_up.player.UNLOCKEDPOISONS.filter(func(element): return element!=-8)
		,
	func decaying(rarity:int):
		level_up.player.EFFECTS_POTENCY["decay"][0] += UPGRADE_VALUES[38][rarity+2]
		,
	func death_begin(rarity:int):
		level_up.player.EFFECTS_POTENCY["decay"][1] += UPGRADE_VALUES[39][rarity+2]
		,
	func death_begin(rarity:int):
		level_up.player.EFFECTS_POTENCY["decay"][2] += UPGRADE_VALUES[40][rarity+2]
		,
	func keep_yoruself_mortal(rarity:int):
		level_up.player.EFFECTS_POTENCY["decay"][3] = UPGRADE_VALUES[41][rarity+2]*level_up.player.EFFECTS_POTENCY["decay"][3]
		,
]


func filter(has_to_have):
	var result_choices := []
	var result_functions := []
	for i in range(UPGRADE_VALUES.size()):
		for ii in has_to_have:
			if(UPGRADE_VALUES[i][6]==ii):
				result_choices.append(UPGRADE_VALUES[i])
				result_functions.append(upgrades[i])
	return [result_choices, result_functions]
func filter_by_rarity(target_array, min_rarity):
	var result = []
	for i in range(target_array[0].size()):
		if target_array[0][i][min_rarity+2]!=0:
			result.append(i)
	return result
# returns 3 randomly choosen upgrades ([[upgrade_index, rarity], ...]
func choose_upgrades():
	var result = []
	possible_choices = filter(level_up.player.UNLOCKEDPOISONS)
	for i in range(0, 3):
		var rarity_choice = randf()*100
		if(rarity_choice<rarity_prob[0]): result.append([0])
		elif(rarity_choice<rarity_prob[1]): result.append([1])
		elif(rarity_choice<rarity_prob[2]): result.append([2])
		elif(rarity_choice<rarity_prob[3]): result.append([3])
	for i in range(0, 3):
		var filtered_by_rarity_array = filter_by_rarity(possible_choices, result[i][0])
		result[i].insert(0, filtered_by_rarity_array[randi()%filtered_by_rarity_array.size()])
	return result
