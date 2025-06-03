//
//  RCValues.swift
//  Scratch Adventure
//
//  Created by Maurice Wirth on 09.06.22.
//

import Foundation
import FirebaseCore
import FirebaseRemoteConfig


// Remote Config Settings for A/B Testing
enum RCKey: String {
    case custom_review_alert_enabled_2_8_0
    case temporarily_home_menu_layout_active
}


class RCValues {
    
    static let sharedInstance = RCValues()
    
    var loadingDoneCallback: (() -> Void)?
    var fetchComplete = false
    
    private init() {
        loadDefaultValues()
        fetchCloudValues()
    }
    
    
    func loadDefaultValues() {
        
        let appDefaults: [String: Any?] = [
            RCKey.custom_review_alert_enabled_2_8_0.rawValue: false,
            RCKey.temporarily_home_menu_layout_active.rawValue: true
        ]
        
        RemoteConfig.remoteConfig().setDefaults(appDefaults as? [String: NSObject])
        
    }
    
    
    func activateDebugMode() {
        
        let settings = RemoteConfigSettings()
        // WARNING: Don't actually do this in production!
        settings.minimumFetchInterval = 0
        RemoteConfig.remoteConfig().configSettings = settings
        
    }
    
    
    func fetchCloudValues() {
        
        let fetchDuration: TimeInterval = 3 * 3600
        
        // 1
        //activateDebugMode()
        
        // 2
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: fetchDuration) { [weak self] _, error in
            
            if let error = error {
                print("Uh-oh. Got an error fetching remote values \(error)")
                // In a real app, you would probably want to call the loading
                // done callback anyway, and just proceed with the default values.
                // I won't do that here, so we can call attention
                // to the fact that Remote Config isn't loading.
                return
            }
            
            // 3
            RemoteConfig.remoteConfig().activate { _, _ in
                print("Retrieved values from the cloud!")
                
                let custom_review_alert_enabled_2_8_0 = RemoteConfig.remoteConfig()
                  .configValue(forKey: "custom_review_alert_enabled_2_8_0")
                  .boolValue ?? false
                print("custom_review_alert_enabled_2_8_0 \(custom_review_alert_enabled_2_8_0)")
                
                
                let temporarily_home_menu_layout_active = RemoteConfig.remoteConfig()
                  .configValue(forKey: "temporarily_home_menu_layout_active")
                  .boolValue ?? true
                print("temporarily_home_menu_layout_active \(temporarily_home_menu_layout_active)")
                
                
                
                self?.fetchComplete = true
                DispatchQueue.main.async {
                    self?.loadingDoneCallback?()
                }
                
            }
            
        }
        
    }
    
    
    func bool(forKey key: RCKey) -> Bool {
        return RemoteConfig.remoteConfig()[key.rawValue].boolValue
    }
    
    func int(forKey key: RCKey) -> Int {
        return RemoteConfig.remoteConfig()[key.rawValue].numberValue.intValue ?? 0
    }
    
}
