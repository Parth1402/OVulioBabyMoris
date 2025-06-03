//
//  GamesDataManager.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-20.
//

import Foundation

class GamesDataManager {

    static let shared = GamesDataManager()
    private let userDefaults = UserDefaults.standard
    private let gamesKey = "gamesData"
    private let gameLevelsDataForBoyUDKey = "gameLevelsDataForBoyUDKey"
    private let gameLevelsDataForGirlUDKey = "gameLevelsDataForGirlUDKey"
    private let gameLevelsDataForDoesntMatterUDKey = "gameLevelsDataForDoesntMatterUDKey"
    private let dontShowLegsUpUDKey = "dontShowLegsUpUDKey"
    
    var needToShowLegsUpScreen: Bool? {
        get {
            return userDefaults.value(forKey: dontShowLegsUpUDKey) as? Bool
        }
        set {
            userDefaults.set(newValue, forKey: dontShowLegsUpUDKey)
        }
    }
    
    func updateNeedToShowLegsUpScreen(_ dontShowLegsUp: Bool?) {
        needToShowLegsUpScreen = dontShowLegsUp
    }

    private var keyForLevelData: String {
        get{
            if ProfileDataManager.shared.selectedGender == .boy{
                return self.gameLevelsDataForBoyUDKey
            }else{
                if ProfileDataManager.shared.selectedGender == .girl{
                    return self.gameLevelsDataForGirlUDKey
                }else{
                    return self.gameLevelsDataForDoesntMatterUDKey
                }
            }
        }
    }
    
    func saveGamesModel(_ gamesModel: GamesModel) {
        do {
            let encoder = JSONEncoder()
            let encodedGameData = try encoder.encode(gamesModel)
            userDefaults.set(encodedGameData, forKey: gamesKey)
            let encodedLevelData = try encoder.encode(gamesModel.gameLevels)
            userDefaults.set(encodedLevelData, forKey: keyForLevelData)
        } catch {
            print("Error encoding GamesModel: \(error)")
        }
    }

    func retrieveGamesModel() -> GamesModel? {
        var gameData = GamesModel()
        if let encodedData = userDefaults.data(forKey: gamesKey) {
            do {
                let decoder = JSONDecoder()
                gameData = try decoder.decode(GamesModel.self, from: encodedData)
                if let encodedLevelData = userDefaults.data(forKey: keyForLevelData) {
                    do {
                        let decoder = JSONDecoder()
                        gameData.gameLevels = try decoder.decode([GameLevelModel].self, from: encodedLevelData)
                    } catch {
                        print("Error decoding GamesModel: \(error)")
                    }
                }else{
                    gameData.gameLevels = setUpGameLevelData()
                }
                return gameData
            } catch {
                print("Error decoding GamesModel: \(error)")
            }
        }else{
            setUpGameData()
            return retrieveGamesModel()
        }
        return gameData
    }

//    func clearGamesModel() {
//        userDefaults.removeObject(forKey: gamesKey)
//    }
    
