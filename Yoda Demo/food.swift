import UIKit

class Food {
    var name:String = "name-not-assigned"
    var description:String = "desc-not-assigned"
    var id:Int = -1
    var thumbnail:UIImage = UIImage()
    var calories:Int = -1
    
    var glucoseProfile:NSMutableArray = [0,1,2,3,4,5,4,3,2,1,0]
    var cho:Int = -1
    var protein:Int = -1
    var fat:Int = -1
    
    
    init(name:String, id:Int, thumbnail:UIImage, calories:Int, glucoseProfile:NSMutableArray) {
        self.name = name
        self.id = id
        self.thumbnail = thumbnail
        self.calories = calories
        self.glucoseProfile = glucoseProfile
    }
    init(name:String, description:String, id:Int, thumbnail:String, glucoseProfile:NSMutableArray) {
        self.name = name
        self.description = description
        self.id = id
        self.thumbnail = UIImage(named: thumbnail)!
        self.glucoseProfile = glucoseProfile
    }
    init() {
        
    }
}

let cereal:Food = Food(name: "Cereal", id: 0, thumbnail: UIImage(named: "cereal.jpg")!, calories: 1000, glucoseProfile: [0,1,2])
let pizza:Food = Food(name: "Pizza", id: 1, thumbnail: UIImage(named: "pizza.jpg")!, calories: 1000, glucoseProfile: [2,1,0])
let pasta:Food = Food(name: "Pasta", id: 2, thumbnail: UIImage(named: "pasta.jpg")!, calories: 1000, glucoseProfile: [])
let sandwich:Food = Food(name: "Sandwich", id: 3, thumbnail: UIImage(named: "sandwich.jpg")!, calories: 1000, glucoseProfile: [])
let mashedPotato:Food = Food(name: "Mashed Potato", id: 4, thumbnail: UIImage(named: "mashed-potato.jpg")!, calories: 1000, glucoseProfile: [])
let bigMac:Food = Food(name: "Big Mac", id: 5, thumbnail: UIImage(named: "big-mac.jpg")!, calories: 1000, glucoseProfile: [])
let fries:Food = Food(name: "Fries", id: 6, thumbnail: UIImage(named: "fries.jpg")!, calories: 1000, glucoseProfile: [])
let salad:Food = Food(name: "Salad", id: 7, thumbnail: UIImage(named: "salad.jpg")!, calories: 1000, glucoseProfile: [])
let friedChicken:Food = Food(name: "Fried Chicken", id: 8, thumbnail: UIImage(named: "fried-chicken.jpg")!, calories: 1000, glucoseProfile: [])
let iceCream:Food = Food(name: "Ice Cream", id: 9, thumbnail: UIImage(named: "ice-cream.jpg")!, calories: 1000, glucoseProfile: [])

//let foodLibrary = [
//    cereal,
//    pizza,
//    pasta,
//    sandwich,
//    mashedPotato,
//    bigMac,
//    fries,
//    salad,
//    friedChicken,
//    iceCream
//]

let bacon_and_eggs = Food(
    name: "Bacon & Eggs",
    description: "Scrambled eggs, Canadian bacon and gelatin (Jell-O)",
    id: 1,
    thumbnail: "bacon-and-eggs.jpg",
    glucoseProfile:[
        0,8,6,5,4,3,2,1.5,1,0.8,0.5,0.4,0.3,0.4,0.3,0.2,0.1,0
    ]
)

let cheese_sandwich = Food(
    name: "Cheese Sandiwch",
    description: "White bread, low-fat cheese, sucrose, oil, butter",
    id: 2,
    thumbnail: "cheese-sandwich.jpg",
    glucoseProfile: [
        0,3.5,6,7,6.5,6,5,4,3,2,1.5,1,0.5
    ]
)

let full_breakfast = Food(
    name: "Full Breakfast", 
    description: "Fat milk, white rice, low-fat cheese, fructose, pear, bran-cookies, oil", 
    id: 3, 
    thumbnail: "cereal.jpg", 
    glucoseProfile: []
)

let pasta_low = Food(
    name: "Pasta", 
    description: "Pasta, Oil (Low Fat)", 
    id: 4, 
    thumbnail: "pasta.jpg", 
    glucoseProfile: []
)

let pasta_medium = Food(
    name: "Pasta", 
    description: "Pasta, Oil (Medium Fat)", 
    id: 5, 
    thumbnail: "pasta.jpg", 
    glucoseProfile: []
)

let pasta_high = Food(
    name: "Pasta", 
    description: "Pasta, Oil (High Fat)", 
    id: 6, 
    thumbnail: "pasta.jpg", 
    glucoseProfile: []
)

let rice_pudding = Food(
    name: "Rice Pudding", 
    description: "Rice, pudding, sugar and cinnamon", 
    id: 7, 
    thumbnail: "rice-pudding.jpg", 
    glucoseProfile: []
)

let french_toast = Food(
    name: "French Toast", 
    description: "Toast, honey, ham, curd cheese, orange joice", 
    id: 8, 
    thumbnail: "french-toast.jpg", 
    glucoseProfile: []
)

let barley = Food(
    name: "Barley", 
    description: "Pear barley", 
    id: 9, 
    thumbnail: "barley.jpg", 
    glucoseProfile: []
)

let mashed_potato = Food(
    name: "Mashed Potato", 
    description: "Instant Mashed Potato", 
    id: 10,
     thumbnail: "mashed-potato.jpg", 
     glucoseProfile: []
    )

let eggs_and_toast = Food(
    name: "Eggs & Toast", 
    description: "2 slices of bread, 1 and ½ eggs, 1 tea spoon of margarine and orange juice", 
    id: 11,
     thumbnail: "eggs-and-toast.jpg", 
     glucoseProfile: []
    )

let whipped_cream_cereal = Food(
    name: "Whipped Cream Cereal", 
    description: "Cereal, coconut, chocolate, fruit and whipping cream", 
    id: 12,
     thumbnail: "whipped-cream-cereal.jpg", 
     glucoseProfile: []
    )

let oats1 = Food(
    name: "Oats1", 
    description: "Oats, coconut, almonds, raisins, honey, sunflower oil, banana, double cream and milk", 
    id: 13,
     thumbnail: "oats.jpeg", 
     glucoseProfile: []
    )

let oats2 = Food(
    name: "Oats2", 
    description: "Oats, coconut, almonds, raisins, honey, sunflower oil, banana, double cream and milk", 
    id: 14,
     thumbnail: "oats.jpeg", 
     glucoseProfile: []
    )

let oats3 = Food(
    name: "Oats3", 
    description: "Oats, coconut, almonds, raisins, honey, sunflower oil, banana, double cream and milk", 
    id: 15,
     thumbnail: "oats.jpeg", 
     glucoseProfile: []
    )

let breakfast = Food(
    name: "Breakfast", 
    description: "Oat loop cereal, milk, white bread, margarine, strawberry jam, orange juice", 
    id: 16,
     thumbnail: "breakfast.jpg", 
     glucoseProfile: []
    )

let foodLibrary = [
    bacon_and_eggs,
    cheese_sandwich,
    full_breakfast,
    pasta_low,
//    pasta_medium,
//    pasta_high,
    rice_pudding,
    french_toast,
    barley,
    mashed_potato,
    eggs_and_toast,
    whipped_cream_cereal,
    oats1,
//    oats2,
//    oats3,
    breakfast
]
