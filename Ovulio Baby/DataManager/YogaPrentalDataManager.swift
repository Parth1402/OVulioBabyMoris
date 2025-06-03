//
//  YogaPrentalDataManager.swift
//  Ovulio Baby
//
//  Created by Jash on 2024-03-24.
//

import UIKit

class YogaPrentalDataManager: NSObject {
    static let shared = YogaPrentalDataManager()
    private let userDefaults = UserDefaults.standard
    private let YogaPrentalModelKey = "YogaPrentalModelKey"
    
    func saveYogaPrentalModel(_ yogaPrentalModel: [YogaFertilityPositionModel]) {
        do {
            let encoder = JSONEncoder()
            let encodedYogaPrentalData = try encoder.encode(yogaPrentalModel)
            userDefaults.set(encodedYogaPrentalData, forKey: YogaPrentalModelKey)
        } catch {
            print("Error encoding YogaModel: \(error)")
        }
    }

    func retrieveYogaPrentalModel() -> [YogaFertilityPositionModel] {
        var YogaPrentalData = [YogaFertilityPositionModel]()
        if let encodedData = userDefaults.data(forKey: YogaPrentalModelKey) {
            do {
                let decoder = JSONDecoder()
                YogaPrentalData = try decoder.decode([YogaFertilityPositionModel].self, from: encodedData)
                return YogaPrentalData
            } catch {
                print("Error decoding YogaModel: \(error)")
            }
        }else{
            saveYogaPrentalModel(YogaPrentalDataContent.data)
            return retrieveYogaPrentalModel()
        }
        return YogaPrentalData
    }
}