    func setUpGameData() {
        let gamesData = GamesModel()
        gamesData.gameLevels = setUpGameLevelData()
        
        let places = ExtrasModel(headline: "GamesModel.LocationsModel.AtHome.OnTheCouch.text"~, points: 3, isAlreadyCompleted: false)
        let places1 = ExtrasModel(headline: "GamesModel.LocationsModel.AtHome.OnTheFloor.text"~, points: 3, isAlreadyCompleted: false)
        let places2 = ExtrasModel(headline: "GamesModel.LocationsModel.AtHome.OnAChair.text"~, points: 3, isAlreadyCompleted: false)
        let places3 = ExtrasModel(headline: "GamesModel.LocationsModel.AtHome.OnTheDiningTable.text"~, points: 3, isAlreadyCompleted: false)
        let places4 = ExtrasModel(headline: "GamesModel.LocationsModel.AtHome.InTheBathroom.text"~, points: 3, isAlreadyCompleted: false)
        let places5 = ExtrasModel(headline: "GamesModel.LocationsModel.AtHome.InTheShower.text"~, points: 4, isAlreadyCompleted: false)
        let places6 = ExtrasModel(headline: "GamesModel.LocationsModel.AtHome.InTheKitchen.text"~, points: 4, isAlreadyCompleted: false)
        let places7 = ExtrasModel(headline: "GamesModel.LocationsModel.AtHome.InTheCloset.text"~, points: 4, isAlreadyCompleted: false)
        let places8 = ExtrasModel(headline: "GamesModel.LocationsModel.AtHome.AgainstAWall.text"~, points: 4, isAlreadyCompleted: false)
        let places9 = ExtrasModel(headline: "GamesModel.LocationsModel.AtHome.OnTheStairs.text"~, points: 4, isAlreadyCompleted: false)
        let places10 = ExtrasModel(headline: "GamesModel.LocationsModel.AtHome.InTheAttic.text"~, points: 4, isAlreadyCompleted: false)
        let places11 = ExtrasModel(headline: "GamesModel.LocationsModel.AtHome.OnAYogaMat.text"~, points: 4, isAlreadyCompleted: false)
        let places12 = ExtrasModel(headline: "GamesModel.LocationsModel.AtHome.OnTheWashingMachine.text"~, points: 5, isAlreadyCompleted: false)
        let places13 = ExtrasModel(headline: "GamesModel.LocationsModel.AtHome.InFrontOfAMirror.text"~, points: 5, isAlreadyCompleted: false)
        let places14 = ExtrasModel(headline: "GamesModel.LocationsModel.AtHome.AtTheFrontDoor.text"~, points: 5, isAlreadyCompleted: false)
        let places15 = ExtrasModel(headline: "GamesModel.LocationsModel.AtHome.BehindAWindow.text"~, points: 5, isAlreadyCompleted: false)
        let places16 = ExtrasModel(headline: "GamesModel.LocationsModel.AtHome.InTheBasement.text"~, points: 5, isAlreadyCompleted: false)
        let places17 = ExtrasModel(headline: "GamesModel.LocationsModel.AtHome.OnTheBalconyIntheGarden.text"~, points: 6, isAlreadyCompleted: false)
        let places18 = ExtrasModel(headline: "GamesModel.LocationsModel.AtHome.InTheGardenHouseGarage.text"~, points: 6, isAlreadyCompleted: false)
        let locations = LocationsModel(headline: "GamesModel.LocationsModel.AtHome.headlineLabel.text"~, places: [places, places1, places2, places3, places4, places5, places6, places7, places8, places9, places10, places11, places12, places13, places14, places15, places16, places17, places18])
        gamesData.locations = [locations]
        
        let extras = ExtrasModel(headline: "GamesModel.ExtrasModel.DirtyTalk.text"~, points: 2, isAlreadyCompleted: false)
        let extras1 = ExtrasModel(headline: "GamesModel.ExtrasModel.Fingering.text"~, points: 2, isAlreadyCompleted: false)
        let extras2 = ExtrasModel(headline: "GamesModel.ExtrasModel.Oral.text"~, points: 3, isAlreadyCompleted: false)
        let extras3 = ExtrasModel(headline: "GamesModel.ExtrasModel.Blindfold.text"~, points: 3, isAlreadyCompleted: false)
        let extras4 = ExtrasModel(headline: "GamesModel.ExtrasModel.Handcuffs.text"~, points: 3, isAlreadyCompleted: false)
        let extras5 = ExtrasModel(headline: "GamesModel.ExtrasModel.HairPulling.text"~, points: 3, isAlreadyCompleted: false)
        let extras6 = ExtrasModel(headline: "GamesModel.ExtrasModel.GrabByTheNeck.text"~, points: 3, isAlreadyCompleted: false)
        let extras7 = ExtrasModel(headline: "GamesModel.ExtrasModel.WithEarplug.text"~, points: 4, isAlreadyCompleted: false)
        let extras8 = ExtrasModel(headline: "GamesModel.ExtrasModel.Bondage.text"~, points: 5, isAlreadyCompleted: false)
        let extras9 = ExtrasModel(headline: "GamesModel.ExtrasModel.Sextoys.text"~, points: 5, isAlreadyCompleted: false)
        let extras10 = ExtrasModel(headline: "GamesModel.ExtrasModel.HotWaxMassage.text"~, points: 5, isAlreadyCompleted: false)
        let extras11 = ExtrasModel(headline: "GamesModel.ExtrasModel.RolePlaying.text"~, points: 5, isAlreadyCompleted: false)
        let extras12 = ExtrasModel(headline: "GamesModel.ExtrasModel.WatchPorn.text"~, points: 10, isAlreadyCompleted: false)
        let extras13 = ExtrasModel(headline: "GamesModel.ExtrasModel.Whipping.text"~, points: 15, isAlreadyCompleted: false)
        let extras14 = ExtrasModel(headline: "GamesModel.ExtrasModel.SexTape.text"~, points: 25, isAlreadyCompleted: false)
        gamesData.extras = [extras, extras1, extras2, extras3, extras4, extras5, extras6, extras7, extras8, extras9, extras10, extras11, extras12, extras13, extras14]
        self.saveGamesModel(gamesData)
    }
    
