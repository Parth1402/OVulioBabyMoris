import Foundation

class LunarCalendarDataManager {
    
    static let shared = LunarCalendarDataManager()
    
    private let userDefaults = UserDefaults.standard
    
    private let lastShownScreenIndexKey = "lastShownCalendarScreenIndexKey"
    private let freeUserScreenOpeneingCounterKey = "freeUserScreenOpeneingCounterKey"
    
    var lastShownScreenIndex: Int {
        get {
            return userDefaults.value(forKey: lastShownScreenIndexKey) as? Int ?? 0
        }
        set {
            userDefaults.set(newValue, forKey: lastShownScreenIndexKey)
        }
    }
    
    func updateLastShownScreenIndex(_ lastShownScreenIndex: Int) {
        self.lastShownScreenIndex = lastShownScreenIndex
    }
    
    var freeUserScreenOpeneingCounter: Int {
        get {
            return userDefaults.value(forKey: freeUserScreenOpeneingCounterKey) as? Int ?? 0
        }
        set {
            userDefaults.set(newValue, forKey: freeUserScreenOpeneingCounterKey)
        }
    }
    
    func updateFreeUserScreenOpeneingCounter(_ freeUserScreenOpeneingCounter: Int) {
        self.freeUserScreenOpeneingCounter = freeUserScreenOpeneingCounter
    }
}

func chineseNewYearDate(gregorianYear: Int) -> Date? {
    let gregorianCalendar = Calendar(identifier: .gregorian)
    
    // Find the first of January for the given year.
    var components = DateComponents()
    components.year = gregorianYear
    components.month = 1
    components.day = 1
    
    guard let januaryFirst = gregorianCalendar.date(from: components) else {
        return nil
    }
    
    // Convert this date to the Chinese calendar.
    let chineseCalendar = Calendar(identifier: .chinese)
    let chineseDateComponents = chineseCalendar.dateComponents([.year, .month, .day], from: januaryFirst)
    
    // Find the first day (New Year) of this Chinese year.
    var newYearComponents = DateComponents()
    newYearComponents.year = chineseDateComponents.year
    newYearComponents.month = 1
    newYearComponents.day = 1
    
    return chineseCalendar.date(from: newYearComponents)
    
}


func lunarAge(forDate targetDate: Date, birthDate: Date) -> Int {
    
    let gregorianCalendar = Calendar.current
    let chineseCalendar = Calendar(identifier: .chinese)
    
    let birthYear = gregorianCalendar.component(.year, from: birthDate)
    
    // Determine the date of Chinese New Year in the birth year
    let chineseNewYearDate = chineseNewYearDate(gregorianYear: birthYear+1)! //chineseCalendar.date(from: DateComponents(year: birthYear - 2697, month: 1, day: 1))!
//    print("Chinese New Year \(chineseNewYearDate)")
    
    // Calculate age difference in years and months
    let components = gregorianCalendar.dateComponents([.year, .month], from: birthDate, to: targetDate)
    var ageInMonths = components.year! * 12 + components.month!
    
    // Adjust age based on lunar calculations
    if birthDate > gregorianCalendar.date(from: DateComponents(year: birthYear, month: 2, day: 22))! {
        // Birthday after February 22: Age + 9 months
//        print("Birthday after February 22: Age + 9 months")
        ageInMonths += 9
    } else if birthDate < chineseNewYearDate {
        // Birthday before Chinese New Year: Age + 21 months
//        print("Birthday before Chinese New Year: Age + 21 months")
        ageInMonths += 21
    } else {
        // Birthday between Chinese New Year and February 22: Age + 9 months
//        print("Birthday between Chinese New Year and February 22: Age + 9 months")
        ageInMonths += 9
    }
    
    return ageInMonths / 12
}


enum GenderPrediction: UInt {
    case boy
    case girl
    case unknown
}

