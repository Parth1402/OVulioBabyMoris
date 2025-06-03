//
//  YogaFertilityDataManager.swift
//  Ovulio Baby
//
//  Created by Jash on 2024-03-21.
//

import UIKit

class YogaFertilityDataManager: NSObject {
    static let shared = YogaFertilityDataManager()
    private let userDefaults = UserDefaults.standard
    private let YogaFertilityModelKey = "YogaFertilityPositionModelKey"
    
    func saveYogaFertilityModel(_ yogaFertilityModel: [YogaFertilityPositionModel]) {
        do {
            let encoder = JSONEncoder()
            let encodedYogaFertilityData = try encoder.encode(yogaFertilityModel)
            userDefaults.set(encodedYogaFertilityData, forKey: YogaFertilityModelKey)
        } catch {
            print("Error encoding YogaFertilityModel: \(error)")
        }
    }

    func retrieveYogaFertilityModel() -> [YogaFertilityPositionModel] {
        var YogaFertilityData = [YogaFertilityPositionModel]()
        if let encodedData = userDefaults.data(forKey: YogaFertilityModelKey) {
            do {
                let decoder = JSONDecoder()
                YogaFertilityData = try decoder.decode([YogaFertilityPositionModel].self, from: encodedData)
                return YogaFertilityData
            } catch {
                print("Error decoding YogaFertilityModel: \(error)")
            }
        }else{
            saveYogaFertilityModel(YogaFertilityPositionData.data)
            return retrieveYogaFertilityModel()
        }
        return YogaFertilityData
    }
}

class YogaFertilityPositionModel: Codable {
    var title: String!
    var images: [String]!
    var whereText: String!
    var whyText: String!
    var howText: String!
    var isScratched: Bool!
    
    init(title: String!, images: [String]!, whereText: String!, whyText: String!, howText: String!, isScratched: Bool!) {
        self.title = title
        self.images = images
        self.whereText = whereText
        self.whyText = whyText
        self.howText = howText
        self.isScratched = isScratched
    }
}

class YogaFertilityPositionData {
    static var data = [
        YogaFertilityPositionModel(
          title: "YogaVC.YogaFertility.RecliningBoundAngle.headline.text"~,
          images: ["1_fertility yoga"],
          whereText: "YogaVC.YogaFertility.RecliningBoundAngle.whereText"~,
          whyText: "YogaVC.YogaFertility.RecliningBoundAngle.whyText"~,
          howText: "YogaVC.YogaFertility.RecliningBoundAngle.howText"~,
          isScratched: false
        ),
        YogaFertilityPositionModel(
          title: "YogaVC.FertilityPosition.WarriorIIPose.headline.text"~,
          images: ["2_fertility yoga"],
          whereText: "YogaVC.FertilityPosition.WarriorIIPose.whereText"~,
          whyText: "YogaVC.FertilityPosition.WarriorIIPose.whyText"~,
          howText: "YogaVC.FertilityPosition.WarriorIIPose.howText"~,
          isScratched: false
        ),
        YogaFertilityPositionModel(
          title: "YogaVC.FertilityPosition.CobraPose.headline.text"~,
          images: ["3_fertility yoga"],
          whereText: "YogaVC.FertilityPosition.CobraPose.whereText"~,
          whyText: "YogaVC.FertilityPosition.CobraPose.whyText"~,
          howText: "YogaVC.FertilityPosition.CobraPose.howText"~,
          isScratched: false
        ),
        YogaFertilityPositionModel(
          title: "YogaVC.FertilityPosition.FrogPose.headline.text"~,
          images: ["4_fertility yoga"],
          whereText: "YogaVC.FertilityPosition.FrogPose.whereText"~,
          whyText: "YogaVC.FertilityPosition.FrogPose.whyText"~,
          howText: "YogaVC.FertilityPosition.FrogPose.howText"~,
          isScratched: false
        ),
        YogaFertilityPositionModel(
          title: "YogaVC.FertilityPosition.SeatedForwardBendPose.headline.text"~,
          images: ["5_fertility yoga (1)", "5_fertility yoga (2)", "5_fertility yoga (3)"],
          whereText: "YogaVC.FertilityPosition.SeatedForwardBendPose.whereText"~,
          whyText: "YogaVC.FertilityPosition.SeatedForwardBendPose.whyText"~,
          howText: "YogaVC.FertilityPosition.SeatedForwardBendPose.howText"~,
          isScratched: false
        ),
        YogaFertilityPositionModel(
          title: "YogaVC.FertilityPosition.HeadToKneePose.headline.text"~,
          images: ["6_fertility yoga (1)", "6_fertility yoga (2)", "6_fertility yoga (3)"],
          whereText: "YogaVC.FertilityPosition.HeadToKneePose.whereText"~,
          whyText: "YogaVC.FertilityPosition.HeadToKneePose.whyText"~,
          howText: "YogaVC.FertilityPosition.HeadToKneePose.howText"~,
          isScratched: false
        ),
        YogaFertilityPositionModel(
          title: "YogaVC.FertilityPosition.BridgePose.headline.text"~,
          images: ["7_fertility yoga"],
          whereText: "YogaVC.FertilityPosition.BridgePose.whereText"~,
          whyText: "YogaVC.FertilityPosition.BridgePose.whyText"~,
          howText: "YogaVC.FertilityPosition.BridgePose.howText"~,
          isScratched: false
        ),
        YogaFertilityPositionModel(
          title: "YogaVC.FertilityPosition.PlowPose.headline.text"~,
          images: ["8_fertility yoga"],
          whereText: "YogaVC.FertilityPosition.PlowPose.whereText"~,
          whyText: "YogaVC.FertilityPosition.PlowPose.whyText"~,
          howText: "YogaVC.FertilityPosition.PlowPose.howText"~,
          isScratched: false
        )
    ]
}
