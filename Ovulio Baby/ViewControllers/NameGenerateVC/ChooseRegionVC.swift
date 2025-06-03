//
//  ChooseRegionVC.swift
//  Ovulio Baby
//
//  Created by USER on 11/04/25.
//

import UIKit

class ChooseRegionVC: UIViewController {
    
    struct Country {
        let name: String
        let code: String
        var localizedName: String {
               return Locale.current.localizedString(forRegionCode: code) ?? name
           }
    }
    
    
    // MARK: - Data Source
    let suggestedCountries : [Country] = [Country(name: "United States", code: "US"),
                                          Country(name: "France", code: "FR"),
                                          Country(name: "Poland", code: "PL"),
                                          Country(name: "Germany", code: "DE"),
                                          Country(name: "Italy", code: "IT")]
    
    lazy var localizedsuggestedCountries: [Country] = {
        let languageCode = MultiLanguage.MultiLanguageConst.currentAppleLanguage()
        let locale = Locale(identifier: languageCode)
        return suggestedCountries.map { country in
            let name = locale.localizedString(forRegionCode: country.code) ?? country.name
            return Country(name: name, code: country.code)
        }
    }()
    
    
    
    let countries: [Country] = [
        
        Country(name: "Afghanistan", code: "AF"),
        Country(name: "Aland Islands", code: "AX"),
        Country(name: "Albania", code: "AL"),
        Country(name: "Algeria", code: "DZ"),
        Country(name: "Andorra", code: "AD"),
        Country(name: "Bahamas", code: "BS"),
        Country(name: "Bahrain", code: "BH"),
        Country(name: "Bangladesh", code: "BD"),
        Country(name: "Barbados", code: "BB"),
        Country(name: "Belarus", code: "BY"),
        Country(name: "Canada", code: "CA"),
        Country(name: "China", code: "CN"),
        Country(name: "Colombia", code: "CO"),
        Country(name: "Croatia", code: "HR"),
        Country(name: "Cuba", code: "CU"),
        Country(name: "Denmark", code: "DK"),
        Country(name: "Dominica", code: "DM"),
        Country(name: "Dominican Republic", code: "DO"),
        Country(name: "Egypt", code: "EG"),
        Country(name: "Estonia", code: "EE"),
        Country(name: "Ethiopia", code: "ET"),
        Country(name: "Finland", code: "FI"),
        Country(name: "Greece", code: "GR"),
        Country(name: "Hungary", code: "HU"),
        Country(name: "India", code: "IN"),
        Country(name: "Indonesia", code: "ID"),
        Country(name: "Japan", code: "JP"),
        Country(name: "Jordan", code: "JO"),
        Country(name: "Kenya", code: "KE"),
        Country(name: "Kuwait", code: "KW"),
        Country(name: "Latvia", code: "LV"),
        Country(name: "Lebanon", code: "LB"),
        Country(name: "Lithuania", code: "LT"),
        Country(name: "Luxembourg", code: "LU"),
        Country(name: "Mexico", code: "MX"),
        Country(name: "Morocco", code: "MA"),
        Country(name: "Netherlands", code: "NL"),
        Country(name: "New Zealand", code: "NZ"),
        Country(name: "Norway", code: "NO"),
        Country(name: "Oman", code: "OM"),
        Country(name: "Pakistan", code: "PK"),
        Country(name: "Portugal", code: "PT"),
        Country(name: "Qatar", code: "QA"),
        Country(name: "Romania", code: "RO"),
        Country(name: "Russia", code: "RU"),
        Country(name: "Saudi Arabia", code: "SA"),
        Country(name: "Singapore", code: "SG"),
        Country(name: "South Africa", code: "ZA"),
        Country(name: "Spain", code: "ES"),
        Country(name: "Sweden", code: "SE"),
        Country(name: "Switzerland", code: "CH"),
        Country(name: "Thailand", code: "TH"),
        Country(name: "Tunisia", code: "TN"),
        Country(name: "Turkey", code: "TR"),
        Country(name: "Uganda", code: "UG"),
        Country(name: "Ukraine", code: "UA"),
        Country(name: "United Kingdom", code: "GB"),
        Country(name: "Uruguay", code: "UY"),
        Country(name: "Venezuela", code: "VE"),
        Country(name: "Vietnam", code: "VN"),
        Country(name: "Yemen", code: "YE"),
        Country(name: "Zambia", code: "ZM"),
        Country(name: "Zimbabwe", code: "ZW")
    ]
    
    
    lazy var localizedCountries: [Country] = {
        let languageCode = MultiLanguage.MultiLanguageConst.currentAppleLanguage()
        let locale = Locale(identifier: languageCode)
        return countries.map { country in
            let name = locale.localizedString(forRegionCode: country.code) ?? country.name
            return Country(name: name, code: country.code)
        }
    }()


    
    var countriesByLetter: [String: [Country]] {
        var grouped = [String: [Country]]()
        for country in localizedCountries {
            let firstLetter = String(country.name.prefix(1)).uppercased()
            grouped[firstLetter, default: []].append(country)
        }
        return grouped
    }
    
    
    
    
    lazy var sortedSectionTitles: [String] = {
        return ["ChooseRegionVC.HeaderSection.text"~] + countriesByLetter.keys.sorted()
    }()
    
