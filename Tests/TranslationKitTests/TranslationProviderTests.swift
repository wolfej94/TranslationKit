//
//  TranslationProviderTests.swift
//  TranslationKit
//
//  Created by James Wolfe on 05/02/2025.
//

import XCTest
import UIKit
import Translation
@testable import TranslationKit

@available(iOS 18, *)
final class TranslationProviderTests: XCTestCase, @unchecked Sendable {
    
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()
        DispatchQueue.main.async {
            self.window = UIWindow()
            self.window.rootViewController = UIViewController()
            self.window.makeKeyAndVisible()
        }
    }
    
    override func tearDown() {
        window = nil
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
            let configuration = TranslationSession.Configuration(source: source, target: target)
            let subject = DefaultTranslationSessionProvider(configuration: configuration, window: window)
            let session = await subject.session()
            
            XCTAssertEqual(session.targetLanguage, target, "Expected target language \(String(describing: target)), but got \(String(describing: session.targetLanguage))")
        }
    }
}

@available(iOS 18, *)
extension TranslationProviderTests {
    struct TestData {
        static let englishLanguage: Locale.Language? = Locale.Language(identifier: "en-gb")
        static let germanLanguage: Locale.Language? = Locale.Language(identifier: "de")
        static let nullLanguage: Locale.Language? = nil
    }
}
