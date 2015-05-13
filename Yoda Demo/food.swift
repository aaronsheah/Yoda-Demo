import UIKit

class Meal:Food {
    var foods:NSArray!
    
    init(name:String, description:String, id:Int, thumbnail:String, foods:NSArray) {
        super.init(name: name, description: description, id: id, thumbnail: thumbnail, glucoseProfile: [])
        self.foods = foods
    }
}

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


let bacon_and_eggs = Meal(
    name: "Bacon & Eggs",
    description: "Scrambled eggs, Canadian bacon and gelatin (Jell-O)",
    id: 1,
    thumbnail: "bacon-and-eggs.jpg",
    foods: [
        Food(
            name: "Bacon & Eggs",
            description: "Scrambled eggs, Canadian bacon and gelatin (Jell-O)",
            id: 1,
            thumbnail: "bacon-and-eggs.jpg",
            glucoseProfile:[
                0,8,6,5,4,3,2,1.5,1,0.8,0.5,0.4,0.3,0.4,0.3,0.2,0.1,0
            ]
        )
    ]
)



let cheese_sandwich = Meal(
    name: "Cheese Sandiwch",
    description: "White bread, low-fat cheese, sucrose, oil, butter",
    id: 2,
    thumbnail: "cheese-sandwich.jpg",
    foods: [
        Food(
            name: "Cheese Sandiwch",
            description: "White bread, low-fat cheese, sucrose, oil, butter",
            id: 2,
            thumbnail: "cheese-sandwich.jpg",
            glucoseProfile: [
                0,3.5,6,7,6.5,6,5,4,3,2,1.5,1,0.5
            ]
        )
    ]
)


let full_breakfast = Meal(
    name: "Full Breakfast", 
    description: "Fat milk, white rice, low-fat cheese, fructose, pear, bran-cookies, oil", 
    id: 3, 
    thumbnail: "cereal.jpg", 
    foods: [
        Food(
            name: "Full Breakfast", 
            description: "Fat milk, white rice, low-fat cheese, fructose, pear, bran-cookies, oil", 
            id: 3, 
            thumbnail: "cereal.jpg", 
            glucoseProfile: []
        )
    ]
)

let pasta_low = Food(
    name: "Low Fat", 
    description: "Pasta, Oil (Low Fat)", 
    id: 4, 
    thumbnail: "pasta.jpg", 
    glucoseProfile: [1,2,3]
)

let pasta_medium = Food(
    name: "Medium Fat", 
    description: "Pasta, Oil (Medium Fat)", 
    id: 5, 
    thumbnail: "pasta.jpg", 
    glucoseProfile: [1,2,1]
)

let pasta_high = Food(
    name: "High Fat", 
    description: "Pasta, Oil (High Fat)", 
    id: 6, 
    thumbnail: "pasta.jpg", 
    glucoseProfile: [3,2,1]
)

let pasta = Meal(
    name: "Pasta", 
    description: "Pasta, Oil", 
    id: 4, 
    thumbnail: "pasta.jpg", 
    foods: [
        pasta_low,
        pasta_medium,
        pasta_high
    ]
)

let rice_pudding = Meal(
    name: "Rice Pudding", 
    description: "Rice, pudding, sugar and cinnamon", 
    id: 7, 
    thumbnail: "rice-pudding.jpg", 
    foods: [

        Food(
            name: "Rice Pudding", 
            description: "Rice, pudding, sugar and cinnamon", 
            id: 7, 
            thumbnail: "rice-pudding.jpg", 
            glucoseProfile: []
        )
    ]
)

let french_toast = Meal(
    name: "French Toast", 
    description: "Toast, honey, ham, curd cheese, orange joice", 
    id: 8, 
    thumbnail: "french-toast.jpg", 
    foods: [
        Food(
            name: "French Toast", 
            description: "Toast, honey, ham, curd cheese, orange joice", 
            id: 8, 
            thumbnail: "french-toast.jpg", 
            glucoseProfile: []
        )
    ]
)

