# TuneStream 🎧

**TuneStream** is a beautiful, feature-rich music streaming application built entirely with Flutter. Inspired by modern music apps, it provides a seamless user experience with a unique UI, robust session management, and personalized features. This project showcases a complete, production-ready mobile application architecture using BLoC for state management and Firebase for backend services.

 
Video Demo: https://drive.google.com/file/d/1ANZHqlokarzt9hFOyQMn-VGomuBykxws/view?usp=sharing

---

## ✨ Features

This app is packed with features that make it a complete music streaming experience:

*   **🎧 Core Music Player:**
    *   **Background Playback:** Listen to music even when the app is minimized or the screen is off.
    *   **Notification Controls:** Control your music (play, pause, next, previous) directly from the system notification and lock screen.
    *   **Seamless Streaming:** Audio is streamed from Firebase Hosting, with a flawless marquee effect for long song titles.

*   **👤 User & Session Management:**
    *   **Full Authentication:** Secure sign-up and sign-in with Email/Password.
    *   **Google Sign-In:** One-tap sign-in using Google accounts.
    *   **Guest Mode:** Allow users to explore the app and listen to music without creating an account.
    *   **Session Persistence:** Users stay logged in across app restarts.

*   **🎶 Personalized Music Experience:**
    *   **Like Songs:** Users can like their favorite songs, which are saved to their profile.
    *   **Custom Playlists:** Create, view, and manage personal playlists. Add or remove songs with ease.
    *   **Listening History:** Every song played is logged to the user's profile for easy access.
    *   **"For You" Recommendations:** A dedicated section with:
        *   **Trending Songs:** Based on total play counts across all users.
        *   **Personalized Suggestions:** Recommends songs from the same genre as the currently playing track.

*   **📱 Modern & Dynamic UI:**
    *   **Unique "Aurora Neumorphism" Design:** A beautiful, custom UI that stands out.
    *   **Light & Dark Mode:** A theme-switcher button allows users to toggle between light and dark modes instantly.
    *   **Dynamic UI Elements:** User avatars with initials, animated titles, and responsive layouts.
    *   **Lottie Animations:** Smooth, high-quality animations enhance the user experience.

*   **🔍 Music Discovery:**
    *   **Search:** Quickly find songs, albums, or artists.
    *   **Genre Filtering:** Tap a genre tag to instantly filter the song list.

*   **🤖 AI Integration:**
    *   **Gemini Chatbot:** An integrated chatbot that can answer questions about the currently playing song.

---

## 🛠️ Tech Stack & Architecture

*   **Framework:** [Flutter](https://flutter.dev/)
*   **Architecture:** Feature-first approach
*   **State Management:** [BLoC (Business Logic Component)](https://bloclibrary.dev/)
*   **Backend & Database:** [Firebase](https://firebase.google.com/)
    *   **Firebase Authentication:** For user management.
    *   **Firestore Database:** For storing song metadata, playlists, likes, and history.
    *   **Firebase Hosting:** For hosting and streaming all audio files via a global CDN.
*   **Audio Playback:** [audio_service](https://pub.dev/packages/audio_service) & [just_audio](https://pub.dev/packages/just_audio) for robust background audio and notifications.
*   **AI:** [Google Gemini API](https://ai.google.dev/)
*   **Testing:**
    *   **Unit Tests:** For business logic in repositories.
    *   **Widget Tests:** For UI component rendering.
    *   **Golden Tests:** For visual regression testing.
    *   **Libraries:** `mockito`, `bloc_test`.

