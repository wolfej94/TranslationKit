//
//  TranslationSessionProviderFactory.swift
//  TranslationKit
//
//  Created by James Wolfe on 04/02/2025.
//

import Translation

@MainActor
@available(iOS 18, *)
protocol TranslationSessionProviderFactory: Sendable {
    func sessionProvider(sourceLanguage: Locale.Language?, targetLanguage: Locale.Language?) -> any TranslationSessionProvider
}

@available(iOS 18, *)
internal final class DefaultTranslationSessionProviderFactory<T: TranslationSessionProvider>: TranslationSessionProviderFactory {
    
    func sessionProvider(sourceLanguage: Locale.Language?, targetLanguage: Locale.Language?) -> any TranslationSessionProvider {
        let configuration = TranslationSession.Configuration(source: sourceLanguage, target: targetLanguage)
        return T(configuration: configuration) as any TranslationSessionProvider
    }
}

