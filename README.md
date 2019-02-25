# PW Mini 2022 (Version 9.2.3)
App For Managing Homework

**[See the New Version, v10, Here](https://github.com/jamesbmadden/pwmini2022)**

## Install
```
git clone -b v9 https://github.com/jamesbmadden/pwmini2022
cd pwmini2022
pub get
```

Create a `lib/firebase/keys.dart` file with your firebase configuration object:
```dart
// lib/firebase/keys.dart

String apiKey = "...", 
authDomain = "...",
databaseURL = "...", 
projectId = "...", 
storageBucket = "...",
messagingSenderId = "...";
```

## Run
```
webdev serve
```