//
//  OvulationCalendarVC.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-11-11.
//

import UIKit

class OvulationCalendarVC: UIViewController, MonthScrollPickerDelegate, DateScrollPickerDelegate, OvulationCircularCalendarDelegate {
    
    @IBOutlet weak var probabilityViewHeightConstarint: NSLayoutConstraint!
    @IBOutlet weak var girlImageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var boyImageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var circularCalendarTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var circularCalendarLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var monthScrollableTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var monthScrollableLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewLeadingContraint: NSLayoutConstraint!
    @IBOutlet weak var monthCLVHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var demoStaticLabel: UILabel!
    @IBOutlet weak var dataStaticLabel: UILabel!
    @IBOutlet weak var girlView: UIView!
    @IBOutlet weak var girlStaticLabel: UILabel!
    @IBOutlet weak var girlProbabilityStaticLabel: UILabel!
    @IBOutlet weak var boyView: UIView!
    @IBOutlet weak var boyProbabilityStaticLabel: UILabel!
    @IBOutlet weak var boyStaticLabel: UILabel!
    @IBOutlet weak var scrollableMonthView: MonthScrollPicker!
    @IBOutlet weak var ovulationCircularCalendarContainer: UIView!
    @IBOutlet weak var demoDataContainerView: UIView!
    @IBOutlet weak var scrollableDateView: DateScrollPicker!
    var customNavBarView: CustomNavigationBar?
    var monthItems = [DateScrollItem]()
    var dateItems = [DateScrollItem]()
    let ovulationCircularCalendar = OvulationCircularCalendarView()
    var currentSelectedDate = Int()
    var currentSelectedMonth = Int()
    var isFromSuccessPurchase = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if DeviceSize.isiPadDevice {
            demoStaticLabel.font = .systemFont(ofSize: 10.pulse2Font())
            dataStaticLabel.font = .systemFont(ofSize: 10.pulse2Font())
            boyProbabilityStaticLabel.font = .systemFont(ofSize: 16.pulseWithFont(withInt: 2))
            girlProbabilityStaticLabel.font = .systemFont(ofSize: 16.pulseWithFont(withInt: 2))
            boyStaticLabel.font = .boldSystemFont(ofSize: 20.pulse2Font())
            girlStaticLabel.font = .boldSystemFont(ofSize: 20.pulse2Font())
            
            
            probabilityViewHeightConstarint.constant = (ScreenSize.width * 0.14)
            boyImageLeadingConstraint.constant = (ScreenSize.width * 0.05)
            girlImageLeadingConstraint.constant = (ScreenSize.width * 0.05)
            circularCalendarLeadingConstraint.constant = (ScreenSize.width * 0.1)
            circularCalendarTrailingConstraint.constant = (ScreenSize.width * 0.1)
            monthScrollableLeadingConstraint.constant = (ScreenSize.width * 0.1)
            monthScrollableTrailingConstraint.constant = (ScreenSize.width * 0.1)
            scrollViewLeadingContraint.constant = (ScreenSize.width * 0.1)
            scrollViewTrailingConstraint.constant = -(ScreenSize.width * 0.1)
            monthCLVHeightConstraint.constant = ((ScreenSize.height * 0.060483) < 70) ? 70 : (ScreenSize.height * 0.060483)
        }
        demoStaticLabel.text = "OvulationCalendarVC.demoData.demo.headline.text"~
        dataStaticLabel.text = "OvulationCalendarVC.demoData.data.headline.text"~
        girlStaticLabel.text = "OvulationCalendarVC.probability.girl.headline.text"~
        girlProbabilityStaticLabel.text = "OvulationCalendarVC.probability.headline.text"~
        boyProbabilityStaticLabel.text = "OvulationCalendarVC.probability.headline.text"~
        boyStaticLabel.text = "OvulationCalendarVC.probability.boy.headline.text"~
        
