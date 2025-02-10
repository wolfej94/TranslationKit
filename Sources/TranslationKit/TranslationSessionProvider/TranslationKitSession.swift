//
//  TranslationKitSession.swift
//  TranslationKit
//
//  Created by James Wolfe on 05/02/2025.
//

import Translation

@available(iOS 16, *)
protocol TranslationKitSession: Sendable {
    var targetLanguage: Locale.Language? { get }
    func translate(_ string: String) async throws -> TranslationResponse
}

@available(iOS 18, *)
final class DefaultTranslationKitSession: TranslationKitSession {
    
    private let wrappedSession: TranslationSession
    var sourceLanguage: Locale.Language? {
        wrappedSession.sourceLanguage
    }
    var targetLanguage: Locale.Language? {
        wrappedSession.targetLanguage
    }
    
    init(from wrappedSession: TranslationSession) {
        self.wrappedSession = wrappedSession
    }
    
    func translate(_ string: String) async throws -> TranslationResponse {
        let result = try await wrappedSession.translate(string)
        return TranslationResponse(result: result.targetText,
                                   targetLanguage: result.targetLanguage)
    }
    
}