    var selectedCountry: String?
    
    var filteredSuggestedCountries: [Country] = []
    var filteredCountriesByLetter: [String: [Country]] = [:]
    var isSearching = false
    
    
    var customNavBarView: CustomNavigationBar?
    var genderUpdationProtocolDelegate: GenderUpdationProtocol?
    var isPresentedForProfile = true
    var dismissedWithOutData: ((Bool) -> Void)?
    
    
    var NameGenerateContentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "ChooseRegionVC.searchRegion.placeholder.text"~
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundImage = UIImage() // Removes the default background
        searchBar.barTintColor = .clear
        searchBar.backgroundColor = .clear
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.layer.cornerRadius = 8
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.searchTextField.tintColor = appColor
        searchBar.searchTextField.textColor = appColor
        searchBar.searchTextField.leftView?.tintColor = UIColor(hex: "#9B89AC")
        
        // Set placeholder color
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "ChooseRegionVC.searchRegion.placeholder.text"~,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: "#9B89AC")]
        )
        
        // Shadow (optional)
        searchBar.searchTextField.layer.shadowColor = UIColor.black.cgColor
        searchBar.searchTextField.layer.shadowOpacity = 0.05
        searchBar.searchTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        searchBar.searchTextField.layer.shadowRadius = 4
        
        // 🔥 Set custom height for searchTextField
        searchBar.searchTextField.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        return searchBar
    }()
    
    
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionIndexColor = UIColor.purple
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        searchBar.delegate = self
        //   searchBar.showsCancelButton = true
        self.view.setUpBackground()
        
        self.view.addSubview(NameGenerateContentContainer)
        if DeviceSize.isiPadDevice {
            NSLayoutConstraint.activate([
                NameGenerateContentContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                NameGenerateContentContainer.widthAnchor.constraint(equalToConstant: 460),
                NameGenerateContentContainer.topAnchor.constraint(equalTo: self.view.topAnchor),
                NameGenerateContentContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
        }else{
            NSLayoutConstraint.activate([
                NameGenerateContentContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                NameGenerateContentContainer.topAnchor.constraint(equalTo: self.view.topAnchor),
                NameGenerateContentContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                NameGenerateContentContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
        }
        NameGenerateContentContainer.addSubview(searchBar)
        NameGenerateContentContainer.addSubview(tableView)
        setUpNavigationBar()
        setUpTableView()
        
    }
    
    func getDutchCountries(from countries: [Country]) -> [Country] {
        let languageCode = MultiLanguage.MultiLanguageConst.currentAppleLanguage() // e.g., "nl"
        let locale = Locale(identifier: languageCode)

        return countries.map { country in
            let localizedName = locale.localizedString(forRegionCode: country.code) ?? country.name
            return Country(name: localizedName, code: country.code)
        }
    }

    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CountryTableCell.self, forCellReuseIdentifier: "CountryTableCell")
        
        // Add searchBar before setting constraints
        NameGenerateContentContainer.addSubview(searchBar)
        NameGenerateContentContainer.addSubview(tableView)
        
        if let customNavBarView = customNavBarView {
            searchBar.topAnchor.constraint(equalTo: customNavBarView.bottomAnchor, constant: 10).isActive = true
        } else {
            searchBar.topAnchor.constraint(equalTo: NameGenerateContentContainer.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        }
        
        NSLayoutConstraint.activate([
            // Search bar constraints
            searchBar.topAnchor.constraint(equalTo: NameGenerateContentContainer.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: NameGenerateContentContainer.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: NameGenerateContentContainer.trailingAnchor, constant: -16),
            
            
            // Table view constraints
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: NameGenerateContentContainer.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: NameGenerateContentContainer.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: NameGenerateContentContainer.bottomAnchor, constant: 16)
        ])
    }
    
    
    func setUpNavigationBar() {
        
        customNavBarView = CustomNavigationBar(
            leftImage: UIImage(named: "backButtonImg"),
            titleString: "ChooseRegionVC.headlineLabel.text"~)
        
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
    
    func flagEmoji(for countryCode: String) -> String {
        let base: UInt32 = 127397
        var flagString = ""
        for scalar in countryCode.uppercased().unicodeScalars {
            if let scalarValue = UnicodeScalar(base + scalar.value) {
                flagString.unicodeScalars.append(scalarValue)
            }
        }
        return flagString
    }
    
    func emojiToImage(_ emoji: String, size: CGFloat = 40) -> UIImage? {
        let label = UILabel()
        label.text = emoji
        label.font = UIFont.systemFont(ofSize: size)
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.frame = CGRect(x: 0, y: 0, width: size, height: size)
        
        let renderer = UIGraphicsImageRenderer(size: label.bounds.size)
        return renderer.image { context in
            label.layer.render(in: context.cgContext)
        }
    }
    
}


// MARK: UIAction
extension ChooseRegionVC {
    
    @objc func touchDownButtonAction(_ sender: UIButton) {
        sender.touchDownAnimation {}
    }
    
    @objc func touchUpButtonAction(_ sender: UIButton) {
        sender.touchUpAnimation {}
    }
    
}

extension ChooseRegionVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching {
            return (filteredSuggestedCountries.isEmpty ? 0 : 1) + filteredCountriesByLetter.keys.sorted().count
        }
        return sortedSectionTitles.count
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = appColor
            header.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            header.backgroundView = .none
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            let titles = getCurrentSearchSectionTitles()
            let sectionTitle = titles[section]
            if sectionTitle == "ChooseRegionVC.HeaderSection.text"~ {
                return filteredSuggestedCountries.count
            } else {
                return filteredCountriesByLetter[sectionTitle]?.count ?? 0
            }
        } else {
            let sectionTitle = sortedSectionTitles[section]
            if sectionTitle == "ChooseRegionVC.HeaderSection.text"~ {
                return localizedsuggestedCountries.count
            } else {
                return countriesByLetter[sectionTitle]?.count ?? 0
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isSearching {
            var titles: [String] = []
            if !filteredSuggestedCountries.isEmpty {
                titles.append("ChooseRegionVC.HeaderSection.text"~)
            }
            titles += filteredCountriesByLetter.keys.sorted()
            return titles[section]
        }
        return sortedSectionTitles[section]
    }
    
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        // Don't include "Suggested" in index if you want A-Z only
        return sortedSectionTitles.filter { $0 != "ChooseRegionVC.HeaderSection.text"~ }
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return sortedSectionTitles.firstIndex(of: title) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableCell", for: indexPath) as! CountryTableCell
        
        let countryName: Country
        if isSearching {
            let sectionTitle = getCurrentSearchSectionTitles()[indexPath.section]
            if sectionTitle == "ChooseRegionVC.HeaderSection.text"~ {
                countryName = filteredSuggestedCountries[indexPath.row]
            } else {
                countryName = filteredCountriesByLetter[sectionTitle]?[indexPath.row] ?? Country(name: "Unknown", code: "XX")
            }
        } else {
            let sectionTitle = sortedSectionTitles[indexPath.section]
            if sectionTitle == "ChooseRegionVC.HeaderSection.text"~ {
                countryName = localizedsuggestedCountries[indexPath.row]
            } else {
                countryName = countriesByLetter[sectionTitle]?[indexPath.row] ?? Country(name: "Unknown", code: "XX")
            }
        }
        
        
        let flagEmojiString = flagEmoji(for: countryName.code)
        
        if let image = emojiToImage(flagEmojiString) {
            cell.configure(with: countryName.name, isSelected: countryName.name == selectedCountry, flag: image)
        } else {
            cell.configure(with: countryName.name, isSelected: countryName.name == selectedCountry, flag: UIImage(named: "france_flag") ?? UIImage())
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country: Country
        
        if isSearching {
            let sectionTitle = getCurrentSearchSectionTitles()[indexPath.section]
            if sectionTitle == "ChooseRegionVC.HeaderSection.text"~ {
                country = filteredSuggestedCountries[indexPath.row]
            } else {
                country = filteredCountriesByLetter[sectionTitle]?[indexPath.row] ?? Country(name: "Unknown", code: "XX")
            }
        } else {
            let sectionTitle = sortedSectionTitles[indexPath.section]
            if sectionTitle == "ChooseRegionVC.HeaderSection.text"~ {
                country = localizedsuggestedCountries[indexPath.row]
            } else {
                country = countriesByLetter[sectionTitle]?[indexPath.row] ?? Country(name: "Unknown", code: "XX")
            }
        }
        
        selectedCountry = country.name
        NameGenerateDataBeforeSaving.RegionName = country.name
        NameGenerateDataBeforeSaving.isRegionNameChanged = true
        self.dismiss(animated: false)
        
        // If you want to pass the selected country back
        print("Selected country: \(country)")
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40 // or whatever height you prefer
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func getCurrentSearchSectionTitles() -> [String] {
        var titles: [String] = []
        if !filteredSuggestedCountries.isEmpty {
            titles.append("ChooseRegionVC.HeaderSection.text"~)
        }
        titles += filteredCountriesByLetter.keys.sorted()
        return titles
    }
    
    
}


extension ChooseRegionVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
        } else {
            isSearching = true
            
            filteredSuggestedCountries = localizedsuggestedCountries.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            
            filteredCountriesByLetter = [:]
            for (key, countries) in countriesByLetter {
                let matched = countries.filter { $0.name.lowercased().contains(searchText.lowercased()) }
                if !matched.isEmpty {
                    filteredCountriesByLetter[key] = matched
                }
            }
        }
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
}
