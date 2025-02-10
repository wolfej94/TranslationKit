//
//  MockTranslationKitSession.swift
//  TranslationKit
//
//  Created by James Wolfe on 05/02/2025.
//

import Translation
@testable import TranslationKit

@available(iOS 16, *)
final class MockTranslationKitSession: TranslationKitSession, @unchecked Sendable {
    
    var targetLanguage: Locale.Language?
    
    init(targetLanguage: Locale.Language? = nil) {
        self.targetLanguage = targetLanguage
    }
    
    var translationResult: Result<String, Error>?
    func translate(_ string: String) async throws -> TranslationResponse {
        switch translationResult! {
        case .success(let result):
            return TranslationResponse(result: result,
                                       targetLanguage: targetLanguage!)
        case .failure(let error):
            throw error
        }
    }
    
}
