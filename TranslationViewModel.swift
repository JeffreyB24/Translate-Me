//
//  TranslationViewModel.swift
//  CodePath-HW6
//
//  Created by Jeffrey Berdeal on 10/14/25.
//

import Foundation

struct TranslationRecord: Identifiable, Codable {
    var id = UUID()
    let original: String
    let translated: String
    let fromLang: String
    let toLang: String
    let date: Date
}

@MainActor
final class TranslationViewModel: ObservableObject {
    @Published var inputText = ""
    @Published var outputText = ""
    @Published var fromLang = "en"
    @Published var toLang = "es"
    @Published var history: [TranslationRecord] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let storageKey = "translation_history_v2"

    // Common language options
    let languages: [String: String] = [
        "English": "en",
        "Spanish": "es",
        "French": "fr",
        "German": "de",
        "Italian": "it",
        "Portuguese": "pt",
        "Dutch": "nl",
        "Chinese (Simplified)": "zh-CN",
        "Japanese": "ja",
        "Korean": "ko"
    ]

    init() { loadHistory() }

    func swapLanguages() {
        (fromLang, toLang) = (toLang, fromLang)
        if !outputText.isEmpty {
            inputText = outputText
            outputText = ""
        }
    }

    func translate() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        Task {
            isLoading = true
            errorMessage = nil
            do {
                let translated = try await translateWithMyMemory(text: inputText, from: fromLang, to: toLang)
                outputText = translated
                let record = TranslationRecord(
                    original: inputText,
                    translated: translated,
                    fromLang: fromLang,
                    toLang: toLang,
                    date: Date()
                )
                history.insert(record, at: 0)
                saveHistory()
            } catch {
                errorMessage = "Translation failed. Please try again."
            }
            isLoading = false
        }
    }

    private func translateWithMyMemory(text: String, from: String, to: String) async throws -> String {
        var comps = URLComponents(string: "https://api.mymemory.translated.net/get")!
        comps.queryItems = [
            URLQueryItem(name: "q", value: text),                 // no manual percentEncoding here
            URLQueryItem(name: "langpair", value: "\(from)|\(to)")
        ]
        guard let url = comps.url else { throw URLError(.badURL) }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        struct APIResponse: Decodable {
            struct ResponseData: Decodable { let translatedText: String }
            let responseData: ResponseData
        }

        let decoded = try JSONDecoder().decode(APIResponse.self, from: data)
        // MyMemory should return plain text, but just in case:
        return decoded.responseData.translatedText.removingPercentEncoding ?? decoded.responseData.translatedText
    }


    func clearHistory() {
        history.removeAll()
        UserDefaults.standard.removeObject(forKey: storageKey)
    }

    private func saveHistory() {
        if let data = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([TranslationRecord].self, from: data) {
            history = decoded
        }
    }
}
