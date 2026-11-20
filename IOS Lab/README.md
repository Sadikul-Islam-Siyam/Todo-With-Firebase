# Daylist — Firebase Todo App

A small SwiftUI Todo app built on the supplied **IOS Lab** Xcode starter project.

## Features
- Create an account and log in with email/password (Firebase Authentication).
- Add tasks, mark them complete, and delete them.
- Store tasks in Cloud Firestore, separated by Firebase user ID.
- Listen for Firestore updates so changes appear in the app automatically.

## Project configuration
- Xcode project: `IOS Lab.xcodeproj`
- App target: `IOS Lab`
- Bundle Identifier: `Rb.IOS-Lab`
- Swift version: 5.0
- Firebase Swift Package: `https://github.com/firebase/firebase-ios-sdk.git`
- Firebase products: FirebaseCore, FirebaseAuth, FirebaseFirestore

The provided `GoogleService-Info.plist` is already placed inside the app's source folder. Keep its target membership enabled if Xcode asks.

## Firebase Console setup
1. Open the Firebase project that produced the supplied plist.
2. In **Authentication → Sign-in method**, enable **Email/Password**.
3. Create a **Cloud Firestore** database.
4. In Firestore Rules, publish the contents of `firestore.rules` from this folder.
5. Confirm the registered iOS app's bundle ID is exactly `Rb.IOS-Lab`.

## Run in Xcode
1. Open `IOS Lab.xcodeproj` in Xcode.
2. Wait for Xcode to resolve the Firebase Swift Package dependencies. The project already declares FirebaseCore, FirebaseAuth, and FirebaseFirestore.
3. Select an iPhone simulator or a connected device and the `IOS Lab` scheme.
4. Build and run. Create an account from the first screen, then add tasks.

If package resolution fails, check the VM's internet access and retry **File → Packages → Resolve Package Versions**.

## Firestore data structure

```text
users
  └── <Firebase Auth UID>
       └── tasks
            └── <task document>
                 ├── title: String
                 ├── isCompleted: Bool
                 └── createdAt: Timestamp
```

Each signed-in user can access only their own task documents under the included Firestore rules.

## Notes
- This project was prepared from the uploaded starter project and plist.
- Firebase package resolution and an actual Xcode simulator/device build must be completed in your macOS VM; this environment cannot run Xcode.
