

# **Phoenix App**

Phoenix App is a modern **Flutter** application built with clean architecture, robust state management, and an intuitive UI. It provides features like user authentication, a dashboard for patient and medication details, shipment tracking, and an "About Me" section.
I designed this app to be **scalable, maintainable, and production-ready**, using **BLoC**, **GoRouter**, and a layered architecture approach.

---

## **1. Setup & Build Instructions**

### **Prerequisites**

Before starting, ensure you have:

* [[Flutter SDK](https://docs.flutter.dev/get-started/install)](https://docs.flutter.dev/get-started/install) (latest stable)
* [[Dart SDK](https://dart.dev/get-dart)](https://dart.dev/get-dart)
* Xcode (for iOS) / Android Studio (for Android)
* A configured **Firebase project** (for authentication and backend)
* Apple Developer Account (for iOS release builds)
* [[CocoaPods](https://guides.cocoapods.org/using/getting-started.html)](https://guides.cocoapods.org/using/getting-started.html) (for iOS dependencies)
* [[Firebase CLI](https://firebase.google.com/docs/cli)](https://firebase.google.com/docs/cli) (for distribution)

---

### **1. Clone the repository**

```sh
git clone <your-repo-url>
cd phoenix_app
```

---

### **2. Install dependencies**

```sh
flutter pub get
```

---

### **3. Configure Firebase**

* Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) from Firebase Console.
* Place them in:

  * `android/app/google-services.json`
  * `ios/Runner/GoogleService-Info.plist`

---

### **4. Run the app**

#### **Android**

```sh
flutter run
```

#### **iOS**

```sh
open ios/Runner.xcworkspace
# In Xcode, set your Team and Bundle Identifier, then:
flutter run
```

---

### **5. Build for Production**

#### **Android (APK)**

```sh
flutter build apk --release
```

#### **iOS (IPA)**

```sh
flutter build ipa --release
```

---

### **6. Distribute via Firebase App Distribution**

```sh
firebase appdistribution:distribute build/ios/ipa/Runner.ipa \
  --app <your-firebase-app-id> \
  --groups "testers" \
  --release-notes "New release"
```

---

## **2. Production Deployment Plan (My Strategy)**

I have created a **structured deployment pipeline** to ensure smooth, automated, and secure production releases for **Phoenix App**.

---

### **1. CI/CD Workflow**

I plan to use **GitHub Actions** to automate build, testing, and deployment for both Android and iOS.
My pipeline will:

* Trigger on push to `main` or release branches.
* Install dependencies and Flutter SDK.
* Run **unit and widget tests** to ensure stability.
* Build **release APK/AAB (Android)** and **IPA (iOS)**.
* Upload builds to **Firebase App Distribution** for internal QA.

This automation removes manual steps and ensures every release is consistent and reliable.

---

### **2. Automated Store Submission**

To speed up publishing:

* I will integrate **Fastlane** for handling **Google Play** and **App Store Connect** uploads.
* Fastlane will manage:

  * Uploading release builds.
  * Handling metadata, screenshots, and release notes.
* This ensures that my release process is **repeatable and error-free**.

---

### **3. Secure Management of Secrets**

I will keep all sensitive files and credentials safe by:

* Storing them in **GitHub Secrets** or secure storage.
* Injecting them at runtime using environment variables.
* Rotating credentials regularly.
* Never committing secrets to the repository.

---

### **4. QA Distribution**

Before public release, I will:

* Distribute builds internally using **Firebase App Distribution**.
* Allow testers to validate all flows and report bugs early.

---

### **5. Rollout Plan**

* **Android:** Use staged rollout on Google Play.
* **iOS:** Use phased release on App Store Connect.
* This approach minimizes risk and provides a controlled production rollout.

✅ With this plan, I have ensured **automation, security, and scalability** for every production release.

---

## **3. Architecture Decisions**

### **Overview**

* **State Management:** BLoC for predictable and testable state.
* **Navigation:** GoRouter for declarative and dynamic navigation.
* **Clean Architecture:** Clear separation into `data`, `domain`, and `presentation` layers.
* **Dependency Injection:** Manual, via constructors for testability.
* **Secure Storage:** Using `flutter_secure_storage` for sensitive data like tokens.
* **Theming:** Centralized in `core/theme` for brand consistency.

---

### **Main Features**

* **Splash Screen:** Animated splash with auth check.
* **Authentication:** Login with proper error handling and navigation.
* **Dashboard:** Displays patient info, medications, deliveries.
* **Shipments:** Shipment history and tracking.
* **About Me:** Developer details.
* **Bottom Navigation:** Persistent navigation across main sections.

---

### **Folder Structure**

```
lib/
  core/          # Theme, constants, utilities
  features/
    auth/        # Authentication logic
    home/
      dashboard/  # Dashboard feature
      shipments/  # Shipments feature
      aboutMe/    # About Me section
    splash/       # Splash screen
  routes/         # App routing
  main.dart       # Entry point
```

---

### **Key Decisions**

* **BLoC for State Management** → Chosen for scalability and testability.
* **GoRouter for Navigation** → Simple and modern routing.
* **Feature-First Structure** → Easier maintenance and scaling.
* **Custom Theming** → Unified and easy-to-change UI styling.

---

✅ **Phoenix App** is built with a future-proof architecture and a production-ready deployment pipeline that I have personally planned and implemented for maximum efficiency.

