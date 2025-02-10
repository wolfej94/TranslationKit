//
//  MockTranslationSessionProviderFactory.swift
//  TranslationKit
//
//  Created by James Wolfe on 05/02/2025.
//

import Translation
@testable import TranslationKit

@available(iOS 18, *)
final class MockTranslationSessionProviderFactory: TranslationSessionProviderFactory {
    
    var sessionProviderToReturn: TranslationSessionProvider!
    func sessionProvider(sourceLanguage: Locale.Language?, targetLanguage: Locale.Language?) -> any TranslationSessionProvider {
        return sessionProviderToReturn
    }
    
}
