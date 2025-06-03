//
//  AffirmationDataManager.swift
//  Ovulio Baby
//
//  Created by Jash on 2024-04-09.
//

import Foundation

class AffirmationDataManager: NSObject {
    static let shared = AffirmationDataManager()
    private let userDefaults = UserDefaults.standard
    private let AffirmationDataModelKey = "AffirmationDataModelKey"
    
    func saveAffirmationModel(_ AffirmationModel: [[AffirmationDataModel]]) {
        do {
            let encoder = JSONEncoder()
            let encodedAffirmationData = try encoder.encode(AffirmationModel)
            userDefaults.set(encodedAffirmationData, forKey: AffirmationDataModelKey)
        } catch {
            print("Error encoding YogaModel: \(error)")
        }
    }
    
    func clearAffirmationModel() {
        userDefaults.set(nil, forKey: AffirmationDataModelKey)
    }

    func retrieveAffirmationModel() -> [[AffirmationDataModel]] {
        var AffirmationData = [[AffirmationDataModel]]()
        if let encodedData = userDefaults.data(forKey: AffirmationDataModelKey), encodedData != nil {
            do {
                let decoder = JSONDecoder()
                AffirmationData = try decoder.decode([[AffirmationDataModel]].self, from: encodedData)
                return AffirmationData
            } catch {
                print("Error decoding YogaModel: \(error)")
            }
        }else{
            var localizedKeysArray: [[AffirmationDataModel]] = []

            for categoryIndex in 0..<4 {
                var categoryKeys: [AffirmationDataModel] = []
                var numberOfHeadlines = 0
                switch categoryIndex {
                case 0:
                    numberOfHeadlines = 47
                    break
                case 1:
                    numberOfHeadlines = 9
                    break
                case 2:
                    numberOfHeadlines = 39
                    break
                case 3:
                    numberOfHeadlines = 19
                    break
                default:
                    break
                }
                for headlineIndex in 0..<numberOfHeadlines {
                    let localizedKey = "Affirmation.Categories\(categoryIndex).headline\(headlineIndex).text"
                    categoryKeys.append(AffirmationDataModel(title: localizedKey, isScratched: false))
                }
                localizedKeysArray.append(categoryKeys)
            }
            
            saveAffirmationModel(localizedKeysArray)
            return retrieveAffirmationModel()
        }
        return AffirmationData
    }
}

class AffirmationDataModel: Codable {
    var title: String!
    var isScratched: Bool!
    
    init(title: String!, isScratched: Bool!) {
        self.title = title
        self.isScratched = isScratched
    }
}