        self.monthItems.removeAll()
        self.ovulationMonthData.removeAll()
        self.dateItems.removeAll()
        currentSelectedDate = Int()
        currentSelectedMonth = Int()
        setUpNavigationBar()
        setupUI()
        if isUserProMember() {
            self.demoDataContainerView.isHidden = true
        }
        if isFromSuccessPurchase {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.scrollableMonthView.selectToday()
                self.scrollableDateView.selectToday()
            }
            isFromSuccessPurchase = false
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isUserProMember() {
            self.demoDataContainerView.isHidden = true
        }
    }
    
    @IBAction func demoDataButtonTapped(_ sender: Any) {
        DispatchQueue.main.async {
            // Success
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            let vc = DemoDataAlertVC()
            vc.didPurchaseSuccessfully = {
                self.isFromSuccessPurchase = true
                self.viewDidLoad()
            }
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: false, completion: nil)
        }
        
    }
    
    @IBAction func guideButtonTapped(_ sender: Any) {
        
        // Success
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CalendarDesignationsVC") as! CalendarDesignationsVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
        
    }
    
    func setUpNavigationBar() {
        
        customNavBarView = CustomNavigationBar(
            leftImage: UIImage(named: "backButtonImg"),
            titleString: "OvulationCalendarVC.headlineLabel.text"~
        )
        
        if let customNavBarView = customNavBarView {
            customNavBarView.leftButtonTapped = {
                self.dismiss(animated: true)
            }
            self.view.addSubview(customNavBarView)
            customNavBarView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                customNavBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                customNavBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                customNavBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                customNavBarView.heightAnchor.constraint(equalToConstant: 44),
            ])
        }
        
    }
    
    func setupUI() {
        
        customizeScrollableMonth()
        customizeScrollable()
        boyView.applyRoundedBackgroundShadow(radius: 18, backgroundColor: UIColor(named: "white_plash") ?? UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), shadowColor: UIColor.black, shadowOpacity: 0.05, shadowRadius: 4)
        girlView.applyRoundedBackgroundShadow(radius: 20, backgroundColor: UIColor(named: "white_plash") ?? UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), shadowColor: UIColor.black, shadowOpacity: 0.05, shadowRadius: 4)
        
        ovulationCircularCalendar.delegate = self
        ovulationCircularCalendar.translatesAutoresizingMaskIntoConstraints = false
        self.ovulationCircularCalendarContainer.addSubview(ovulationCircularCalendar)
        NSLayoutConstraint.activate([
            ovulationCircularCalendar.leadingAnchor.constraint(equalTo: self.ovulationCircularCalendarContainer.leadingAnchor),
            ovulationCircularCalendar.topAnchor.constraint(equalTo: self.ovulationCircularCalendarContainer.topAnchor),
            ovulationCircularCalendar.trailingAnchor.constraint(equalTo: self.ovulationCircularCalendarContainer.trailingAnchor),
            ovulationCircularCalendar.bottomAnchor.constraint(equalTo: self.ovulationCircularCalendarContainer.bottomAnchor),
        ])
        
    }
    
    var numberOfMonthsToBeShown = 12
    func customizeScrollableMonth() {
        scrollableMonthView.delegate = self
        var monthStartDate = (ProfileDataManager.shared.lastPeriodDate ?? Date()).firstDateOfMonth()
        if !isUserProMember() {
            monthStartDate = (ProfileDataManager.shared.demoLastPeriodDate ?? Date()).firstDateOfMonth()
        }
        let monthEndDate = Date().firstDateOfMonth().addMonth(numberOfMonthsToBeShown + 1)!
        var currentDate = monthStartDate.addMonth(-1)!
        
        
        while currentDate < monthEndDate {
            //            if currentDate == currentDate.firstDateOfMonth() {
            //                dateItems.append(DateScrollItem(date: currentDate, selected: false, separator: true, genderProbability: .doesntMatter))
            //            }
            monthItems.append(DateScrollItem(date: currentDate, selected: false, separator: false, genderProbability: .doesntMatter, isUserInteractionEnabled: currentDate >= monthStartDate && currentDate < Date().firstDateOfMonth().addMonth(numberOfMonthsToBeShown)!))
            currentDate = currentDate.addMonth(1)!
        }
        scrollableMonthView.setupInitialDays(dateItems: monthItems)
    }
    
    var ovulationMonthData: [(Month: Date, NextPeriod: [Date], Ovulation: [Date], FertileWindow: [Date], HighFertilityDays: [Date], GirlDays: [Date], BoyDays: [Date])] = []
    func customizeScrollable() {
        
        scrollableDateView.delegate = self
        
        var monthStartDate = (ProfileDataManager.shared.lastPeriodDate ?? Date()).firstDateOfMonth()
        if !isUserProMember() {
            monthStartDate = (ProfileDataManager.shared.demoLastPeriodDate ?? Date()).firstDateOfMonth()
        }
        let monthEndDate = Date().firstDateOfMonth().addMonth(numberOfMonthsToBeShown + 1)!
        var currentDate = monthStartDate.addMonth(-1)!
        
        while currentDate < monthEndDate {
            
//            if currentDate == currentDate.firstDateOfMonth().addDays(1) {
            if currentDate == currentDate.firstDateOfMonth() {
                ovulationMonthData.append(OvulationCalendarDataManager.shared.getOvulationDataForMonthDate(monthDate: currentDate))
            }
            dateItems.append(DateScrollItem(date: currentDate, selected: false, separator: false, genderProbability: checkDateTypeForGender(for: currentDate, girlDays: ovulationMonthData.last?.GirlDays ?? [], boyDays: ovulationMonthData.last?.BoyDays ?? []), isUserInteractionEnabled: currentDate >= monthStartDate && currentDate < Date().firstDateOfMonth().addMonth(numberOfMonthsToBeShown)!))
            currentDate = currentDate.addDays(1)!
        }
        
        scrollableDateView.setupInitialDays(dateItems: dateItems)
        
    }
    
    func checkDateTypeForGender(for date: Date, girlDays: [Date], boyDays: [Date]) -> GenderOption {
        
        if girlDays.contains(date) {
            return .girl
        } else if boyDays.contains(date) {
            return .boy
        } else {
            return .doesntMatter
        }
        
    }
    
    func dateScrollPicker(_ dateScrollPicker: DateScrollPicker, didSelectDate dateIndexPath: IndexPath) {
        
        // Success
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        self.currentSelectedDate = dateIndexPath.row
        switch dateItems[dateIndexPath.row].genderProbability {
        case .boy:
            self.boyView.alpha = 1
            self.girlView.alpha = 0.6
            break
        case .girl:
            self.boyView.alpha = 0.6
            self.girlView.alpha = 1
            break
        case .doesntMatter:
            self.boyView.alpha = 0.6
            self.girlView.alpha = 0.6
            break
        }
        
        var ovulationSelectedDayDescription = "Not Found"
        var ovulationSelectedDayProbability: ProbabilityOfPregnancy!
        if isDateInArray(targetDate: dateItems[dateIndexPath.row].date, dateArray: ovulationMonthData[currentSelectedMonth].Ovulation){
            ovulationSelectedDayDescription = "OvulationCalendarVC.Ovulation.headlineLabel.text"~
            ovulationSelectedDayProbability = .highest
        } else if isDateInArray(targetDate: dateItems[dateIndexPath.row].date, dateArray: ovulationMonthData[currentSelectedMonth].HighFertilityDays){
            ovulationSelectedDayDescription = "OvulationCalendarVC.HighFertileday.headlineLabel.text"~
            ovulationSelectedDayProbability = .veryHigh
        } else if isDateInArray(targetDate: dateItems[dateIndexPath.row].date, dateArray: ovulationMonthData[currentSelectedMonth].FertileWindow){
            ovulationSelectedDayDescription = "OvulationCalendarVC.Fertileday.headlineLabel.text"~
            ovulationSelectedDayProbability = .high
        } else if isDateInArray(targetDate: dateItems[dateIndexPath.row].date, dateArray: ovulationMonthData[currentSelectedMonth].NextPeriod) {
            let dateArray = ovulationMonthData[((currentSelectedMonth - 1) <= 0) ? 0 : (currentSelectedMonth - 1)].NextPeriod + ovulationMonthData[currentSelectedMonth].NextPeriod + ovulationMonthData[currentSelectedMonth + 1].NextPeriod
            ovulationSelectedDayDescription = "\("OvulationCalendarVC.Periodday.headlineLabel.text"~) \(findPositionInDateRanges(from: dateArray, for: dateItems[dateIndexPath.row].date) ?? 0)"
            ovulationSelectedDayProbability = .low
        } else {
            let dateArray = ovulationMonthData[currentSelectedMonth].Ovulation + ovulationMonthData[((currentSelectedMonth + 1) >= ovulationMonthData.count) ? 0 : (currentSelectedMonth + 1)].Ovulation
            if let daysBeforeNext = daysBeforeNextOvulationDay(dates: dateArray, selectedDate: dateItems[dateIndexPath.row].date) {
                ovulationSelectedDayDescription = "\("OvulationCalendarVC.Daysbefore.headlineLabel.text"~) \(daysBeforeNext)"
            }
            ovulationSelectedDayProbability = .low
        }
        
        self.ovulationCircularCalendar.updateDetailsLabels(selectedDay: dateItems[dateIndexPath.row].date.dayNumber, monthName: dateItems[dateIndexPath.row].date.monthString, description: ovulationSelectedDayDescription, probabiility: ovulationSelectedDayProbability)
        
    }
    
    func dateScrollPicker(_ dateScrollPicker: DateScrollPicker, didMonthChange date: Date) {
        scrollableMonthView.selectDate(date.firstDateOfMonth())
    }
    
    func MonthScrollPicker(_ MonthScrollPicker: MonthScrollPicker, didSelectMonth dateIndexPath: IndexPath) {
        
        // Success
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        self.currentSelectedMonth = dateIndexPath.row
        let redRanges = findDateRanges(dates: ovulationMonthData[currentSelectedMonth].NextPeriod)
        let blueRanges = findDateRanges(dates: ovulationMonthData[currentSelectedMonth].FertileWindow)
        let darkBlueRanges = findDateRanges(dates: ovulationMonthData[currentSelectedMonth].Ovulation)
        self.ovulationCircularCalendar.refreshView(numberOfDays: ovulationMonthData[currentSelectedMonth].Month.numberOfDaysInMonth, redRanges: redRanges, blueRanges: blueRanges, darkBlueRanges: darkBlueRanges)
        
        var ovulationSelectedDayDescription = "Not Found"
        var ovulationSelectedDayProbability: ProbabilityOfPregnancy!
        if isDateInArray(targetDate: ovulationMonthData[currentSelectedMonth].Month.firstDateOfMonth(), dateArray: ovulationMonthData[currentSelectedMonth].Ovulation){
            ovulationSelectedDayDescription = "OvulationCalendarVC.Ovulation.headlineLabel.text"~
            ovulationSelectedDayProbability = .highest
        } else if isDateInArray(targetDate: ovulationMonthData[currentSelectedMonth].Month.firstDateOfMonth(), dateArray: ovulationMonthData[currentSelectedMonth].HighFertilityDays){
            ovulationSelectedDayDescription = "OvulationCalendarVC.HighFertileday.headlineLabel.text"~
            ovulationSelectedDayProbability = .veryHigh
        } else if isDateInArray(targetDate: ovulationMonthData[currentSelectedMonth].Month.firstDateOfMonth(), dateArray: ovulationMonthData[currentSelectedMonth].FertileWindow){
            ovulationSelectedDayDescription = "OvulationCalendarVC.Fertileday.headlineLabel.text"~
            ovulationSelectedDayProbability = .high
        } else if isDateInArray(targetDate: ovulationMonthData[currentSelectedMonth].Month.firstDateOfMonth(), dateArray: ovulationMonthData[currentSelectedMonth].NextPeriod) {
            let dateArray = ovulationMonthData[((currentSelectedMonth - 1) <= 0) ? 0 : (currentSelectedMonth - 1)].NextPeriod + ovulationMonthData[currentSelectedMonth].NextPeriod + ovulationMonthData[currentSelectedMonth + 1].NextPeriod
            ovulationSelectedDayDescription = "\("OvulationCalendarVC.Periodday.headlineLabel.text"~) \(findPositionInDateRanges(from: dateArray, for: ovulationMonthData[currentSelectedMonth].Month.firstDateOfMonth()) ?? 0)"
            ovulationSelectedDayProbability = .low
        } else {
            let dateArray = ovulationMonthData[currentSelectedMonth].Ovulation + ovulationMonthData[((currentSelectedMonth + 1) >= ovulationMonthData.count) ? 0 : (currentSelectedMonth + 1)].Ovulation
            if let daysBeforeNext = daysBeforeNextOvulationDay(dates: dateArray, selectedDate: ovulationMonthData[currentSelectedMonth].Month.firstDateOfMonth()) {
                ovulationSelectedDayDescription = "\("OvulationCalendarVC.Daysbefore.headlineLabel.text"~) \(daysBeforeNext)"
            }
            ovulationSelectedDayProbability = .low
        }
        
        self.ovulationCircularCalendar.updateDetailsLabels(selectedDay: 1, monthName: ovulationMonthData[currentSelectedMonth].Month.monthString, description: ovulationSelectedDayDescription, probabiility: ovulationSelectedDayProbability)
        
    }
    
    func MonthScrollPicker(_ MonthScrollPicker: MonthScrollPicker, didMonthChange date: Date) {
        scrollableDateView.selectedDate = nil
        scrollableDateView.selectDate(date.firstDateOfMonth())
    }
    
    func ovulationCircularCalendar(_ ovulationCircularCalendar: OvulationCircularCalendarView, didSelectDay day: Int) {
        scrollableDateView.selectDate(self.ovulationMonthData[currentSelectedMonth].Month.firstDateOfMonth().addDays(day - 1)!)
    }
    
}