class YogaPrentalDataContent {
    static var data = [
        YogaFertilityPositionModel(
          title: "YogaVC.YogaPrental.StandingSideBend.headline.text"~,
          images: ["1_prenatal yoga"],
          whereText: "YogaVC.YogaPrental.StandingSideBend.whereText"~,
          whyText: "YogaVC.YogaPrental.StandingSideBend.whyText"~,
          howText: "YogaVC.YogaPrental.StandingSideBend.howText"~,
          isScratched: false
        ),
        YogaFertilityPositionModel(
          title: "YogaVC.YogaPrental.WideKneedChildsPose.headline.text"~,
          images: ["2_prenatal yoga"],
          whereText: "YogaVC.YogaPrental.WideKneedChildsPose.whereText"~,
          whyText: "YogaVC.YogaPrental.WideKneedChildsPose.whyText"~,
          howText: "YogaVC.YogaPrental.WideKneedChildsPose.howText"~,
          isScratched: false
        ),
        YogaFertilityPositionModel(
          title: "YogaVC.YogaPrental.BoundAnglePose.headline.text"~,
          images: ["3_prenatal yoga"],
          whereText: "YogaVC.YogaPrental.BoundAnglePose.whereText"~,
          whyText: "YogaVC.YogaPrental.BoundAnglePose.whyText"~,
          howText: "YogaVC.YogaPrental.BoundAnglePose.howText"~,
          isScratched: false
        ),
        YogaFertilityPositionModel(
          title: "YogaVC.YogaPrental.AnkleToKneePose.headline.text"~,
          images: ["4_prenatal yoga"],
          whereText: "YogaVC.YogaPrental.AnkleToKneePose.whereText"~,
          whyText: "YogaVC.YogaPrental.AnkleToKneePose.whyText"~,
          howText: "YogaVC.YogaPrental.AnkleToKneePose.howText"~,
          isScratched: false
        ),
        YogaFertilityPositionModel(
          title: "YogaVC.YogaPrental.SeatedSideBend.headline.text"~,
          images: ["5_prenatal yoga"],
          whereText: "YogaVC.YogaPrental.SeatedSideBend.whereText"~,
          whyText: "YogaVC.YogaPrental.SeatedSideBend.whyText"~,
          howText: "YogaVC.YogaPrental.SeatedSideBend.howText"~,
          isScratched: false
        ),
        YogaFertilityPositionModel(
          title: "YogaVC.YogaPrental.StandingForwardBend.headline.text"~,
          images: ["6_prenatal yoga"],
          whereText: "YogaVC.YogaPrental.StandingForwardBend.whereText"~,
          whyText: "YogaVC.YogaPrental.StandingForwardBend.whyText"~,
          howText: "YogaVC.YogaPrental.StandingForwardBend.howText"~,
          isScratched: false
        ),
        YogaFertilityPositionModel(
          title: "YogaVC.YogaPrental.CatCowPose.headline.text"~,
          images: ["7_prenatal yoga (1)","7_prenatal yoga (2)"],
          whereText: "YogaVC.YogaPrental.CatCowPose.whereText"~,
          whyText: "YogaVC.YogaPrental.CatCowPose.whyText"~,
          howText: "YogaVC.YogaPrental.CatCowPose.howText"~,
          isScratched: false
        ),
        YogaFertilityPositionModel(
          title: "YogaVC.YogaPrental.TrianglePose.headline.text"~,
          images: ["8_prenatal yoga"],
          whereText: "YogaVC.YogaPrental.TrianglePose.whereText"~,
          whyText: "YogaVC.YogaPrental.TrianglePose.whyText"~,
          howText: "YogaVC.YogaPrental.TrianglePose.howText"~,
          isScratched: false
        ),
        YogaFertilityPositionModel(
          title: "YogaVC.YogaPrental.GarlandPose.headline.text"~,
          images: ["9_prenatal yoga"],
          whereText: "YogaVC.YogaPrental.GarlandPose.whereText"~,
          whyText: "YogaVC.YogaPrental.GarlandPose.whyText"~,
          howText: "YogaVC.YogaPrental.GarlandPose.howText"~,
          isScratched: false
        ),
        YogaFertilityPositionModel(
          title: "YogaVC.YogaPrental.SideCorpsePose.headline.text"~,
          images: ["10_prenatal yoga"],
          whereText: "YogaVC.YogaPrental.SideCorpsePose.whereText"~,
          whyText: "YogaVC.YogaPrental.SideCorpsePose.whyText"~,
          howText: "YogaVC.YogaPrental.SideCorpsePose.howText"~,
          isScratched: false
        ),
        YogaFertilityPositionModel(
          title: "YogaVC.YogaPrental.WideKneedChildsPoseModification.headline.text"~,
          images: ["11_prenatal yoga"],
          whereText: "YogaVC.YogaPrental.WideKneedChildsPoseModification.whereText"~,
          whyText: "YogaVC.YogaPrental.WideKneedChildsPoseModification.whyText"~,
          howText: "YogaVC.YogaPrental.WideKneedChildsPoseModification.howText"~,
          isScratched: false
        ),
        YogaFertilityPositionModel(
          title: "YogaVC.YogaPrental.BridgePose.headline.text"~,
          images: ["12_prenatal yoga"],
          whereText: "YogaVC.YogaPrental.BridgePose.whereText"~,
          whyText: "YogaVC.YogaPrental.BridgePose.whyText"~,
          howText: "YogaVC.YogaPrental.BridgePose.howText"~,
          isScratched: false
        ),
        YogaFertilityPositionModel(
          title: "YogaVC.YogaPrental.LegsUpTheWallPose.headline.text"~,
          images: ["13_prenatal yoga"],
          whereText: "YogaVC.YogaPrental.LegsUpTheWallPose.whereText"~,
          whyText: "YogaVC.YogaPrental.LegsUpTheWallPose.whyText"~,
          howText: "YogaVC.YogaPrental.LegsUpTheWallPose.howText"~,
          isScratched: false
        ),
        YogaFertilityPositionModel(
          title: "YogaVC.YogaPrental.SavasanaPoseOnTheBack.headline.text"~,
          images: ["14_prenatal yoga"],
          whereText: "YogaVC.YogaPrental.SavasanaPoseOnTheBack.whereText"~,
          whyText: "YogaVC.YogaPrental.SavasanaPoseOnTheBack.whyText"~,
          howText: "YogaVC.YogaPrental.SavasanaPoseOnTheBack.howText"~,
          isScratched: false
        ),
        YogaFertilityPositionModel(
          title: "YogaVC.YogaPrental.GoddessPose.headline.text"~,
          images: ["15_prenatal yoga"],
          whereText: "YogaVC.YogaPrental.GoddessPose.whereText"~,
          whyText: "YogaVC.YogaPrental.GoddessPose.whyText"~,
          howText: "YogaVC.YogaPrental.GoddessPose.howText"~,
          isScratched: false
        ),
        YogaFertilityPositionModel(
          title: "YogaVC.YogaPrental.PigeonPose.headline.text"~,
          images: ["16_prenatal yoga"],
          whereText: "YogaVC.YogaPrental.PigeonPose.whereText"~,
          whyText: "YogaVC.YogaPrental.PigeonPose.whyText"~,
          howText: "YogaVC.YogaPrental.PigeonPose.howText"~,
          isScratched: false
        ),
        YogaFertilityPositionModel(
          title: "YogaVC.YogaPrental.ChildsPose.headline.text"~,
          images: ["17_prenatal yoga"],
          whereText: "YogaVC.YogaPrental.ChildsPose.whereText"~,
          whyText: "YogaVC.YogaPrental.ChildsPose.whyText"~,
          howText: "YogaVC.YogaPrental.ChildsPose.howText"~,
          isScratched: false
        ),
        YogaFertilityPositionModel(
          title: "YogaVC.YogaPrental.FigureFourPose.headline.text"~,
          images: ["18_prenatal yoga"],
          whereText: "YogaVC.YogaPrental.FigureFourPose.whereText"~,
          whyText: "YogaVC.YogaPrental.FigureFourPose.whyText"~,
          howText: "YogaVC.YogaPrental.FigureFourPose.howText"~,
          isScratched: false
        )
    ]
}
