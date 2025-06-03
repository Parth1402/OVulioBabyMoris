//
//  OvulationCalendarDataManager.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-11-21.
//

import Foundation

struct OvulationCalendar {
    
    var lastPeriodDate: Date
    var cycleLength: Int
    var periodLength: Int
    
    private func datesBetween(start: Date, end: Date) -> [Date] {
        var dates: [Date] = []
        
        var currentDate = start
        
        while currentDate <= end {
            dates.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return dates
    }
    
    func calculateFor(months: Int) -> [(month: Date, period: [Date], ovulation: Date, fertileWindow: [Date], highFertilityDays: [Date])] {
        
        var results = [(month: Date, period: [Date], ovulation: Date, fertileWindow: [Date], highFertilityDays: [Date])]()
        
        for monthIndex in 0..<months {
            
            if let monthDate = Calendar.current.date(byAdding: .month, value: monthIndex, to: lastPeriodDate) {
                
                let startOfNextMonth = Calendar.current.startOfMonth(for: monthDate)
                let periodDate = Calendar.current.date(byAdding: .day, value: cycleLength * monthIndex, to: lastPeriodDate)!
                
                let ovulationDate = Calendar.current.date(byAdding: .day, value: cycleLength - 14, to: periodDate)!
                
                let fertileWindowStart = Calendar.current.date(byAdding: .day, value: cycleLength - 19, to: periodDate)!
                let fertileWindowEnd = Calendar.current.date(byAdding: .day, value: cycleLength - 12, to: periodDate)!
                let fertileWindowDays = datesBetween(start: fertileWindowStart, end: fertileWindowEnd)
                
                let periodStart = periodDate
                let periodEnd = Calendar.current.date(byAdding: .day, value: periodLength - 1, to: periodStart)!
                let periodDays = datesBetween(start: periodStart, end: periodEnd)
                
                let highFertilityStart = Calendar.current.date(byAdding: .day, value: cycleLength - 14 - 2, to: periodDate)!
                let highFertilityDays = (0..<3).compactMap {
                    Calendar.current.date(byAdding: .day, value: $0, to: highFertilityStart)
                }
                
                results.append((month: monthDate, period: periodDays, ovulation: ovulationDate, fertileWindow: fertileWindowDays, highFertilityDays: highFertilityDays))
                
            }
        }
        return results
    }
    
    
    func startOfCycle(for date: Date) -> Date {
        
        // Find the difference in days between the last period date and the given date
        let daysDifference = Calendar.current.dateComponents([.day], from: lastPeriodDate, to: date).day ?? 0
        // Calculate the number of full cycles that have passed
        let fullCycles = daysDifference / cycleLength
        // Calculate the start date of the current cycle
        return Calendar.current.date(byAdding: .day, value: fullCycles * cycleLength, to: lastPeriodDate)!
    }
    
    
    func ovulationDate(forDate date: Date) -> Date {
        let startOfCycle = Calendar.current.startOfCycle(for: date, cycleLength: cycleLength)
        return Calendar.current.date(byAdding: .day, value: cycleLength - 14, to: startOfCycle)!
    }
    
}

class OvulationCalendarDataManager {
    
    static let shared = OvulationCalendarDataManager()
    
    func daysInMonth(year: Int, month: Int) -> Int? {
        var calendar = Calendar.current
        calendar.firstWeekday = 2  // Sets the first day of the week to Monday, if desired
        guard let date = calendar.date(from: DateComponents(year: year, month: month)) else {
            return nil
        }
        let range = calendar.range(of: .day, in: .month, for: date)
        return range?.count
    }
    
