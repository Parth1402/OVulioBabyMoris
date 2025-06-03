//
//  ProfileDataManager.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-17.
//

import Foundation

enum GenderOption: Int, Codable {
    case boy = 1
    case girl = 2
    case doesntMatter = 3
}

class ProfileDataManager {
    
    static let shared = ProfileDataManager()
    
    private let userDefaults = UserDefaults.standard
    
    private let motherNameKey = "MotherName"
    private let fatherNameKey = "FatherName"
    private let selectedGenderKey = "SelectedGender"
    private let lastPeriodDateKey = "LastPeriodDate"
    private let cycleLengthKey = "CycleLength"
    private let motherBirthdateKey = "MotherBirthdate"
    private let fatherBirthdateKey = "FatherBirthdate"
    private let selectedYearForLunarCalendarKey = "SelectedYearForLunarCalendar"
    private let hasCompletedOnboardingKey = "hasCompletedOnboarding"
    private let hasSeenPodcastArticleKey = "hasSeenPodcastArticle"
    
    var hasSeenPodcastArticle: Bool {
        get {
            return userDefaults.value(forKey: hasSeenPodcastArticleKey) as? Bool ?? false
        }
        set {
            userDefaults.set(newValue, forKey: hasSeenPodcastArticleKey)
        }
    }
    
    func updateHasSeenPodcastArticle(_ name: Bool) {
        hasSeenPodcastArticle = name
    }
    
    var hasCompletedOnboarding: Bool {
        get {
            return userDefaults.value(forKey: hasCompletedOnboardingKey) as? Bool ?? false
        }
        set {
            userDefaults.set(newValue, forKey: hasCompletedOnboardingKey)
        }
    }
    
    func updateHasCompletedOnboarding(_ name: Bool) {
        hasCompletedOnboarding = name
    }
    
    var motherName: String? {
        get {
            return userDefaults.value(forKey: motherNameKey) as? String
        }
        set {
            userDefaults.set(newValue, forKey: motherNameKey)
        }
    }
    
    func updateMotherName(_ name: String) {
        motherName = name
    }
    
    var fatherName: String? {
        get {
            return userDefaults.value(forKey: fatherNameKey) as? String
        }
        set {
            userDefaults.set(newValue, forKey: fatherNameKey)
        }
    }
    
    func updateFatherName(_ name: String) {
        fatherName = name
    }
    
    var selectedGender: GenderOption {
        get {
            if let savedOption = userDefaults.value(forKey: selectedGenderKey) as? Int,
               let option = GenderOption(rawValue: savedOption) {
                return option
            }
            return .doesntMatter
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: selectedGenderKey)
        }
    }
    
    func updateGender(to option: GenderOption) {
        selectedGender = option
    }
    
    var demoLastPeriodDate: Date? {
        get {
            return userDefaults.object(forKey: "demoLastPeriodDate") as? Date
        }
        set {
            userDefaults.set(newValue, forKey: "demoLastPeriodDate")
        }
    }
    
    var lastPeriodDate: Date? {
        get {
            return userDefaults.object(forKey: lastPeriodDateKey) as? Date
        }
        set {
            if let date = newValue {
                demoLastPeriodDate = date.addDays(-(Int.random(in: 10...28)))
            }
            userDefaults.set(newValue, forKey: lastPeriodDateKey)
        }
    }
    
    func updateLastPeriodDate(_ date: Date?) {
        lastPeriodDate = date
    }
    
    var demoCycleLength: Int? {
        get {
            return userDefaults.value(forKey: "demoCycleLength") as? Int
        }
        set {
            userDefaults.set(newValue, forKey: "demoCycleLength")
        }
    }
    
    var cycleLength: Int? {
        get {
            return userDefaults.value(forKey: cycleLengthKey) as? Int
        }
        set {
            demoCycleLength = Int.random(in: 25...35)
            userDefaults.set(newValue, forKey: cycleLengthKey)
        }
    }
    
    func updateCycleLength(_ length: Int) {
        cycleLength = length
    }
    
    var demoMotherBirthdate: Date? {
        get {
            return userDefaults.object(forKey: "demoMotherBirthdate") as? Date
        }
        set {
            userDefaults.set(newValue, forKey: "demoMotherBirthdate")
        }
    }
    
    var motherBirthdate: Date? {
        get {
            return userDefaults.object(forKey: motherBirthdateKey) as? Date
        }
        set {
            if let date = newValue {
                demoMotherBirthdate = date.addMonth(-(Int.random(in: 2...4) * 12))
            }
            userDefaults.set(newValue, forKey: motherBirthdateKey)
        }
    }
    
    func updateMotherBirthdate(_ date: Date?) {
        motherBirthdate = date
    }
    
    
    var fatherBirthdate: Date? {
        get {
            return userDefaults.object(forKey: fatherBirthdateKey) as? Date
        }
        set {
            userDefaults.set(newValue, forKey: fatherBirthdateKey)
        }
    }
    
    func updateFatherBirthdate(_ date: Date?) {
        fatherBirthdate = date
    }
    
    var selectedYearForLunarCalendar: Int {
        get {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: Date())
            let year = components.year ?? Date().yearNumber
            return (userDefaults.value(forKey: selectedYearForLunarCalendarKey) as? Int) ?? year
        }
        set {
            userDefaults.set(newValue, forKey: selectedYearForLunarCalendarKey)
        }
    }
    
    func updateSelectedYearForLunarCalendar(_ year: Int) {
        selectedYearForLunarCalendar = year
    }
}