extension OvulationCalendarVC {
    func findDateRanges(dates: [Date]) -> [(start: Int, end: Int)] {
        var result: [(start: Int, end: Int)] = []
        
        // Sort the dates
        let sortedDates = dates.sorted()
        
        // Initialize variables for the current range
        var currentStart = 0
        var currentEnd = 0
        
        for (index, date) in sortedDates.enumerated() {
            if index == 0 {
                // Set initial values for the first date
                currentStart = Calendar.current.component(.day, from: date)
                currentEnd = currentStart
            } else {
                // Check if the current date is consecutive to the previous one
                let previousDate = sortedDates[index - 1]
                let dayDifference = Calendar.current.dateComponents([.day], from: previousDate, to: date).day
                
                if dayDifference == 1 {
                    // If consecutive, update the end day
                    currentEnd = Calendar.current.component(.day, from: date)
                } else {
                    // If not consecutive, add the current range to the result and start a new range
                    result.append((start: currentStart, end: currentEnd))
                    currentStart = Calendar.current.component(.day, from: date)
                    currentEnd = currentStart
                }
            }
        }
        
        // Add the last range to the result
        result.append((start: currentStart, end: currentEnd))
        
        return result
    }
    
    func isDateInArray(targetDate: Date, dateArray: [Date]) -> Bool {
        for date in dateArray {
            if Calendar.current.isDate(date, inSameDayAs: targetDate) {
                return true
            }
        }
        return false
    }
    
