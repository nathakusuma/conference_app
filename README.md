# Conference App

A Flutter mobile application for the Conference Management System that allows users to browse, register for conferences, and manage their profiles. This app is the frontend for the [Conference API](https://github.com/nathakusuma/conference-backend).

## 📥 Download

Download the latest APK: [Conference App APK](https://drive.google.com/file/d/1EZYBZkVGJQ5HIgplEfanfM7KKuDZUHxh/view?usp=drive_link)

## 📱 Features

- **User Authentication**
    - Registration with email verification (OTP)
    - Login/logout functionality
    - Password reset with email verification

- **Conference Management**
    - Browse available conferences
    - Search and filter conferences by various criteria
    - View detailed conference information
    - Register for conferences
    - Track registered conferences

- **User Profile**
    - View and edit profile information

## 🛠️ Tech Stack

- **Framework**: Flutter
- **State Management**: Provider
- **HTTP Client**: Dio
- **Local Storage**: SharedPreferences
- **Date Formatting**: Intl
- **Dependency Injection**: Manual dependency injection
- **API Communication**: RESTful API calls

## 📦 Project Structure

The app follows clean architecture principles with separation of concerns:

- **Domain Layer**: Contains business logic, entities, and repository interfaces
- **Data Layer**: Implements repositories, handles API communication, and data models
- **Presentation Layer**: Contains UI screens and state management

## 🚀 Installation

### Prerequisites

- Flutter SDK (latest stable version)
- Android Studio or VS Code with Flutter plugins
- An Android device/emulator or iOS device/simulator

### Setup

1. Clone this repository and navigate to the project directory

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

## 📱 Usage

1. **Authentication**
    - Register with your email to create a new account
    - Verify your email with the OTP code sent to your inbox
    - Complete your profile with name and password
    - Login with your credentials

2. **Browse Conferences**
    - View all available conferences
    - Use filters to narrow down conferences by date, status, etc.
    - Search for conferences by title

3. **Conference Registration**
    - View detailed information about a conference
    - Register for a conference if seats are available
    - Check your registered conferences in the Registrations tab

4. **Profile Management**
    - View and edit your profile information
    - Update your name and bio
    - Logout from the application

## 🔗 API Integration

The app connects to the [Conference API](https://github.com/nathakusuma/conference-backend).
