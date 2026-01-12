# 🛡️ Vaulty - Secure Password Manager

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.10.3-%2302569B?logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-Auth%20%26%20Firestore-%23FFCA28?logo=firebase)
![Dart](https://img.shields.io/badge/Dart-3.0-%230175C2?logo=dart)

**Next-Gen Security, Minimalist Design, Absolute Control.**

</div>

## 🚀 Introduction

**Vaulty** is a robust, cross-platform password management solution developed with **Flutter**. It is designed to provide a secure and seamless experience for storing credentials, generating strong passwords, and analyzing account security.

This project was conceived and developed by a **Junior Mobile Developer** as a comprehensive research initiative. The primary goal was to explore advanced mobile security standards, implement **Clean Architecture (MVVM)**, and master the integration of biometric authentication systems in a production-ready environment.

Every line of code in Vaulty is the result of deep research into encryption algorithms (AES), state management patterns (Provider), and secure data handling practices.

## ✨ Key Features

### 🔒 Uncompromising Security
* **AES-256 Encryption:** All passwords are encrypted locally before being transmitted to the cloud, ensuring that even the database administrators cannot access user data.
* **Biometric Authentication:** Integrated Fingerprint and FaceID support for quick and secure access (`local_auth`).
* **Strict Verification:** Access to the vault is strictly blocked for users with unverified email addresses to prevent unauthorized account creation.
* **Auto-Lock Mechanism:** The app automatically locks itself after 1 minute of inactivity or when moved to the background, requiring biometric re-authentication.
* **Clipboard Security:** Copied passwords are automatically cleared from the clipboard after 45 seconds to prevent accidental leaks.

### 🛠️ Functionality & Tools
* **Password Generator:** Built-in tool to generate cryptographically strong passwords with customizable length and character sets.
* **Security Analysis Report:** Real-time auditing of stored passwords to identify weak or reused credentials, providing users with actionable security insights.
* **PDF Export:** Securely export all credentials to a PDF file for offline backup, protected by biometric confirmation.
* **Localization (l10n):** Full multi-language support (English & Turkish) utilizing Flutter's official localization package.

## 🏗️ Architecture

The project follows the **MVVM (Model-View-ViewModel)** architectural pattern to ensure separation of concerns, testability, and scalability.

* **Core:** Contains shared resources, constants, and utilities.
* **Data Layer:** Handles data sources (Firestore), repositories, and services (Auth, Encryption).
    * *Repository Pattern:* `PasswordRepository` acts as a single source of truth, abstracting data fetching and encryption logic.
* **View Models:** `HomeViewModel` and `LocaleViewModel` manage the UI state and business logic, decoupling the UI from data operations.
* **Views:** UI components and screens that react to state changes provided by ViewModels.

## 📦 Tech Stack

* **Framework:** Flutter & Dart
* **Backend:** Firebase (Authentication, Cloud Firestore)
* **State Management:** Provider
* **Security:**
    * `encrypt`: For AES encryption.
    * `local_auth`: For biometric verification.
    * `flutter_windowmanager`: For preventing screenshots (Android).
* **Utilities:**
    * `pdf`: For generating backup documents.
    * `shared_preferences`: For persisting local settings (Theme, Language).
    * `flutter_localizations`: For internationalization.

## 📸 Screenshots

| Login Screen | Vault (Home) | Generator | Settings |
|:---:|:---:|:---:|:---:|
| *(Coming Soon)* | *(Coming Soon)* | *(Coming Soon)* | *(Coming Soon)* |

## 🏁 Getting Started

### Prerequisites
* Flutter SDK (v3.10.3 or higher)
* Dart SDK (v3.0 or higher)
* Firebase Project Setup (GoogleService-Info.plist / google-services.json)

### Installation

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/cagataytpr/vaulty.git](https://github.com/cagataytpr/vaulty.git)
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Generate localization files:**
    ```bash
    flutter gen-l10n
    ```
4.  **Run the application:**
    ```bash
    flutter run
    ```

## 🔮 Future Roadmap

* [ ] **Cloud Sync Conflict Resolution:** Improved handling for multi-device synchronization.
* [ ] **Cross-Platform Desktop Support:** Extending biometric support to Windows and macOS builds.
* [ ] **Password Breach Detection:** Integration with "Have I Been Pwned" API.
* [ ] **Unit & Widget Tests:** Increasing test coverage for critical business logic.

---

<div align="center">

**Developed with ❤️ and ☕ by Çağatay Tupur**

*Open to feedback and collaboration opportunities.*

</div>