    func threeDaysBefore(date: Date) -> [Date] {
        let calendar = Calendar.current
        let dayBefore = calendar.date(byAdding: .day, value: -1, to: date)!
        let twoDaysBefore = calendar.date(byAdding: .day, value: -2, to: date)!
        let threeDaysBefore = calendar.date(byAdding: .day, value: -3, to: date)!
        return [threeDaysBefore, twoDaysBefore, dayBefore].sorted(by: { $0 < $1 })
    }
    
    
    func dateAndDayAfter(date: Date) -> [Date] {
        let calendar = Calendar.current
        guard let dayAfter = calendar.date(byAdding: .day, value: 1, to: date) else {
            // If for some reason the date cannot be computed, return just the original date
            return [date]
        }
        return [date, dayAfter]
    }
    
    // This function calculates the start date of the previous period.
    // It takes the start date of the current period and the cycle length as parameters.
    func calculatePreviousPeriodStartDate(currentStartDate: Date, cycleLength: Int) -> Date? {
        // Subtract the cycle length from the current start date to get the previous period start date
        return Calendar.current.date(byAdding: .day, value: -cycleLength, to: currentStartDate)
    }
    
    var allOvulationData = [(month: Date, period: [Date], ovulation: Date, fertileWindow: [Date], highFertilityDays: [Date], girlDays: [Date], boyDays: [Date])]()
    private func getOvulationData() {
        allOvulationData.removeAll()
        // ____________________________
        //        let formatter = DateFormatter()
        //        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        //        var lastPeriodStart = formatter.date(from: "2023-09-01 18:30:00 +0000")!  // Enter Date from User Profile here
        var lastPeriodStart = (ProfileDataManager.shared.lastPeriodDate ?? Date())
        
        // Do not start calculation with last period start, first calculate the start of the period before the last period, so 2 periods before (for math purposes)
        //        let cycleLength = 28  // assumed cycle length in days // range will be 20 - 40
        var cycleLength = (ProfileDataManager.shared.cycleLength ?? 28)  // assumed cycle length in days // range will be 20 - 40
        if !isUserProMember() {
            lastPeriodStart = ProfileDataManager.shared.demoLastPeriodDate ?? Date()
            cycleLength = ProfileDataManager.shared.demoCycleLength ?? 28
        }
        if let previousStartDate = calculatePreviousPeriodStartDate(currentStartDate: lastPeriodStart, cycleLength: cycleLength) {
            ////print("Start of the previous period: \(formatter.string(from: previousStartDate))")
            lastPeriodStart = previousStartDate
        } else {
            ////print("Error calculating the previous period start date.")
        }
        
        
        let calendar = OvulationCalendar(lastPeriodDate: lastPeriodStart, cycleLength: cycleLength, periodLength: 5)
        let monthsToCalculate = 24  // for example, calculate the next 6 months
        
        let ovulationDataForMonths = calendar.calculateFor(months: monthsToCalculate)
        
        
        for monthData in ovulationDataForMonths {
            //print("Month: \(monthData.month)")
            //print("Next Period: \(monthData.period)")
            //print("Ovulation: \(monthData.ovulation)")
            //print("Fertile Window: \(monthData.fertileWindow)")
            //print("High Fertility Days: \(monthData.highFertilityDays)")
            
            
            /* One of the most known theories is the Shettles Method, which suggests that to conceive a boy, you should have intercourse as close as possible to ovulation — ideally within 12 hours of ovulation. To conceive a girl, the Shettles Method suggests intercourse two to four days before ovulation. */
            
            // Make gender predictions based on the given date's relation to the ovulation day
            let girlDates = threeDaysBefore(date: monthData.ovulation)
            //print("Girl Days: \(girlDates)")
            
            let boysDates = dateAndDayAfter(date: monthData.ovulation)
            //print("Boy Days: \(boysDates)")
            
            //print("-----------")
            
            allOvulationData.append((month: monthData.month, period: monthData.period, ovulation: monthData.ovulation, fertileWindow: monthData.fertileWindow, highFertilityDays: monthData.highFertilityDays, girlDays: girlDates, boyDays: boysDates))
        }
    }
    
