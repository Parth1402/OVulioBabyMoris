//
//  FirestoreManager.swift
//  SendPushNotifications
//
//  Created by Irakli Chkhitunidze on 12/12/23.
//

import FirebaseFirestore

extension Date {
    
    func getFormattedDate(format: String)-> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
}


class FirestoreManager {
    // Update monthly Tracking Data
    let db = Firestore.firestore()
    let currentDateMonthFormate = Date().getFormattedDate(format: "MM-yyyy")  // Set output formate
    let currentDateMonthAndDayFormate = Date().getFormattedDate(format: "dd-MM-yyyy")  // Set output formate

    func updateMonthlyTrackingData(){
         let docRefTracking = db.collection("tracking").document(currentDateMonthFormate)
        
            docRefTracking.getDocument { (document, error) in
                
                if let document = document, document.exists {
                    
                    docRefTracking.updateData(["activatedActivationCodes" : FieldValue.increment(Int64(1))])
                    
                } else {
                    
                    docRefTracking.setData(["activatedActivationCodes" : 1], merge: true)
                    
                }
                
            }
        
    }
    
//    // Update Tracking Data
    
    func updateTrackingData(){
        let countIapShoterSalesPageMenuOpen_BedroomGame = 1
        let countIapSpecialGiftMenuOpen = 1

        
        
            let docRefTracking = db.collection("tracking").document("CountIapMenuOpenBeforePurchase")
            docRefTracking.setData(["numberOfCancelledPurchases" : FieldValue.increment(Int64(1))])  // comment for Test purpose only
        
        
        
            let docRefTracking_BedroomGame = db.collection("tracking").document("CountIapShoterSalesPageMenuOpen_BedroomGame")
            docRefTracking_BedroomGame.setData(["\(countIapShoterSalesPageMenuOpen_BedroomGame)" : FieldValue.increment(Int64(1))])
        
            // To build average value
            docRefTracking_BedroomGame.setData(["numberOfPurchases" : FieldValue.increment(Int64(1))])
            docRefTracking_BedroomGame.setData(["numberOfIapMenuOpens" : FieldValue.increment(Int64(countIapShoterSalesPageMenuOpen_BedroomGame))])
        
        
        
            let docRefTrackingV2 = db.collection("tracking").document("CountIapSpecialGiftMenuOpenBeforePurchase")
        docRefTrackingV2.setData(["\(countIapSpecialGiftMenuOpen)" : FieldValue.increment(Int64(1))])
        
            // To build average value
        docRefTrackingV2.setData(["numberOfPurchases" : FieldValue.increment(Int64(1))])
        docRefTrackingV2.setData(["numberOfIapMenuOpens" : FieldValue.increment(Int64(countIapSpecialGiftMenuOpen))])
        
    }
    
    func updateTrackingPurchasesData(){
        // Update Lifetime Tracking Data
        let docRefTrackingSales = db.collection("tracking").document("CountInAppPurchases")
    //    docRefTrackingSales.setData(["3monthsSubscription" : FieldValue.increment(Int64(3))], merge: true)
//        docRefTrackingSales.setData(["estimatedRevenue" : FieldValue.increment(Int64(1))], merge: true)
//        docRefTrackingSales.setData(["monthlySubscription" : FieldValue.increment(Int64(3))], merge: true)
        docRefTrackingSales.setData(["weeklySubscription" : FieldValue.increment(Int64(1))], merge: true)
//
//        // Update Daily Tracking Data
        let docRefTracking = db.collection("tracking").document("CountInAppPurchases").collection(currentDateMonthFormate).document(currentDateMonthAndDayFormate)
//        docRefTracking.setData(["3monthsSubscription" : FieldValue.increment(Int64(1))], merge: true)
////        docRefTracking.setData(["estimatedRevenue" : FieldValue.increment(Int64(1))], merge: true)
//        docRefTracking.setData(["monthlySubscription" : FieldValue.increment(Int64(1))], merge: true)
        docRefTracking.setData(["weeklySubscription" : FieldValue.increment(Int64(1))], merge: true)
//
        // Update Monthly Tracking Data
        let docRefTrackingMonthly = docRefTrackingSales.collection(currentDateMonthFormate).document("purchaseSummary")
//        docRefTrackingMonthly.setData(["3monthsSubscription" : FieldValue.increment(Int64(2))], merge: true)
////        docRefTrackingMonthly.setData(["estimatedRevenue" : FieldValue.increment(Int64(2))], merge: true)
//        docRefTrackingMonthly.setData(["monthlySubscription" : FieldValue.increment(Int64(2))], merge: true)
        docRefTrackingMonthly.setData(["weeklySubscription" : FieldValue.increment(Int64(1))], merge: true)
    }
    
    func getTodaysTrackingPurchasesData(completionHandler: @escaping (TrackingDataModel?) -> Void){
        let docRefTracking = db.collection("tracking").document("CountInAppPurchases").collection(currentDateMonthFormate).document(currentDateMonthAndDayFormate)
        
        docRefTracking.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
              print("Error fetching document: \(error!)")
              return
            }
            guard let data = (document.data() as? [String: Int]) else {
              print("Document data was empty.")
              return
            }
            let resultData: TrackingDataModel? = data.castToObject()
            
            print("Current data: \(resultData)")
            completionHandler(resultData)
          }
    }
    
    func getMonthlyTrackingPurchasesData(completionHandler: @escaping (TrackingDataModel?) -> Void){
        let docRefTracking = db.collection("tracking").document("CountInAppPurchases").collection(currentDateMonthFormate).document("purchaseSummary")
        
        docRefTracking.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
              print("Error fetching document: \(error!)")
              return
            }
            guard let data = (document.data() as? [String: Int]) else {
              print("Document data was empty.")
              return
            }
            let resultData: TrackingDataModel? = data.castToObject()
            
            print("Current data: \(resultData)")
            completionHandler(resultData)
          }
    }
    
    func saveReceiverFCM(code: String){
        db.collection("ReceiverFCMs").document(code).setData(["isActive": true], merge: true) { error in
            if error == nil { }
            
            }
        
    }
    
    // The device tokens will be saved in
    // collection: "tracking" -> document: "internalApp" -> field: "deviceTokens" (this is an Array)
    // Grab the array from this path and send the remote notification individually to these device tokens
    
    // Have a look at the internal users device token and save it locally, whenever the device token changes update it in the database and remove the old one and update with new one
    
}


extension Dictionary {
    func castToObject<T: Decodable>() -> T? {
        let json = try? JSONSerialization.data(withJSONObject: self)
        return json == nil ? nil : try? JSONDecoder().decode(T.self, from: json!)
    }
}

struct TrackingDataModel: Codable {
    var threeMonthlySubscription: Int
   // var estimatedRevenue: Int
    var monthlySubscription: Int
    var weeklySubscription: Int
    
    enum CodingKeys: String, CodingKey {
        case threeMonthlySubscription = "3monthsSubscription"
        case monthlySubscription, weeklySubscription
    }
}
