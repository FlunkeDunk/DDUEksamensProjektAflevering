extends UpgradeButton

var superScaling: bool = false
var hyperScaling: bool = false
var superScalingAmount: float = 2
var hyperScalingAmount: float = 10
var superScalingStart: int = 100
var hyperScalingStart: int = 500


func whenBought() -> void:
	generatorMenu.generatorsBought = bought
	generatorMenu.emit_signal("generatorBought")
	if bought >= superScalingStart && !superScaling:
		superScaling = true
		priceScaling = superScalingAmount
	elif bought >= hyperScalingStart && !hyperScaling:
		hyperScaling = true
		priceScaling = hyperScalingAmount


func updateText() -> void:
	scaling = snapped(pow(generatorMenu.generatorBoost, bought), 0.1)
	#description = "Powercore: +" + Globals.convertNum(snapped(pow(generatorMenu.generatorBoost, bought), 0.1)) + " energy per second"
	super.updateText()

func calculate10Price() -> float:
	if (bought + 10) < superScalingStart:
		return super.calculate10Price()
	var calculatedPrice: float = 0
	for i in 10:
		if bought+i<=superScalingStart:
			calculatedPrice += price*pow(priceScaling, i)
		elif bought+i<=hyperScalingStart:
			calculatedPrice += price*pow(superScalingAmount, i)
		else:
			calculatedPrice += price*pow(hyperScalingAmount, i)
	return calculatedPrice

func calculateBuyMaxPrice() -> float:
	var calculatedPrice: float = price
	var priceOfNext: float = price*priceScaling
	var iteration: int = 0
	while calculatedPrice+priceOfNext < generatorMenu.energy:
		iteration += 1
		calculatedPrice += priceOfNext
		if bought+iteration<=superScalingStart:
			priceOfNext *= priceScaling
		elif bought+iteration<=hyperScalingStart:
			priceOfNext *= superScalingAmount
		else:
			priceOfNext *= hyperScalingAmount
	return(calculatedPrice)
