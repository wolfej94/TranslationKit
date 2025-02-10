//
//  TranslationResponse.swift
//  TranslationKit
//
//  Created by James Wolfe on 05/02/2025.
//
import Translation

/// A structure representing the response from a translation operation.
@available(iOS 16, *)
public struct TranslationResponse: Sendable {
    /// The translated text result.
    public let result: String
    
    /// The language into which the text was translated.
    public let targetLanguage: Locale.Language

    /// Initializes a `TranslationResponse` with a translated result and target language.
    ///
    /// - Parameters:
    ///   - result: The translated text.
    ///   - targetLanguage: The language into which the text was translated.
    public init(result: String, targetLanguage: Locale.Language) {
        self.result = result
        self.targetLanguage = targetLanguage
    }
}
