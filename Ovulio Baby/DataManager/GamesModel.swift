//
//  GamesModel.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-20.
//

import Foundation

class GamesModel: Codable {
    var gameLevels: [GameLevelModel]?
    var locations: [LocationsModel]?
    var extras: [ExtrasModel]?
}

enum LevelComplexity: String, Codable {
    case easy = "Easy"
    case medium = "Medium"
    case complicated = "Complicated"
    case sparkling = "Sparkling"
    case kinky = "Kinky"
    case captivating = "Captivating"
    
    var stars: Double {
        switch self {
        case .easy:
            return 1
        case .medium:
            return 2
        case .complicated:
            return 3
        case .kinky:
            return 4
        case .sparkling:
            return 5
        case .captivating:
            return 6
        }
    }
}

class GameLevelModel: Codable {
    var headline: String
    var complexity: LevelComplexity
    var cards: [ScrachCardModel]
    var pointPerCard: Int
    
    init(headline: String, complexity: LevelComplexity, cards: [ScrachCardModel], pointPerCard: Int) {
        self.headline = headline
        self.complexity = complexity
        self.cards = cards
        self.pointPerCard = pointPerCard
    }
}

class ScrachCardModel: Codable {
    var cardImage: String
    var isAlreadyScrached: Bool
    var probability: GenderOption
    
    var probabilityImage: String {
        switch probability {
        case .boy:
            return "boyButtonIMG"
        case .girl:
            return "girlButtonIMG"
        case .doesntMatter:
            return "Not Found"
        }
    }
    
    var probabilityTitle: String {
        switch probability {
        case .boy:
            return "YourGoalSelectionVC.gender.boy.text"~
        case .girl:
            return "YourGoalSelectionVC.gender.girl.text"~
        case .doesntMatter:
            return "Not Found"
        }
    }
    
    init(cardImage: String, probability: GenderOption, isAlreadyScrached: Bool = false) {
        self.cardImage = cardImage
        self.isAlreadyScrached = isAlreadyScrached
        self.probability = probability
    }
}

class LocationsModel: Codable {
    var headline: String
    var places: [ExtrasModel]
    
    init(headline: String, places: [ExtrasModel]) {
        self.headline = headline
        self.places = places
    }
}

//class LocationsModel: Codable {
//    var headline: String
//    var points: Int
//    var places: [PlacesModel]
//
//    init(headline: String, points: Int, places: [PlacesModel]) {
//        self.headline = headline
//        self.points = points
//        self.places = places
//    }
//}
//
//class PlacesModel: Codable {
//    var headline: String
//    var isAlreadyCompleted: Bool
//
//    init(headline: String, isAlreadyCompleted: Bool) {
//        self.headline = headline
//        self.isAlreadyCompleted = isAlreadyCompleted
//    }
//}

class ExtrasModel: Codable {
    var headline: String
    var points: Int
    var isAlreadyCompleted: Bool
    
    init(headline: String, points: Int, isAlreadyCompleted: Bool) {
        self.headline = headline
        self.points = points
        self.isAlreadyCompleted = isAlreadyCompleted
    }
}
