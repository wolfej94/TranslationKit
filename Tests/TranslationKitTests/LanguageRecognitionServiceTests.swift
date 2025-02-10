//
//  LanguageRecognitionServiceTests.swift
//  TranslationKit
//
//  Created by James Wolfe on 05/02/2025.
//

import XCTest
@testable import TranslationKit

@available(iOS 16, *)
final class LanguageRecognitionServiceTests: XCTestCase {
    
    var subject: LanguageRecognitionService!
    
    override func setUp() {
        super.setUp()
        subject = DefaultLanguageRecognitionService()
    }
    
    override func tearDown() {
        subject = nil
        super.tearDown()
    }
    
    func testTranslationSucceedsWithValidText() throws {
        let testCases = [
            (TestData.germanText, TestData.germanLanguage),
            (TestData.englishText, TestData.englishLanguage)
        ]
        
        for (text, expectedLanguage) in testCases {
            let result = try subject.recognizeLanguage(in: text)
            XCTAssertEqual(result, expectedLanguage, "Expected \(expectedLanguage) but got \(result) for text: \(text)")
        }
    }
    
    func testTranslationThrowsWithInvalidText() throws {
        do {
            _ = try subject.recognizeLanguage(in: TestData.nonsenseText)
            XCTFail("Expected error, but recognition succeeded")
        } catch {
            guard let error = error as? LanguageRecognitionError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            XCTAssertEqual(error, .failedToRecognizeSourceLanguage, "Expected .failedToRecognizeSourceLanguage but got \(error)")
        }
    }
}

@available(iOS 16, *)
extension LanguageRecognitionServiceTests {
    struct TestData {
        static let germanText = "Hallo, ich heiße John Doe und ich bin sechzig jahre alt."
        static let englishText = "Hello, my name is John Doe and I am sixty years old."
        static let nonsenseText = "123"
        static let englishLanguage = Locale.Language(identifier: "en")
        static let germanLanguage = Locale.Language(identifier: "de")
    }
}
