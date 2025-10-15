//
//  ContentView.swift
//  CodePath-HW6
//
//  Created by Jeffrey Berdeal on 10/14/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: TranslationViewModel

    init(viewModel: TranslationViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Translate Me")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .padding(.top, 20)

                    // Language selection
                    HStack(spacing: 10) {
                        LanguagePicker(
                            title: "From",
                            languages: viewModel.languages,
                            selectedCode: $viewModel.fromLang
                        )
                        Button(action: viewModel.swapLanguages) {
                            Image(systemName: "arrow.left.arrow.right.circle.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                        LanguagePicker(
                            title: "To",
                            languages: viewModel.languages,
                            selectedCode: $viewModel.toLang
                        )
                    }
                    .padding(.horizontal)

                    // Input text
                    TextField("Enter a word or phrase", text: $viewModel.inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    // Translate button
                    Button {
                        viewModel.translate()
                    } label: {
                        HStack {
                            if viewModel.isLoading { ProgressView() }
                            Text("Translate")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }

                    // Output text
                    if !viewModel.outputText.isEmpty {
                        Text(viewModel.outputText)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }

                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }

                    // History
                    VStack(spacing: 10) {
                        Text("Saved Translations")
                            .font(.headline)
                            .padding(.top, 10)

                        if viewModel.history.isEmpty {
                            Text("No saved translations yet.")
                                .foregroundColor(.secondary)
                        } else {
                            ForEach(viewModel.history) { record in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(flag(for: record.fromLang)) \(record.original)")
                                    Divider()
                                    Text("\(flag(for: record.toLang)) \(record.translated)")
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                                .padding(.horizontal)
                            }

                            Button(role: .destructive) {
                                viewModel.clearHistory()
                            } label: {
                                Text("Clear All Translations")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
        }
    }

    // helper
    func flag(for code: String) -> String {
        switch code.lowercased() {
        case "en": return "🇺🇸"
        case "es": return "🇪🇸"
        case "fr": return "🇫🇷"
        case "de": return "🇩🇪"
        case "it": return "🇮🇹"
        case "pt": return "🇵🇹"
        case "nl": return "🇳🇱"
        case "zh-cn": return "🇨🇳"
        case "ja": return "🇯🇵"
        case "ko": return "🇰🇷"
        default: return "🌐"
        }
    }
}

struct LanguagePicker: View {
    let title: String
    let languages: [String: String]
    @Binding var selectedCode: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Menu {
                ForEach(languages.sorted(by: { $0.key < $1.key }), id: \.key) { name, code in
                    Button {
                        selectedCode = code
                    } label: {
                        HStack {
                            Text("\(flag(for: code)) \(name)")
                            if selectedCode == code { Image(systemName: "checkmark") }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(currentLanguageName)
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var currentLanguageName: String {
        languages.first(where: { $0.value == selectedCode })?.key ?? "Unknown"
    }

    private func flag(for code: String) -> String {
        switch code.lowercased() {
        case "en": return "🇺🇸"
        case "es": return "🇪🇸"
        case "fr": return "🇫🇷"
        case "de": return "🇩🇪"
        case "it": return "🇮🇹"
        case "pt": return "🇵🇹"
        case "nl": return "🇳🇱"
        case "zh-cn": return "🇨🇳"
        case "ja": return "🇯🇵"
        case "ko": return "🇰🇷"
        default: return "🌐"
        }
    }
}


#Preview {
    ContentView(viewModel: TranslationViewModel())
}