    func setUpGameLevelData() -> [GameLevelModel]? {
        if ProfileDataManager.shared.selectedGender == .boy {
            return setUpGameLevelData(headlineArray: GameLevelRawData.boyLevelsHeadlines, levels: GameLevelRawData.boyLevels)
        }else if ProfileDataManager.shared.selectedGender == .girl {
            return setUpGameLevelData(headlineArray: GameLevelRawData.girlLevelsHeadlines, levels: GameLevelRawData.girlLevels)
        }else{
            return setUpGameLevelData(headlineArray: GameLevelRawData.doesntMatterLevelsHeadlines, levels: GameLevelRawData.doesntMatterLevels)
        }
    }
    
    func setUpGameLevelData(headlineArray: [String], levels: NSDictionary) -> [GameLevelModel]? {
        var levelsArray = [GameLevelModel]()
        for (headline) in headlineArray {
            if let levelInfo = levels.value(forKey: headline) as? [String: Any] {
                var cardsArray = [ScrachCardModel]()
                if let cards = levelInfo["cards"] as? [[String: Any]] {
                    for card in cards {
                        if let image = card["image"] as? String,
                           let probability = card["probability"] as? GenderOption {
                            cardsArray.append(ScrachCardModel(cardImage: image, probability: probability, isAlreadyScrached: false))
                        }
                    }
                }
                levelsArray.append(GameLevelModel(headline: headline, complexity: (levelInfo["complexity"] as? LevelComplexity) ?? .easy, cards: cardsArray, pointPerCard: (levelInfo["pointPerCard"] as? Int) ?? 0))
            }
        }
        return levelsArray
    }
}


