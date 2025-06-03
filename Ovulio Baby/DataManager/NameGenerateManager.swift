//
//  NameGenerateManager.swift
//  Ovulio Baby
//
//  Created by USER on 10/04/25.
//

import Foundation

enum FavouriteCategory: String {
    case girls = "Girls"
    case boys = "Boys"
    case unisex = "Unisex"
}


struct ChatMessage: Codable {
    let role: String
    let content: String
}

struct ChatRequest: Codable {
    let model: String
    let messages: [ChatMessage]
    let temperature: Double
    let max_tokens: Int
}

struct ChatResponse: Codable {
    struct Choice: Codable {
        struct Message: Codable {
            let role: String
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}

class NameGenerateManager {
    
    static let shared = NameGenerateManager()
    
    private let userDefaults = UserDefaults.standard
    
    private let RegionKey = "Region"
    private let LastNameKey = "LastName"
    private let selectedGenderKey = "SelectedGender"
    private let ChooseStyleKey = "ChooseStyle"
    private let ChooseLengthKey = "ChooseLength"
    
    private let SelectFavouriteNameKey = "SelectFavouriteName"
    
    
    
    var Region: String? {
        get {
            return userDefaults.value(forKey: RegionKey) as? String
        }
        set {
            userDefaults.set(newValue, forKey: RegionKey)
        }
    }
    
    func updateRegion(_ name: String) {
        Region = name
    }
    
    var LastName: String? {
        get {
            return userDefaults.value(forKey: LastNameKey) as? String
        }
        set {
            userDefaults.set(newValue, forKey: LastNameKey)
        }
    }
    
    func updateLastName(_ name: String) {
        LastName = name
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
    
    
    var ChooseStyle: String? {
        get {
            return userDefaults.value(forKey: ChooseStyleKey) as? String
        }
        set {
            userDefaults.set(newValue, forKey: ChooseStyleKey)
        }
    }
    
    func updateChooseStyle(_ name: String) {
        ChooseStyle = name
    }
    
    var ChooseLength: String? {
        get {
            return userDefaults.value(forKey: ChooseLengthKey) as? String
        }
        set {
            userDefaults.set(newValue, forKey: ChooseLengthKey)
        }
    }
    
    func updateChooseLength(_ name: String) {
        ChooseLength = name
    }
    
    
    var favouriteNamesByCategory: [String: [String]] {
        get {
            let data = UserDefaults.standard.dictionary(forKey: "FavouriteNamesByCategory") as? [String: [String]]
            return data ?? [
                FavouriteCategory.girls.rawValue: [],
                FavouriteCategory.boys.rawValue: [],
                FavouriteCategory.unisex.rawValue: []
            ]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "FavouriteNamesByCategory")
        }
    }


    
    func addFavouriteName(_ name: String, for category: FavouriteCategory) {
        var currentData = favouriteNamesByCategory
        var names = currentData[category.rawValue] ?? []
        
        if !names.contains(name) {
            names.append(name)
            currentData[category.rawValue] = names
            favouriteNamesByCategory = currentData
        }
    }
    
    func removeFavouriteName(_ name: String, for category: FavouriteCategory) {
        var currentData = favouriteNamesByCategory
        var names = currentData[category.rawValue] ?? []
        
        names.removeAll { $0 == name }
        currentData[category.rawValue] = names
        favouriteNamesByCategory = currentData
    }

    
    func getFavouriteNames(for category: FavouriteCategory) -> [String] {
        return favouriteNamesByCategory[category.rawValue] ?? []
    }

    
    func saveFavouriteNames(_ names: [String], for category: FavouriteCategory) {
        var currentData = favouriteNamesByCategory
        currentData[category.rawValue] = names
        favouriteNamesByCategory = currentData
    }

    
    func generatePrompt(from input: NameGeneratorInput) -> String {
            return """
            Generate a list of 20 unique \(input.style.lowercased()) \(input.category.lowercased()) first names \
            of \(input.length.lowercased()) length that are popular in \(input.region). \
            The last name should be \(input.lastName). \
            Return the list in plain text, one name per line. Respond in language code: \(input.localized).
            """
        }
        
        
        func generateNameWithAI(input: NameGeneratorInput, completion: @escaping ([String]?) -> Void) {
            guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
                print("Invalid URL")
                completion(nil)
                return
            }
            
            let prompt = generatePrompt(from: input)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer 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", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let chatRequest = ChatRequest(
                model: "gpt-3.5-turbo",
                messages: [ChatMessage(role: "user", content: prompt)],
                temperature: 0.7,
                max_tokens: 500
            )
            
            do {
                request.httpBody = try JSONEncoder().encode(chatRequest)
            } catch {
                print("❌ JSON encoding error: \(error)")
                completion(nil)
                return
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("❌ API call error: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                guard let data = data else {
                    print("❌ No data received.")
                    completion(nil)
                    return
                }
                
                if let jsonStr = String(data: data, encoding: .utf8) {
                    print("📨 Raw Response: \(jsonStr)")
                }
                
                do {
                    let decoded = try JSONDecoder().decode(ChatResponse.self, from: data)
                    let rawText = decoded.choices.first?.message.content ?? ""
                    
                    let nameArray = rawText
                        .components(separatedBy: .newlines)
                        .map { line -> String in
                            if let range = line.range(of: ". ") {
                                return String(line[range.upperBound...]).trimmingCharacters(in: .whitespaces)
                            } else {
                                return line.trimmingCharacters(in: .whitespaces)
                            }
                        }
                        .filter { !$0.isEmpty }
                    
                    completion(nameArray)
                } catch {
                    print("❌ Decoding error: \(error)")
                    completion(nil)
                }
            }.resume()
        }
    }