    func getOvulationDataForMonthDate(monthDate: Date) -> (Month: Date, NextPeriod: [Date], Ovulation: [Date], FertileWindow: [Date], HighFertilityDays: [Date], GirlDays: [Date], BoyDays: [Date]) {
        
        //        if allOvulationData.isEmpty {
        self.getOvulationData()
        //        }
        func filterDatesForSelectedDate(targetDate: Date) -> (Month: Date, NextPeriod: [Date], Ovulation: [Date], FertileWindow: [Date], HighFertilityDays: [Date], GirlDays: [Date], BoyDays: [Date]) {
            var result: (Month: Date, NextPeriod: [Date], Ovulation: [Date], FertileWindow: [Date], HighFertilityDays: [Date], GirlDays: [Date], BoyDays: [Date]) = (Date(), [], [], [], [], [], [])
            
            result.Month = targetDate
            allOvulationData.forEach { data in
                result.NextPeriod += data.period.filter { $0.yearNumber == targetDate.yearNumber && $0.monthNumber == targetDate.monthNumber }
                result.FertileWindow += data.fertileWindow.filter { $0.yearNumber == targetDate.yearNumber && $0.monthNumber == targetDate.monthNumber }
                result.HighFertilityDays += data.highFertilityDays.filter { $0.yearNumber == targetDate.yearNumber && $0.monthNumber == targetDate.monthNumber }
                result.GirlDays += data.girlDays.filter { $0.yearNumber == targetDate.yearNumber && $0.monthNumber == targetDate.monthNumber }
                result.BoyDays += data.boyDays.filter { $0.yearNumber == targetDate.yearNumber && $0.monthNumber == targetDate.monthNumber }
                
                if data.ovulation.yearNumber == targetDate.yearNumber && data.ovulation.monthNumber == targetDate.monthNumber {
                    result.Ovulation.append(data.ovulation)
                }
            }
            
            //print("Month: \(result.Month)")
            //print("Next Period: \(result.NextPeriod)")
            ////print("Ovulation: \(result.Ovulation)")
            //print("Fertile Window: \(result.FertileWindow)")
            //print("High Fertility Days: \(result.HighFertilityDays)")
            //print("Girl Days: \(result.GirlDays)")
            //print("Boy Days: \(result.BoyDays)")
            
            return result
        }
        
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        //
        //        let dateArray = dateFormatter.date(from: "2023-12-07 18:30:00 +0000")!
        //        return filterDatesForSelectedDate(targetDate: dateArray)
        return filterDatesForSelectedDate(targetDate: monthDate)
    }
    
}

// Date extension to help with the calculations
extension Calendar {
    
    func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components)!
    }
    
    func startOfCycle(for date: Date, cycleLength: Int) -> Date {
        var components = dateComponents([.year, .month, .day], from: date)
        components.day = ((components.day! - 1) / cycleLength) * cycleLength + 1
        return self.date(from: components)!
    }
    
}



extension Date {
    var dayNumber: Int {
        let calendar = Calendar.current
        //        let components = calendar.dateComponents(in: TimeZone(identifier: "UTC")!, from: self)
        let components = calendar.dateComponents([.day], from: self)
        return components.day ?? 0
    }
    
    var monthNumber: Int {
        let calendar = Calendar.current
        //        let components = calendar.dateComponents(in: TimeZone(identifier: "UTC")!, from: self)
        let components = calendar.dateComponents([.month], from: self)
        return components.month ?? 0
    }
    
    var monthString: String {
        let Months = ["January","Febrary","March","April","May","June","July","August","September","October","November","December"]
        return Months[self.monthNumber - 1]
    }
    
    var yearNumber: Int {
        let calendar = Calendar.current
        //        let components = calendar.dateComponents(in: TimeZone(identifier: "UTC")!, from: self)
        let components = calendar.dateComponents([.year], from: self)
        return components.year ?? 0
    }
    
    var numberOfDaysInMonth: Int {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: self)
        
        return range?.count ?? 0
    }
}
