<!-- We Chat README -->

<h1 align="center">We Chat 💬</h1>
<h3 align="center">A modern, encrypted Flutter chat app with a dark-glass UI, built for seamless communication</h3>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?&logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/Dart-%230175C2.svg?&logo=dart&logoColor=white"/>
  <img src="https://img.shields.io/badge/Architecture-Clean--BLoC-success"/>
  <img src="https://img.shields.io/badge/Status-In%20Progress-orange"/>
</p>

---

### 🧠 Overview

**We Chat** is a real-time, end-to-end encrypted messaging app with a sleek **dark-themed, blur-glass UI**. It focuses on **modern Flutter development practices** with **BLoC**, **clean architecture**, and **responsive layouts** using `Get.height` and `Get.width`.

Built from the ground up with performance and scalability in mind.

---

### ✨ Features

- 🔐 **Google Login** with Firebase Auth  
- 💬 **Real-Time Chat** using Firebase Firestore  
- 👤 **Profile Setup** (Image, Name, Bio)  
- 🧊 **Glassmorphism & Blur UI**  
- ⚙️ **Clean Architecture + BLoC Pattern**  
- 📱 Fully Responsive UI (GetX dimensions)  
- 🎨 **Lottie Animations** for smooth transitions  
- ✅ Reusable Widgets & Form Validations  
- 🔐 Ready for **End-to-End Encryption** (modular logic separation)

---

### 📸 Screens Preview

| Splash Screen | Auth Page | Profile Setup | Chat UI |
|---------------|-----------|----------------|---------|
| ![](screens/splash.png) | ![](screens/auth.png) | ![](screens/setup.png) | ![](screens/chat.png) |

---

### 🏗️ Project Structure

```bash
lib/
├── core/                 # AppColors, Fonts, Constants, Utils
├── data/                 # Models, Firebase Services
├── logic/                # BLoCs, Cubits
├── presentation/
│   ├── screens/          # UI Screens
│   ├── widgets/          # Reusable UI Widgets
│   └── animations/       # Lottie Animations
├── repository/           # Interface Abstractions
├── app.dart              # Root Widget
└── main.dart             # Entry Point
