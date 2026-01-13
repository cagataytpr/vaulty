# 🛡️ Vaulty - Personal Password Manager Project

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.10.3-%2302569B?logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-Auth%20%26%20Firestore-%23FFCA28?logo=firebase)
![Dart](https://img.shields.io/badge/Dart-3.0-%230175C2?logo=dart)

**A journey into Mobile Security: From basic implementation to Industry-Standard Encryption.**

</div>

---

> 🎓 **Project Story & Evolution:**
> This project started as a standard password manager, but it turned into a huge learning experience. Initially, I implemented a basic encryption logic based on my early knowledge. However, **I didn't stop there.**
>
> I researched mobile security standards and used AI tools to audit my own code. I learned that my initial approach (using static keys or simple hashing) was vulnerable. **So, I refactored the entire core.** I learned about **PBKDF2**, **Salting**, and **Secure Storage**, and implemented them to replace the old logic. This project represents not just an app, but my growth as a developer understanding "Production-Grade" security.

---

## 💡 Motivation

As a Junior Mobile Developer, I wanted to challenge myself beyond simple UI/UX applications. I realized that handling user data requires responsibility. Vaulty became my sandbox to learn:
* **How to fail and fix:** Recognizing security flaws in my own code and fixing them.
* **Cryptography:** Understanding why `SHA-256` isn't enough for passwords and why we need `PBKDF2`.
* **Performance:** How to decrypt data without freezing the UI using Isolates.

## 🛠️ Technical Highlights & The Refactor

### 🔒 Security (The "Hard" Lessons)
In the first version, I used a simpler logic. After my research, I upgraded the system to meet industry standards:

* **Key Derivation (PBKDF2):** I learned that simple hashing is vulnerable to brute-force attacks. I switched to **PBKDF2-HMAC-SHA256** with **10,000 iterations** to derive encryption keys, making it computationally expensive for attackers to crack.
* **Salting & Random IVs:** To prevent "Rainbow Table" attacks, I now generate a unique **Salt** and **Initialization Vector (IV)** for every single password.
* **Secure Storage:** Instead of keeping sensitive keys in memory or basic preferences, I integrated `flutter_secure_storage` to use the device's hardware-backed security (Keystore/Keychain).
* **Memory Hygiene:** Implemented a session manager that wipes the master key from RAM when the app goes to the background.

### ⚡ Performance (Isolates)
I realized that decrypting multiple passwords for the "Security Audit" feature was dropping the FPS.
* **Solution:** I moved the audit logic to a separate thread using Flutter's **`compute`** function. This keeps the UI buttery smooth while heavy calculations happen in the background.

### 🏗️ Architecture (MVVM)
I followed strict separation of concerns to make the code testable and readable:
* **Data Layer:** Repositories and Services (Encryption, Auth, SecureStorage).
* **ViewModel Layer:** Manages state and holds the "Session" logic safely.
* **View Layer:** Reactive UI components.

## 📦 Tech Stack

* **Framework:** Flutter & Dart
* **Backend:** Firebase (Auth & Firestore)
* **Security:**
    * `flutter_secure_storage`: For Hardware-backed key storage.
    * `encrypt`: For AES encryption.
    * `pointycastle` (via custom logic): For PBKDF2 Key Derivation.
    * `local_auth`: Biometrics.
* **State Management:** Provider

## 🏁 Getting Started

### Prerequisites
* Flutter SDK (v3.10.3+)
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

I am constantly learning and upgrading this project. Next steps:
* [ ] **Unit Testing:** I want to write unit tests specifically for the new `EncryptionService` to ensure no regression happens.
* [ ] **Desktop Support:** Exploring Flutter for Windows/MacOS to make Vaulty cross-platform.

---

<div align="center">

**Developed by Çağatay Tupur**
*A developer who believes that the best code comes from acknowledging mistakes and learning from them.*

</div>