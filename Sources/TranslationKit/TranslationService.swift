// The Swift Programming Language
// https://docs.swift.org/swift-book

import Translation
import SwiftUI
import NaturalLanguage

/// A protocol defining a translation service that translates text between languages.
@available(iOS 16, *)
public protocol TranslationServiceProtocol: AnyObject {
    /// Translates the given source text from one language to another asynchronously.
    ///
    /// - Parameters:
    ///   - sourceText: The text to be translated.
    ///   - sourceLanguage: The source language of the text. If `nil`, the language will be auto-detected.
    ///   - targetLanguage: The target language for translation.
    /// - Returns: A `TranslationResponse` containing the translated text and related metadata.
    /// - Throws: `TranslationError.translationFailed` if translation fails.
    @MainActor
    func translate(sourceText: String, from sourceLanguage: Locale.Language?, to targetLanguage: Locale.Language) async throws -> TranslationResponse
}

/// An enumeration representing possible translation errors.
public enum TranslationError: Error {
    /// Represents a failed translation with an associated error message.
    case translationFailed(String)
}

/// The default implementation of `TranslationService` that provides translation functionality.
@available(iOS 18, *)
public final class TranslationService: TranslationServiceProtocol, Sendable {
    private let languageRecognizer: LanguageRecognitionService
    private let sessionProviderFactory: TranslationSessionProviderFactory
    
    /// Initializes a `DefaultTranslationService` with custom dependencies.
    ///
    /// - Parameters:
    ///   - languageRecognizer: A service responsible for detecting the language of a given text.
    ///   - sessionProviderFactory: A factory responsible for providing translation sessions.
    internal init(languageRecognizer: LanguageRecognitionService,
                  sessionProviderFactory: TranslationSessionProviderFactory) {
        self.languageRecognizer = languageRecognizer
        self.sessionProviderFactory = sessionProviderFactory
    }
    
    /// Creates a new instance of `DefaultTranslationService` using the default language recognition and translation session provider.
    public init() {
        self.languageRecognizer = DefaultLanguageRecognitionService()
        self.sessionProviderFactory = DefaultTranslationSessionProviderFactory<DefaultTranslationSessionProvider>()
    }
    
    /// Translates the given source text from one language to another asynchronously.
    ///
    /// - Parameters:
    ///   - sourceText: The text to be translated.
    ///   - sourceLanguage: The source language of the text. If `nil`, the language will be auto-detected.
    ///   - targetLanguage: The target language for translation.
    /// - Returns: A `TranslationResponse` containing the translated text and related metadata.
    /// - Throws: `TranslationError.translationFailed` if translation fails.
    public func translate(sourceText: String, from sourceLanguage: Locale.Language?, to targetLanguage: Locale.Language) async throws -> TranslationResponse {
        let sourceLanguage = try sourceLanguage ?? languageRecognizer.recognizeLanguage(in: sourceText)
        let sessionProvider = sessionProviderFactory.sessionProvider(sourceLanguage: sourceLanguage,
                                                                           targetLanguage: targetLanguage)
        
        let session = await sessionProvider.session()
        do {
            let response = try await session.translate(sourceText)
            await sessionProvider.endSession()
            return response
        } catch {
            throw TranslationError.translationFailed(error.localizedDescription)
        }
    }
}