    func findPositionInDateRanges(from dates: [Date], for targetDate: Date) -> Int? {
        // Function to create ranges of consecutive dates
        func createRanges(from dates: [Date]) -> [ClosedRange<Date>] {
            var dateRanges: [ClosedRange<Date>] = []
            var currentRange: ClosedRange<Date>?

            for date in dates.sorted() {
                if let previousDate = currentRange?.upperBound, date.timeIntervalSince(previousDate) > 24 * 60 * 60 {
                    // Gap of more than one day, start a new range
                    if let range = currentRange {
                        dateRanges.append(range)
                    }
                    currentRange = date...date
                } else {
                    // Continue the current range
                    currentRange = (currentRange?.lowerBound ?? date)...date
                }
            }

            // Add the last range
            if let range = currentRange {
                dateRanges.append(range)
            }

            return dateRanges
        }

        // Function to find the position of the target date within the matched range
        func findPosition(in dateRanges: [ClosedRange<Date>], for targetDate: Date) -> Int? {
            for (index, dateRange) in dateRanges.enumerated() {
                if dateRange.contains(targetDate) {
                    let position = Calendar.current.dateComponents([.day], from: dateRange.lowerBound, to: targetDate).day! + 1
                    return position
                }
            }

            return nil // Return nil if the target date is not in any range
        }

        let dateRanges = createRanges(from: dates)

        return findPosition(in: dateRanges, for: targetDate)
    }
    
    func daysBeforeNextOvulationDay(dates: [Date], selectedDate: Date) -> Int? {
        // Filter out dates that are before the reference date
        let validDates = dates.filter { $0 > selectedDate }
        
        // Sort the valid dates in ascending order
        let sortedDates = validDates.sorted()
        
        // Find the index of the next day
        if let nextDayIndex = sortedDates.firstIndex(where: { $0 > selectedDate.addingTimeInterval(24 * 60 * 60) }) {
            // Calculate the number of days between the reference date and the next day
            let daysDifference = Calendar.current.dateComponents([.day], from: selectedDate, to: sortedDates[nextDayIndex]).day ?? 0
            return daysDifference
        }
        
        // If no next day is found, return nil
        return nil
    }

}
