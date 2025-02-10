//
//  MockLanguageRecognitionService.swift
//  TranslationKit
//
//  Created by James Wolfe on 05/02/2025.
//

import NaturalLanguage
import Translation
@testable import TranslationKit

@available(iOS 16, *)
final class MockLanguageRecognitionService: LanguageRecognitionService, @unchecked Sendable {
    
    var recognizeLanguageResult: Result<Locale.Language, Error>?
    func recognizeLanguage(in text: String) throws -> Locale.Language {
        switch recognizeLanguageResult! {
        case .success(let language):
            return language
        case .failure(let error):
            throw error
        }
    }
    
}