func genderPredictions(forYear year: Int, birthDay: Int, birthMonth: Int, birthYear: Int) -> [LunarCalendarContentModel] {
    
    // Simplified Chinese Gender Prediction Chart (for illustrative purposes)
    let chart: [Int: [Int: GenderPrediction]] = [
        18: [1: .girl, 2: .boy, 3: .girl, 4: .boy, 5: .boy, 6: .boy, 7: .boy, 8: .boy, 9: .boy, 10: .boy, 11: .boy, 12: .boy],
        19: [1: .boy, 2: .girl, 3: .boy, 4: .girl, 5: .girl, 6: .boy, 7: .boy, 8: .boy, 9: .boy, 10: .boy, 11: .girl, 12: .girl],
        20: [1: .girl, 2: .boy, 3: .girl, 4: .boy, 5: .boy, 6: .boy, 7: .boy, 8: .boy, 9: .boy, 10: .girl, 11: .boy, 12: .boy],
        21: [1: .boy, 2: .girl, 3: .girl, 4: .girl, 5: .girl, 6: .girl, 7: .girl, 8: .girl, 9: .girl, 10: .girl, 11: .girl, 12: .girl],
        22: [1: .girl, 2: .boy, 3: .boy, 4: .girl, 5: .boy, 6: .girl, 7: .girl, 8: .boy, 9: .girl, 10: .girl, 11: .girl, 12: .girl],
        23: [1: .boy, 2: .boy, 3: .girl, 4: .boy, 5: .boy, 6: .girl, 7: .boy, 8: .girl, 9: .boy, 10: .boy, 11: .boy, 12: .girl],
        24: [1: .boy, 2: .girl, 3: .boy, 4: .boy, 5: .girl, 6: .boy, 7: .boy, 8: .girl, 9: .girl, 10: .girl, 11: .girl, 12: .girl],
        25: [1: .girl, 2: .boy, 3: .boy, 4: .girl, 5: .girl, 6: .boy, 7: .girl, 8: .boy, 9: .boy, 10: .boy, 11: .boy, 12: .boy],
        26: [1: .boy, 2: .girl, 3: .boy, 4: .girl, 5: .girl, 6: .boy, 7: .girl, 8: .boy, 9: .girl, 10: .girl, 11: .girl, 12: .girl],
        27: [1: .girl, 2: .boy, 3: .girl, 4: .boy, 5: .girl, 6: .girl, 7: .boy, 8: .boy, 9: .boy, 10: .boy, 11: .girl, 12: .boy],
        28: [1: .boy, 2: .girl, 3: .boy, 4: .girl, 5: .girl, 6: .girl, 7: .boy, 8: .boy, 9: .boy, 10: .boy, 11: .girl, 12: .girl],
        29: [1: .girl, 2: .boy, 3: .girl, 4: .girl, 5: .boy, 6: .boy, 7: .boy, 8: .boy, 9: .boy, 10: .girl, 11: .girl, 12: .girl],
        30: [1: .boy, 2: .girl, 3: .girl, 4: .girl, 5: .girl, 6: .girl, 7: .girl, 8: .girl, 9: .girl, 10: .girl, 11: .boy, 12: .boy],
        31: [1: .boy, 2: .girl, 3: .boy, 4: .girl, 5: .girl, 6: .girl, 7: .girl, 8: .girl, 9: .girl, 10: .girl, 11: .girl, 12: .boy],
        32: [1: .boy, 2: .girl, 3: .boy, 4: .girl, 5: .girl, 6: .girl, 7: .girl, 8: .girl, 9: .girl, 10: .girl, 11: .girl, 12: .boy],
        33: [1: .girl, 2: .boy, 3: .girl, 4: .boy, 5: .girl, 6: .girl, 7: .girl, 8: .boy, 9: .girl, 10: .girl, 11: .girl, 12: .boy],
        34: [1: .boy, 2: .girl, 3: .boy, 4: .girl, 5: .girl, 6: .girl, 7: .girl, 8: .girl, 9: .girl, 10: .girl, 11: .boy, 12: .boy],
        35: [1: .boy, 2: .boy, 3: .girl, 4: .boy, 5: .girl, 6: .girl, 7: .girl, 8: .boy, 9: .girl, 10: .girl, 11: .boy, 12: .boy],
        36: [1: .girl, 2: .boy, 3: .boy, 4: .girl, 5: .boy, 6: .girl, 7: .girl, 8: .girl, 9: .boy, 10: .boy, 11: .boy, 12: .boy],
        37: [1: .boy, 2: .girl, 3: .boy, 4: .boy, 5: .girl, 6: .boy, 7: .girl, 8: .boy, 9: .girl, 10: .boy, 11: .girl, 12: .boy],
        38: [1: .girl, 2: .boy, 3: .girl, 4: .boy, 5: .boy, 6: .girl, 7: .boy, 8: .girl, 9: .boy, 10: .girl, 11: .boy, 12: .girl],
        39: [1: .boy, 2: .girl, 3: .boy, 4: .boy, 5: .boy, 6: .girl, 7: .girl, 8: .boy, 9: .girl, 10: .boy, 11: .girl, 12: .girl],
        40: [1: .girl, 2: .boy, 3: .girl, 4: .boy, 5: .girl, 6: .boy, 7: .boy, 8: .girl, 9: .boy, 10: .girl, 11: .boy, 12: .girl],
        41: [1: .boy, 2: .girl, 3: .boy, 4: .girl, 5: .boy, 6: .girl, 7: .boy, 8: .boy, 9: .girl, 10: .boy, 11: .girl, 12: .boy],
        42: [1: .girl, 2: .boy, 3: .girl, 4: .boy, 5: .girl, 6: .boy, 7: .girl, 8: .boy, 9: .boy, 10: .girl, 11: .boy, 12: .girl],
        43: [1: .boy, 2: .girl, 3: .boy, 4: .girl, 5: .boy, 6: .girl, 7: .boy, 8: .girl, 9: .boy, 10: .boy, 11: .boy, 12: .boy],
        44: [1: .boy, 2: .boy, 3: .girl, 4: .boy, 5: .boy, 6: .boy, 7: .girl, 8: .boy, 9: .girl, 10: .boy, 11: .girl, 12: .girl],
        45: [1: .girl, 2: .boy, 3: .boy, 4: .girl, 5: .girl, 6: .girl, 7: .boy, 8: .girl, 9: .boy, 10: .girl, 11: .boy, 12: .boy],
    ]
    
    let birthDate = DateComponents(calendar: .current, year: birthYear, month: birthMonth, day: birthDay).date!
    var predictions: [LunarCalendarContentModel] = []
    let monthsArray = ["January","Febrary","March","April","May","June","July","August","September","October","November","December"]
    for month in 1...12 {
        let targetDate = DateComponents(calendar: .current, year: year, month: month).date!
        let lunarAge = lunarAge(forDate: targetDate, birthDate: birthDate)
        
        if let gender = chart[lunarAge]?[month] {
            predictions.append(LunarCalendarContentModel(gender: gender, month: monthsArray[month - 1]))
        } else {
            predictions.append(LunarCalendarContentModel(gender: .unknown, month: monthsArray[month - 1]))
        }
    }
    
    return predictions
}
