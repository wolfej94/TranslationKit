//
//  MockTranslationServiceProvider.swift
//  TranslationKit
//
//  Created by James Wolfe on 05/02/2025.
//

import Translation
@testable import TranslationKit

@available(iOS 18, *)
final class MockTranslationServiceProvider: TranslationSessionProvider, @unchecked Sendable {
    
    var configuration: TranslationSession.Configuration
    init(configuration: TranslationSession.Configuration) {
        self.configuration = configuration
    }
    
    var sessionToReturn: MockTranslationKitSession?
    func session() async -> TranslationKitSession {
        if let sessionToReturn {
            return sessionToReturn
        } else {
            return MockTranslationKitSession(targetLanguage: configuration.target)
        }
    }
}
