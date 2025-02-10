//
//  TranslationServiceTests.swift
//  TranslationKit
//
//  Created by James Wolfe on 05/02/2025.
//

import XCTest
import Translation
@testable import TranslationKit

@available(iOS 18, *)
final class TranslationServiceTests: XCTestCase {

    var session: MockTranslationKitSession!
    var languageRecognitionService: MockLanguageRecognitionService!
    var sessionProviderFactory: MockTranslationSessionProviderFactory!
    var subject: TranslationService!

    override func setUp() {
        super.setUp()
        session = MockTranslationKitSession()
        languageRecognitionService = MockLanguageRecognitionService()
        sessionProviderFactory = MockTranslationSessionProviderFactory()
        subject = TranslationService(
            languageRecognizer: languageRecognitionService,
            sessionProviderFactory: sessionProviderFactory
        )
    }

    override func tearDown() {
        session = nil
        languageRecognitionService = nil
        sessionProviderFactory = nil
        subject = nil
        super.tearDown()
    }

    @MainActor
    func testTranslationSucceedsWithValidInputs() async throws {
        // Arrange
        let testCases = [
            (TestData.germanText, TestData.englishText, TestData.germanLanguage, TestData.englishLanguage!),
            (TestData.germanText, TestData.englishText, nil, TestData.englishLanguage!),
            (TestData.englishText, TestData.germanText, TestData.englishLanguage, TestData.germanLanguage!)
        ]
        
        for (source, expectedResult, sourceLanguage, targetLanguage) in testCases {
            // Configure mocks
            languageRecognitionService.recognizeLanguageResult = .success(sourceLanguage ?? TestData.germanLanguage!)
            let configuration = TranslationSession.Configuration(source: sourceLanguage, target: targetLanguage)
            let sessionProvider = MockTranslationServiceProvider(configuration: configuration)
            sessionProviderFactory.sessionProviderToReturn = sessionProvider
            sessionProvider.sessionToReturn = session
            session.targetLanguage = targetLanguage
            session.translationResult = .success(expectedResult)

            // Act
            let result = try await subject.translate(sourceText: source, from: sourceLanguage, to: targetLanguage)

            // Assert
            XCTAssertEqual(result.result, expectedResult)
            XCTAssertEqual(result.targetLanguage, targetLanguage)
        }
    }

    @MainActor
    func testTranslationFailsWhenSourceLanguageIsNilAndLanguageRecognizerThrows() async throws {
        // Arrange
        languageRecognitionService.recognizeLanguageResult = .failure(TestError.generic)
        let configuration = TranslationSession.Configuration(source: nil, target: TestData.germanLanguage)
        let sessionProvider = MockTranslationServiceProvider(configuration: configuration)
        sessionProviderFactory.sessionProviderToReturn = sessionProvider
        sessionProvider.sessionToReturn = session
        
        // Act & Assert
        do {
            _ = try await subject.translate(sourceText: TestData.englishText, from: nil, to: TestData.germanLanguage!)
            XCTFail("Expected error, but translation succeeded")
        } catch {
            guard let error = error as? TestError else {
                XCTFail("Unexpected error type")
                return
            }
            XCTAssertEqual(error, TestError.generic)
        }
    }

    @MainActor
    func testTranslationSucceedsWhenSourceLanguageIsNotNilAndLanguageRecognizerThrows() async throws {
        // Arrange
        languageRecognitionService.recognizeLanguageResult = .failure(TestError.generic)
        let configuration = TranslationSession.Configuration(source: TestData.englishLanguage, target: TestData.germanLanguage)
        let sessionProvider = MockTranslationServiceProvider(configuration: configuration)
        sessionProviderFactory.sessionProviderToReturn = sessionProvider
        sessionProvider.sessionToReturn = session
        session.targetLanguage = TestData.germanLanguage
        session.translationResult = .success(TestData.germanText)

        // Act
        let result = try await subject.translate(sourceText: TestData.englishText,
                                                 from: TestData.englishLanguage,
                                                 to: TestData.germanLanguage!)

        // Assert
        XCTAssertEqual(result.result, TestData.germanText)
        XCTAssertEqual(result.targetLanguage, TestData.germanLanguage)
    }

    @MainActor
    func testTranslationFailsWhenTranslationSessionThrows() async throws {
        // Arrange
        languageRecognitionService.recognizeLanguageResult = .success(TestData.englishLanguage!)
        let configuration = TranslationSession.Configuration(source: TestData.englishLanguage, target: TestData.germanLanguage)
        let sessionProvider = MockTranslationServiceProvider(configuration: configuration)
        sessionProviderFactory.sessionProviderToReturn = sessionProvider
        sessionProvider.sessionToReturn = session
        session.targetLanguage = TestData.germanLanguage
        session.translationResult = .failure(TestError.generic)

        // Act & Assert
        do {
            _ = try await subject.translate(sourceText: TestData.englishText, from: nil, to: TestData.germanLanguage!)
            XCTFail("Expected error, but translation succeeded")
        } catch {
            guard let error = error as? TranslationKit.TranslationError else {
                XCTFail("Unexpected error type")
                return
            }
            let expectedErrorDescription = TranslationError.translationFailed(error.localizedDescription).localizedDescription
            XCTAssertEqual(error.localizedDescription, expectedErrorDescription)
        }
    }
}

@available(iOS 18, *)
extension TranslationServiceTests {
    struct TestData {
        static let germanText = "Hallo, ich heiße John Doe und ich bin sechzig jahre alt."
        static let englishText = "Hello, my name is John Doe and I am sixty years old."
        static let englishLanguage: Locale.Language? = Locale.Language(identifier: "en-gb")
        static let germanLanguage: Locale.Language? = Locale.Language(identifier: "de")
    }

    enum TestError: Error {
        case generic
    }
}
