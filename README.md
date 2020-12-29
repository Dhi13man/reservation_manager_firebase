# Firebase Reservation Manger

This is a Reservation Management App project made in an attempt to learn how to utilize Firebase in a short period of time.
Download App from Releases: 

## Getting Started

This repository holds the code for a Reservation Management App that can be utilized by Hotels, Restaurants etc.

The app utilizes Firebase as a backend for Authentication and Real Time Database implementation, which the app works around.

1. Utilizes [Firebase](https://www.firebase.com) for a database that works across platforms

2. Utilizes [bloc](https://pub.dev/packages/bloc) + [Provider](https://pub.dev/packages/provider) based State Management Architecture.

3. Utilizes [Material Design](https://material.io/develop/flutter) elements for UI building, as well as various other Open Source Packages as [listed below](#dependencies-used).

## Features

1. Firebase based Google and Email Authentication
2. Real-Time dynamic database for reservations.
3. Light and Dark Themes (toggleable by tapping icon)

## Screenshots

Authentication Screen(Light): | Authentication Screen(Dark):
----------------|----------------------------
[<img height="600" width="350" src="https://raw.githubusercontent.com/Dhi13man/reservation_manager_firebase/main/Screenshots/authL.jpg" alt="Authentication Screen(Light)">](https://raw.githubusercontent.com/Dhi13man/SafeSyncIoT/main/Screenshots/authL.jpg) | [<img height="600" width="350" src="https://raw.githubusercontent.com/Dhi13man/reservation_manager_firebase/main/Screenshots/authD.jpg" alt="Authentication Screen(Dark)">](https://raw.githubusercontent.com/Dhi13man/reservation_manager_firebase/main/Screenshots/authD.jpg)

Reservation List Screen(Light): | Reservation List Screen(Dark):
--------------------------------------|----------------------
[<img height="600" width="350" src="https://raw.githubusercontent.com/Dhi13man/reservation_manager_firebase/main/Screenshots/reserveL.jpg" alt="Reservation List Screen(Light)">](https://raw.githubusercontent.com/Dhi13man/reservation_manager_firebase/main/Screenshots/reserveL.jpg) | [<img height="600" width="350" src="https://raw.githubusercontent.com/Dhi13man/reservation_manager_firebase/main/Screenshots/reserveD.jpg" alt="Reservation List Screen(Dark)">](https://raw.githubusercontent.com/Dhi13man/reservation_manager_firebase/main/Screenshots/reserveD.jpg)

Add Reservation Screen(Light): | Add Reservation Screen(Dark):
--------------------------------------|----------------------
[<img height="600" width="350" src="https://raw.githubusercontent.com/Dhi13man/reservation_manager_firebase/main/Screenshots/addL.jpg" alt="Add Reservation Screen(Light)">](https://raw.githubusercontent.com/Dhi13man/reservation_manager_firebase/main/Screenshots/addL.jpg) | [<img height="600" width="350" src="https://raw.githubusercontent.com/Dhi13man/reservation_manager_firebase/main/Screenshots/addD.jpg" alt="Add Reservation Screen(Dark)">](https://raw.githubusercontent.com/Dhi13man/reservation_manager_firebase/main/Screenshots/addD.jpg)

Reservation Screen Landscape:|
------------------------------|
[<img height="300" width="600" src="https://raw.githubusercontent.com/Dhi13man/reservation_manager_firebase/main/Screenshots/reserveLand.jpg" alt="Reservation Screen Landscape">](https://raw.githubusercontent.com/Dhi13man/reservation_manager_firebase/main/Screenshots/reserveLand.jpg) |

## Dependencies Used

1. [material](https://material.io/develop/flutter) for UI

2. [cupertino](https://flutter.dev/docs/development/ui/widgets/cupertino) and [cupertino_icons](https://pub.dev/packages/cupertino_icons) for UI

3. [simple_animations](https://pub.dev/packages/simple_animations) for UI animations

4. [page_transition](https://pub.dev/packages/page_transition) for page transition animations

5. [firebase_core](https://pub.dev/packages/firebase_core) and supporting Libraries for Cross Platform Authentication and Database backend
    1. [firebase_auth](https://pub.dev/packages/firebase_auth) for Firebase Authentication System interfacing
    2. [cloud_firestore](https://pub.dev/packages/cloud_firestore) for Firebase Firestore interfacing

6. [google_sign_in](https://pub.dev/packages/google_sign_in) for Google Sign in using Firebase

7. [bloc](https://pub.dev/packages/bloc) and [flutter_bloc](https://pub.dev/packages/flutter_bloc) for State Management
   1. [equatable](https://pub.dev/packages/equatable) for debugging blocs and proper state tracking

8. [provider](https://pub.dev/packages/provider) for less intensive State Management

9. [shared_preferences](https://pub.dev/packages/shared_preferences) for storing simple data locally

10. [flutter_form_builder](https://pub.dev/packages/flutter_form_builder) for easily building forms for Authentication and Database editing front end