class GameLevelRawData {
    static let boyLevelsHeadlines = [
        "GamesVC.LevelsAndPositionCardsHeader.level1.headlineLabel.text"~,
        "GamesVC.LevelsAndPositionCardsHeader.level2.headlineLabel.text"~,
        "GamesVC.LevelsAndPositionCardsHeader.level3.headlineLabel.text"~,
        "GamesVC.LevelsAndPositionCardsHeader.InCar.headlineLabel.text"~,
        "GamesVC.LevelsAndPositionCardsHeader.InBath.headlineLabel.text"~,
        "GamesVC.LevelsAndPositionCardsHeader.Bondage.headlineLabel.text"~,
    ]
    static let boyLevels: NSDictionary = [
        "GamesVC.LevelsAndPositionCardsHeader.level1.headlineLabel.text"~: [
            "complexity": LevelComplexity.easy,
            "pointPerCard": 1,
            "cards": [
                ["image": "OvulioBaby_ Position_1.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_2.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_3.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_4.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_5.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_6.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_7.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_8.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_9.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_10.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_11.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_12.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_13.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_14.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_15.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_17.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_18.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_21.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_23.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_26.jpg", "probability": GenderOption.boy]
            ]
        ],
        "GamesVC.LevelsAndPositionCardsHeader.level2.headlineLabel.text"~: [
            "complexity": LevelComplexity.medium,
            "pointPerCard": 2,
            "cards": [
                ["image": "OvulioBaby_ Position_27.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_30.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_31.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_33.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_35.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_36.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_38.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_40.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_41.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_42.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_45.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_46.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_47.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_48.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_50.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_51.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_53.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_55.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_56.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_58.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_61.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_64.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_66.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_67.jpg", "probability": GenderOption.boy]
            ]
        ],
        "GamesVC.LevelsAndPositionCardsHeader.level3.headlineLabel.text"~: [
            "complexity": LevelComplexity.complicated,
            "pointPerCard": 3,
            "cards": [
                ["image": "OvulioBaby_ Position_69.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_73.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_76.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_77.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_78.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_79.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_83.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_84.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_87.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_88.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_89.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_90.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_91.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_92.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_93.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_94.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_95.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_96.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_97.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_98.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_99.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_100.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_101.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_102.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_103.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_104.jpg", "probability": GenderOption.boy]
            ]
        ],
        "GamesVC.LevelsAndPositionCardsHeader.InCar.headlineLabel.text"~: [
            "complexity": LevelComplexity.kinky,
            "pointPerCard": 4,
            "cards": [
                ["image": "OvulioBaby_In Car_1.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Car_2.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Car_3.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Car_5.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Car_7.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Car_9.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Car_12.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Car_13.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Car_14.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Car_15.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Car_17.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Car_18.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Car_19.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Car_21.jpg", "probability": GenderOption.boy]
            ]
        ],
        "GamesVC.LevelsAndPositionCardsHeader.InBath.headlineLabel.text"~: [
            "complexity": LevelComplexity.sparkling,
            "pointPerCard": 5,
            "cards": [
                ["image": "OvulioBaby_In Bath_3.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Bath_4.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Bath_5.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Bath_6.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Bath_7.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Bath_8.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Bath_9.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Bath_11.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Bath_13.jpg", "probability": GenderOption.boy]
            ]
        ],
        "GamesVC.LevelsAndPositionCardsHeader.Bondage.headlineLabel.text"~: [
            "complexity": LevelComplexity.captivating,
            "pointPerCard": 6,
            "cards": [
                ["image": "OvulioBaby_ Bondage_1.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Bondage_2.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Bondage_3.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Bondage_4.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Bondage_7.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Bondage_8.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Bondage_9.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Bondage_10.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Bondage_11.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Bondage_12.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Bondage_14.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Bondage_15.jpg", "probability": GenderOption.boy]
            ]
        ]
    ]
    
