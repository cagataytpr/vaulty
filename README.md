# 🛡️ Vaulty - Personal Password Manager Project

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.10.3-%2302569B?logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-Auth%20%26%20Firestore-%23FFCA28?logo=firebase)
![Dart](https://img.shields.io/badge/Dart-3.0-%230175C2?logo=dart)

**A robust mobile security research project focusing on Encryption, Clean Architecture, and Performance.**

</div>

---

> 🎓 **About This Project:**
> This application was developed as a **technical research project** to explore advanced mobile security standards and Flutter architecture patterns. While it implements industry-standard AES encryption, its primary goal is to demonstrate **Clean Architecture (MVVM)**, **Secure Storage practices**, and **Background Isolates** in a realistic scenario.

---

## 💡 Motivation

As a Mobile Developer, I wanted to go beyond simple UI apps and tackle the challenges of handling sensitive user data securely. Vaulty is the result of my deep dive into:
* **Cryptography:** How to properly implement AES-256 with randomized Initialization Vectors (IV).
* **Performance:** How to handle heavy computations without freezing the UI.
* **Architecture:** How to structure a scalable app using MVVM and Provider.

## 🛠️ Technical Highlights

### 🔒 Security Implementation
Instead of relying on basic storage, I implemented a custom encryption layer:
* **AES-256 Encryption:** Used `encrypt` package with custom logic.
* **Randomized IVs:** Each password is encrypted with a unique, randomly generated Initialization Vector (IV) to prevent pattern analysis attacks.
* **Biometric Auth:** Integrated `local_auth` for Fingerprint/FaceID verification before accessing the vault.
* **Auto-Lock:** Implemented `WidgetsBindingObserver` to detect when the app goes to the background and lock the session immediately.

### ⚡ Performance Optimization (Isolates)
Decrypting hundreds of passwords to analyze security risks (reused/weak passwords) is CPU-intensive.
* **Problem:** Running this on the main thread caused UI "jank" (freezing).
* **Solution:** I moved the audit logic to a separate thread using Flutter's **`compute` (Isolate)** function. This keeps the UI running at 60 FPS while heavy calculations happen in the background.

### 🏗️ Architecture (MVVM)
I followed strict separation of concerns to make the code testable and readable:
* **Data Layer:** Repositories (`PasswordRepository`) and Services (`EncryptionService`, `AuthService`).
* **ViewModel Layer:** `HomeViewModel` manages state and business logic, decoupling the UI from data operations.
* **View Layer:** Dumb widgets that only react to state changes.

## 📦 Tech Stack

* **Framework:** Flutter & Dart
* **Backend:** Firebase (Auth & Firestore)
* **State Management:** Provider
* **Key Packages:**
    * `encrypt`: Cryptography.
    * `local_auth`: Biometrics.
    * `flutter_windowmanager`: Prevent screenshots (Android).
    * `shared_preferences`: Local settings.
    * `flutter_localizations`: Multi-language support.

## 📸 Screenshots

| Login & Auth | Secure Vault | Security Analysis |
|:---:|:---:|:---:|
| *(Coming Soon)* | *(Coming Soon)* | *(Coming Soon)* |

## 🏁 Getting Started

### Prerequisites
* Flutter SDK (v3.10.3+)
* Dart SDK (v3.0+)
* Firebase Project (google-services.json required)

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
    ```bash
    flutter run
    ```

## 🔮 Future Improvements (Roadmap)

To make this app production-ready, I plan to implement:
* [ ] **Master Password Derivation:** Generating encryption keys from a user input using PBKDF2/Argon2 (currently using a simpler key exchange for demonstration).
* [ ] **Unit Testing:** Adding comprehensive tests for the Encryption Service and ViewModels.
* [ ] **Cross-Platform:** Extending biometric support to iOS and Desktop.

---

<div align="center">

**Developed by Çağatay Tupur**
*Passionate about building secure and performant mobile apps.*

</div>