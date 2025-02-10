//
//  TranslationSessionProviderFactoryTests.swift
//  TranslationKit
//
//  Created by James Wolfe on 05/02/2025.
//

import XCTest
@testable import TranslationKit

@available(iOS 18, *)
final class TranslationSessionProviderFactoryTests: XCTestCase {
    
    var subject: TranslationSessionProviderFactory!
    
    override func setUp() {
        super.setUp()
        subject = DefaultTranslationSessionProviderFactory<MockTranslationServiceProvider>()
    }
    
    override func tearDown() {
        subject = nil
        super.tearDown()
    }
    
    @MainActor
    func testSessionInitializesCorrectlyAndLanguagesAreCorrect() async throws {
        let testCases: [(Locale.Language?, Locale.Language?)] = [
            (TestData.germanLanguage, TestData.englishLanguage),
            (TestData.germanLanguage, TestData.nullLanguage),
            (TestData.nullLanguage, TestData.englishLanguage)
        ]
        
        for (source, target) in testCases {
            let sessionProvider = subject.sessionProvider(sourceLanguage: source, targetLanguage: target)
            let session = await sessionProvider.session()
            
            XCTAssertEqual(session.targetLanguage, target, "Expected target language \(String(describing: target)), but got \(String(describing: session.targetLanguage))")
        }
    }
}

@available(iOS 18, *)
extension TranslationSessionProviderFactoryTests {
    struct TestData {
        static let englishLanguage: Locale.Language? = Locale.Language(identifier: "en-gb")
        static let germanLanguage: Locale.Language? = Locale.Language(identifier: "de")
        static let nullLanguage: Locale.Language? = nil
    }
}