    static let girlLevelsHeadlines = [
        "GamesVC.LevelsAndPositionCardsHeader.level1.headlineLabel.text"~,
        "GamesVC.LevelsAndPositionCardsHeader.level2.headlineLabel.text"~,
        "GamesVC.LevelsAndPositionCardsHeader.level3.headlineLabel.text"~,
        "GamesVC.LevelsAndPositionCardsHeader.InCar.headlineLabel.text"~,
        "GamesVC.LevelsAndPositionCardsHeader.InBath.headlineLabel.text"~,
        "GamesVC.LevelsAndPositionCardsHeader.Bondage.headlineLabel.text"~,
    ]
    static let girlLevels: NSDictionary = [
        "GamesVC.LevelsAndPositionCardsHeader.level1.headlineLabel.text"~: [
            "complexity": LevelComplexity.easy,
            "pointPerCard": 1,
            "cards": [
                ["image": "OvulioBaby_ Position_16.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_19.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_20.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_22.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_24.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_25.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_32.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_34.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_37.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_39.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_43.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_44.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_44.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_105.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_106.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_107.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_108.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_109.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_110.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_111.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_112.jpg", "probability": GenderOption.girl],
            ]
        ],
        "GamesVC.LevelsAndPositionCardsHeader.level2.headlineLabel.text"~: [
            "complexity": LevelComplexity.medium,
            "pointPerCard": 2,
            "cards": [
                ["image": "OvulioBaby_ Position_49.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_52.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_62.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_63.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_65.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_68.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_75.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_80.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_81.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_82.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_86.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_113.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_114.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_115.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_116.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_117.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_118.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_119.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_120.jpg", "probability": GenderOption.girl],
            ]
        ],
        "GamesVC.LevelsAndPositionCardsHeader.level3.headlineLabel.text"~: [
            "complexity": LevelComplexity.complicated,
            "pointPerCard": 3,
            "cards": [
                ["image": "OvulioBaby_ Position_121.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_122.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_123.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_124.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_125.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_126.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_127.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_128.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_129.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_130.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_131.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_132.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_133.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_134.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_135.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_136.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_137.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_138.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_139.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_140.jpg", "probability": GenderOption.girl],
            ]
        ],
        "GamesVC.LevelsAndPositionCardsHeader.InCar.headlineLabel.text"~: [
            "complexity": LevelComplexity.complicated,
            "pointPerCard": 4,
            "cards": [
                ["image": "OvulioBaby_In Car_4.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Car_6.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Car_8.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Car_10.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Car_11.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Car_16.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Car_20.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Car_22.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Car_23.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Car_24.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Car_25.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Car_26.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Car_27.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Car_28.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Car_29.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Car_30.jpg", "probability": GenderOption.girl],
            ]
        ],
        "GamesVC.LevelsAndPositionCardsHeader.InBath.headlineLabel.text"~: [
            "complexity": LevelComplexity.sparkling,
            "pointPerCard": 5,
            "cards": [
                ["image": "OvulioBaby_In Bath_1.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Bath_2.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Bath_10.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Bath_12.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Bath_14.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Bath_15.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Bath_16.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Bath_17.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Bath_18.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Bath_19.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Bath_20.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Bath_21.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Bath_22.jpg", "probability": GenderOption.girl],
            ]
        ],
        "GamesVC.LevelsAndPositionCardsHeader.Bondage.headlineLabel.text"~: [
            "complexity": LevelComplexity.captivating,
            "pointPerCard": 6,
            "cards": [
                ["image": "OvulioBaby_ Bondage_5.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Bondage_6.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Bondage_13.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Bondage_16.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Bondage_17.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Bondage_18.jpg", "probability": GenderOption.girl],
            ]
        ]
    ]
    
