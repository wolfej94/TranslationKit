//
//  LanguageRecognitionService.swift
//  TranslationKit
//
//  Created by James Wolfe on 04/02/2025.
//

import NaturalLanguage

@available(iOS 16, *)
internal protocol LanguageRecognitionService: AnyObject, Sendable {
    func recognizeLanguage(in text: String) throws -> Locale.Language
}

/// An error type representing failures in language recognition.
public enum LanguageRecognitionError: Error {
    /// Indicates that the source language could not be recognized.
    case failedToRecognizeSourceLanguage
}


@available(iOS 16, *)
internal final class DefaultLanguageRecognitionService: LanguageRecognitionService {
    
    private let recognizer = NLLanguageRecognizer()
    
    func recognizeLanguage(in text: String) throws -> Locale.Language {
        recognizer.reset()
        defer { recognizer.reset() }
        recognizer.processString(text)
        guard let language = recognizer.dominantLanguage, language != .undetermined else {
            throw LanguageRecognitionError.failedToRecognizeSourceLanguage
        }
        return Locale.Language(identifier: language.rawValue)
    }
    
}

extension NLLanguageRecognizer: @unchecked @retroactive Sendable {}