let barley = Meal(
    name: "Barley", 
    description: "Pear barley", 
    id: 9, 
    thumbnail: "barley.jpg", 
    foods: [
        Food(
            name: "Barley", 
            description: "Pear barley", 
            id: 9, 
            thumbnail: "barley.jpg", 
            glucoseProfile: []
        )
    ]
)

let mashed_potato = Meal(
    name: "Mashed Potato", 
    description: "Instant Mashed Potato", 
    id: 10,
    thumbnail: "mashed-potato.jpg", 
    foods: [
        Food(
            name: "Mashed Potato", 
            description: "Instant Mashed Potato", 
            id: 10,
            thumbnail: "mashed-potato.jpg", 
            glucoseProfile: []
        )
    ]
)

let eggs_and_toast = Meal(
    name: "Eggs & Toast", 
    description: "2 slices of bread, 1 and ½ eggs, 1 tea spoon of margarine and orange juice", 
    id: 11,
    thumbnail: "eggs-and-toast.jpg", 
    foods: [
        Food(
            name: "Eggs & Toast", 
            description: "2 slices of bread, 1 and ½ eggs, 1 tea spoon of margarine and orange juice", 
            id: 11,
            thumbnail: "eggs-and-toast.jpg", 
            glucoseProfile: []
        )
    ]
)

let whipped_cream_cereal = Meal(
    name: "Whipped Cream Cereal", 
    description: "Cereal, coconut, chocolate, fruit and whipping cream", 
    id: 12,
    thumbnail: "whipped-cream-cereal.jpg", 
    foods: [
        Food(
            name: "Whipped Cream Cereal", 
            description: "Cereal, coconut, chocolate, fruit and whipping cream", 
            id: 12,
             thumbnail: "whipped-cream-cereal.jpg", 
             glucoseProfile: []
        )
    ]
)

let oats1 = Food(
    name: "Oats1", 
    description: "Oats, coconut, almonds, raisins, honey, sunflower oil, banana, double cream and milk", 
    id: 13,
    thumbnail: "oats.jpeg",
    glucoseProfile: [1,2,3]
    )

let oats2 = Food(
    name: "Oats2", 
    description: "Oats, coconut, almonds, raisins, honey, sunflower oil, banana, double cream and milk", 
    id: 14,
     thumbnail: "oats.jpeg", 
     glucoseProfile: [1,2,1]
    )

let oats3 = Food(
    name: "Oats3", 
    description: "Oats, coconut, almonds, raisins, honey, sunflower oil, banana, double cream and milk", 
    id: 15,
     thumbnail: "oats.jpeg", 
     glucoseProfile: [3,2,1]
    )

let oats = Meal(
    name: "Oats",
    description: "Oats, coconut, almonds, raisins, honey, sunflower oil, banana, double cream and milk",
    id: 13,
    thumbnail: "oats.jpeg",
    foods: [
        oats1,
        oats2,
        oats3
    ]
)

let breakfast = Meal(
    name: "Breakfast", 
    description: "Oat loop cereal, milk, white bread, margarine, strawberry jam, orange juice", 
    id: 16,
    thumbnail: "breakfast.jpg", 
    foods : [
        Food(
            name: "Breakfast", 
            description: "Oat loop cereal, milk, white bread, margarine, strawberry jam, orange juice", 
            id: 16,
            thumbnail: "breakfast.jpg", 
            glucoseProfile: []
        )
    ]
)

//let foodLibrary = [
//    bacon_and_eggs,
//    cheese_sandwich,
//    full_breakfast,
//    pasta_low,
////    pasta_medium,
////    pasta_high,
//    rice_pudding,
//    french_toast,
//    barley,
//    mashed_potato,
//    eggs_and_toast,
//    whipped_cream_cereal,
//    oats1,
////    oats2,
////    oats3,
//    breakfast
//]

let mealLibrary = [
    bacon_and_eggs,
    cheese_sandwich,
    full_breakfast,
    pasta,
    rice_pudding,
    french_toast,
    barley,
    mashed_potato,
    eggs_and_toast,
    whipped_cream_cereal,
    oats,
    breakfast
]