    static let doesntMatterLevelsHeadlines = [
        "GamesVC.LevelsAndPositionCardsHeader.level1.headlineLabel.text"~,
        "GamesVC.LevelsAndPositionCardsHeader.level2.headlineLabel.text"~,
        "GamesVC.LevelsAndPositionCardsHeader.level3.headlineLabel.text"~,
        "GamesVC.LevelsAndPositionCardsHeader.InCar.headlineLabel.text"~,
        "GamesVC.LevelsAndPositionCardsHeader.InBath.headlineLabel.text"~,
        "GamesVC.LevelsAndPositionCardsHeader.Bondage.headlineLabel.text"~,
    ]
    static let doesntMatterLevels: NSDictionary = [
        "GamesVC.LevelsAndPositionCardsHeader.level1.headlineLabel.text"~: [
            "complexity": LevelComplexity.easy,
            "pointPerCard": 1,
            "cards": [
                ["image": "OvulioBaby_ Position_1.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_2.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_3.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_4.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_5.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_6.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_7.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_8.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_9.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_10.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_11.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_12.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_13.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_14.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_15.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_16.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_17.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_18.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_19.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_20.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_21.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_22.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_23.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_24.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_25.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_26.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_105.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_106.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_107.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_108.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_109.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_110.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_111.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_112.jpg", "probability": GenderOption.girl],
            ]
        ],
        "GamesVC.LevelsAndPositionCardsHeader.level2.headlineLabel.text"~: [
            "complexity": LevelComplexity.medium,
            "pointPerCard": 2,
            "cards": [
                ["image": "OvulioBaby_ Position_27.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_30.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_31.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_32.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_33.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_34.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_35.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_36.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_37.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_38.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_39.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_40.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_41.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_42.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_43.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_44.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_45.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_46.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_47.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_48.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_50.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_51.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_53.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_55.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_56.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_58.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_61.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_64.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_66.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_67.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_113.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_114.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_115.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_116.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_117.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_118.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_119.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_120.jpg", "probability": GenderOption.girl],
            ]
        ],
        "GamesVC.LevelsAndPositionCardsHeader.level3.headlineLabel.text"~: [
            "complexity": LevelComplexity.complicated,
            "pointPerCard": 3,
            "cards": [
                ["image": "OvulioBaby_ Position_49.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_52.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_62.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_63.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_65.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_68.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_69.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_73.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_75.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_76.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_77.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_78.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_79.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_80.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_81.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_82.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_83.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_84.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_86.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_87.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_88.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_89.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_90.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_91.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_92.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_93.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_94.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_95.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_96.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_97.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_98.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_99.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_100.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_101.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_102.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_103.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_104.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Position_121.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_122.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_123.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_124.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_125.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_126.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_127.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_128.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_129.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_130.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_131.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_132.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_133.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_134.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_135.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_136.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_137.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_138.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_139.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Position_140.jpg", "probability": GenderOption.girl],
            ]
        ],
        "GamesVC.LevelsAndPositionCardsHeader.InCar.headlineLabel.text"~: [
            "complexity": LevelComplexity.kinky,
            "pointPerCard": 4,
            "cards": [
                ["image": "OvulioBaby_In Car_1.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Car_2.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Car_3.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Car_4.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Car_5.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Car_6.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Car_7.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Car_8.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Car_9.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Car_10.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Car_11.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Car_12.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Car_13.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Car_14.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Car_15.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Car_16.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Car_17.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Car_18.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Car_19.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Car_20.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Car_21.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Car_22.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Car_23.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Car_24.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Car_25.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Car_26.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Car_27.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Car_28.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Car_29.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Car_30.jpg", "probability": GenderOption.girl],
                
            ]
        ],
        "GamesVC.LevelsAndPositionCardsHeader.InBath.headlineLabel.text"~: [
            "complexity": LevelComplexity.sparkling,
            "pointPerCard": 5,
            "cards": [
                ["image": "OvulioBaby_In Bath_1.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Bath_2.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Bath_3.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Bath_4.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Bath_5.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Bath_6.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Bath_7.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Bath_8.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Bath_9.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Bath_10.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Bath_11.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Bath_12.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Bath_13.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_In Bath_14.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Bath_15.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Bath_16.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Bath_17.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Bath_18.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Bath_19.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Bath_20.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Bath_21.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_In Bath_22.jpg", "probability": GenderOption.girl],
            ]
        ],
        "GamesVC.LevelsAndPositionCardsHeader.Bondage.headlineLabel.text"~: [
            "complexity": LevelComplexity.captivating,
            "pointPerCard": 6,
            "cards": [
                ["image": "OvulioBaby_ Bondage_1.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Bondage_2.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Bondage_3.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Bondage_4.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Bondage_5.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Bondage_6.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Bondage_7.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Bondage_8.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Bondage_9.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Bondage_10.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Bondage_11.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Bondage_12.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Bondage_13.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Bondage_14.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Bondage_15.jpg", "probability": GenderOption.boy],
                ["image": "OvulioBaby_ Bondage_16.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Bondage_17.jpg", "probability": GenderOption.girl],
                ["image": "OvulioBaby_ Bondage_18.jpg", "probability": GenderOption.girl],
            ]
        ]
    ]
}
