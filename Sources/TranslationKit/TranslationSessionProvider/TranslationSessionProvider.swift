//
//  TranslationSessionProvider.swift
//  TranslationKit
//
//  Created by James Wolfe on 04/02/2025.
//

import SwiftUI
import Translation

@available(iOS 18, *)
internal protocol TranslationSessionProvider: Sendable {
    @MainActor init(configuration: TranslationSession.Configuration)
    func session() async -> TranslationKitSession
    
    @MainActor
    func endSession() async
}

@available(iOS 18, *)
internal struct DefaultTranslationSessionProvider: TranslationSessionProvider, View {
    
    private let configuration: TranslationSession.Configuration
    private let window: UIWindow
    private let sessionManager = SessionManager() // Manages the hosting controller and session

    @MainActor
    init(configuration: TranslationSession.Configuration) {
        self.configuration = configuration
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            self.window = scene.windows.first!
        } else {
            fatalError("Could not detect view hierarchy")
        }
    }

    @MainActor
    init(configuration: TranslationSession.Configuration, window: UIWindow) {
        self.configuration = configuration
        self.window = window
    }

    var body: some View {
        EmptyView()
            .translationTask(configuration) { session in
                Task {
                    await sessionManager.resumeSession(with: session)
                }
            }
    }

    func session() async -> TranslationKitSession {
        return await withCheckedContinuation { continuation in
            Task {
                await sessionManager.storeContinuation(continuation)
            }
            DispatchQueue.main.async {
                let hostingViewController = UIHostingController(rootView: self)
                hostingViewController.view.frame = .zero
                hostingViewController.view.backgroundColor = .clear
                window.rootViewController?.addChild(hostingViewController)
                window.rootViewController?.view.addSubview(hostingViewController.view)

                Task {
                    await sessionManager.storeHostingController(hostingViewController)
                }
            }
        }
    }

    @MainActor
    func endSession() async {
        if let hostingVC = await sessionManager.getHostingController() {
            hostingVC.view.removeFromSuperview()
            hostingVC.removeFromParent()
            await sessionManager.clearHostingController()
        }
    }
}

/// **Actor to Manage the Hosting Controller and Session Safely**
@available(iOS 18, *)
private actor SessionManager {
    private var hostingViewController: UIHostingController<DefaultTranslationSessionProvider>?
    private var continuation: CheckedContinuation<TranslationKitSession, Never>?

    func storeHostingController(_ controller: UIHostingController<DefaultTranslationSessionProvider>) {
        self.hostingViewController = controller
    }

    func getHostingController() -> UIHostingController<DefaultTranslationSessionProvider>? {
        return hostingViewController
    }

    func clearHostingController() {
        hostingViewController = nil
    }

    func storeContinuation(_ newContinuation: CheckedContinuation<TranslationKitSession, Never>) {
        continuation = newContinuation
    }

    func resumeSession(with session: TranslationSession) {
        continuation?.resume(returning: DefaultTranslationKitSession(from: session))
        continuation = nil
    }
}

@available(iOS 18, *)
extension TranslationSession: @unchecked @retroactive Sendable {}
