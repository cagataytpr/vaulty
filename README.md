# 🛡️ Vaulty - Cross-Platform Password Manager

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.19-%2302569B?logo=flutter)
![Windows](https://img.shields.io/badge/Windows-Support-%230078D6?logo=windows)
![Firebase](https://img.shields.io/badge/Firebase-Auth%20%26%20Firestore-%23FFCA28?logo=firebase)
![Dart](https://img.shields.io/badge/Dart-3.0-%230175C2?logo=dart)

**A journey into Security: From basic mobile app to a synchronized Cross-Platform tool.**

</div>

---

> 🎓 **Project Story & Evolution:**
> This project started as a standard password manager app, but it turned into a huge learning experience for me. Initially, I implemented a basic logic based on my early knowledge. However, **I didn't stop there.**
>
> I researched security standards and challenged myself to make this app work **everywhere**. I learned that my initial approach (local-only storage) wouldn't work for a user who wants to access their passwords on both their Phone and PC. **So, I refactored the entire core.** I learned about **Deterministic Key Derivation**, **Hashing**, and **Cross-Platform Architecture**. This project represents not just an app, but my growth as a developer understanding "Production-Grade" requirements.

---

## 💡 Motivation

As a Junior Developer, I wanted to challenge myself beyond simple UI/UX applications. I realized that handling user data requires responsibility. Vaulty became my sandbox to learn:
* **How to fail and fix:** Recognizing architectural flaws in my own code and refactoring them without fear.
* **Cryptography:** Understanding how to securely sync data between devices without exposing raw passwords.
* **Platform Specifics:** Handling Android's Biometrics and Windows' Window Management in the same codebase.

## 🛠️ Technical Highlights & The Refactor

### 🔒 Security & Architecture (The "Hard" Lessons)
In the first version, I used a simpler, local-only encryption. After deciding to support **Windows Desktop**, I upgraded the system to meet cross-platform standards:

* **Cross-Platform Sync:** I implemented a deterministic key derivation strategy (using `SHA-256`) that generates the same Encryption Key from the user's Master Password on any device. This allows you to encrypt on Mobile and decrypt on PC instantly.
* **Secure Storage:** Integrated `flutter_secure_storage` to use the device's hardware-backed security (Keystore on Android, Credential Locker on Windows).
* **Responsive Design:** The app adapts its layout intelligently—showing a simple list on mobile but expanding to a Grid View dashboard on Desktop.

### ⚡ Performance
I realized that decrypting multiple passwords could freeze the UI.
* **Solution:** I optimized the encryption logic and ensured heavy tasks don't block the main UI thread, keeping the app buttery smooth even on older devices.

## 📦 Tech Stack

* **Framework:** Flutter & Dart
* **Backend:** Firebase (Auth & Firestore)
* **Platforms:** Android, iOS, Windows
* **Security & Core:**
    * `flutter_secure_storage`: For Hardware-backed key storage.
    * `encrypt`: For AES encryption.
    * `crypto`: For SHA-256 Key Derivation.
    * `window_manager`: For Desktop window sizing and behavior.
    * `local_auth`: Biometrics (Fingerprint/FaceID).
* **State Management:** Provider
* **Localization:** l10n (Multi-language support)

## 🏁 Getting Started

### Prerequisites
* Flutter SDK (v3.10.3+)
* Firebase Project (`google-services.json` required)

### Installation

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/cagataytpr/vaulty.git](https://github.com/cagataytpr/vaulty.git)
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run the application:**
    * For Mobile: `flutter run`
    * For Windows: `flutter run -d windows`

## 🔮 Future Improvements (Roadmap)

I am constantly learning and upgrading this project. Next steps:
* [ ] **Unit Testing:** I want to write unit tests specifically for the new `EncryptionService`.
* [ ] **Password Generator:** Adding a customizable strong password generator tool.
* [x] **Desktop Support:** (Completed! ✅ Windows version is live).

---

<div align="center">

**Developed by Çağatay Tupur**
*A developer who believes that the best code comes from acknowledging mistakes and learning from them.*

</div>