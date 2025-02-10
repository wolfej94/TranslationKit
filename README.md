
# TranslationKit  

TranslationKit is a wrapper for the Swift Translation API, enabling offline translation and making translation functionality available outside of SwiftUI views. It works across all apps and architectures, providing a seamless way to integrate Apple's on-device translation capabilities.

## 🛠 Features  
✅ **Use Outside of SwiftUI** – Enables translation in any Swift-based app or service.  
✅ **Offline Translation** – Works without an internet connection using Apple's on-device translation API.  
✅ **Automatic Language Detection** – Detects the source language if not explicitly provided.  
✅ **Swift Concurrency Support** – Built with `async/await` for modern, non-blocking execution.  
✅ **Modular & Extendable** – Use default services or provide custom implementations.

---

## 📦 Installation  

### Swift Package Manager (SPM)  
1. Open Xcode and go to **File > Swift Packages > Add Package Dependency**.  
2. Enter the repository URL containing this package.  
3. Click **Add Package** and import it into your project:  
   ```swift
   import TranslationKit
   ```

---

## 🚨 Important Notes  

- **Window Scene Required**: TranslationKit requires your app to have a **window scene**, a **window**, and a **root view controller** for initialization. This makes it difficult to use within certain packages or environments that don't support this setup.  
- **Not Compatible with Background Tasks**: Since it relies on window scene access, it may not function correctly in scenarios where the app isn't in the foreground or doesn't have an active UI context.

---

## 🚀 Usage  

### Initialize the Service  
You can initialize TranslationKit with the default settings:  
```swift
let translationService = TranslationService()
```
This uses Apple’s built-in language recognition and translation session provider.

---

### 🌍 Translating Text  
To translate text, call the `translate` function asynchronously:  
```swift
let sourceText = "Hello, how are you?"
let targetLanguage: Locale.Language = .french

do {
    let response = try await translationService.translate(sourceText: sourceText, from: nil, to: targetLanguage)
    print("Translated Text: \(response.result)")
} catch {
    print("Translation failed: \(error)")
}
```
If `from` is `nil`, `TranslationKit` will automatically detect the source language.

---

## 🔗 Contributing  
Contributions are welcome! Feel free to submit a pull request or open an issue.  

---

## 📜 License  
TranslationKit is available under the MIT License. See the LICENSE file for more details.
