#CalorieCalculator

There is only one function in this class, which helps calculate the calorie burned during exercise.

The unit of the function is:

* speed: km/hr
* weight: kg
* time: hr
* calorie burned : kcal 


Example of calling this function:

```swift
//.Bike is of enum Exercise
//speed's unit: km/hr
//timeSpent's unit: s
//weight unit: kg
//kCalBurned's unit: kcal
//kcalBurnedLabel is the UIkit to display
let calorieCalculator = CalorieCalculator()
let kCalBurned = calorieCalculator.kiloCalorieBurned(.Bike, speed: speed, weight: 70.0, time: spentTime/3600)
kcalBurnedLabel.text = String(format:"%.2f kcal",kCalBurned)
```