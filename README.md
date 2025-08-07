# AI Note App 🚀

<p align="center">
  <img alt="License" src="https://img.shields.io/github/license/mueez007/AI-Note-App?style=for-the-badge">
  <img alt="Flutter" src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white">
  <img alt="Firebase" src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black">
</p>

An intelligent notes application built with Flutter and Firebase, designed to supercharge your productivity with Google's Gemini AI.

## ✨ Features

- **🔒 Secure Authentication:** Full user login and registration system using Firebase Authentication.
- **☁️ Cloud Firestore Sync:** All notes are saved and synced in real-time across devices.
- **🤖 Gemini AI Integration:**
    - **Summarize:** Automatically generate concise summaries of long notes.
    - **Professionalize:** Rewrite text to sound more polished and professional.
    - **Brainstorm:** Generate ideas from a simple prompt.
- **🎤 Voice-to-Text:** (Coming Soon) Dictate notes for a hands-free experience.
- **🖼️ AI Image Generation:** (Coming Soon) Create and attach unique images from text descriptions.
- **🌙 Modern UI:** A sleek, dark-themed interface modeled after popular note-taking apps.

## 🛠️ Tech Stack

| Technology      | Purpose                               |
| --------------- | ------------------------------------- |
| **Flutter** | Frontend & Cross-Platform UI          |
| **Firebase** | Authentication, Database, & Storage   |
| **Google AI** | Generative AI Text Features (Gemini)  |
| **VS Code** | Integrated Development Environment    |

## ⚙️ Setup and Installation

Follow these instructions to set up the project on your local machine.

1.  **Clone the Repository**
    ```sh
    git clone [https://github.com/mueez007/AI-Note-App.git](https://github.com/mueez007/AI-Note-App.git)
    cd AI-Note-App
    ```
2.  **Install Dependencies**
    ```sh
    flutter pub get
    ```
3.  **Connect to Firebase**
    Make sure you have a Firebase project created with Authentication and Firestore enabled.
    ```sh
    flutterfire configure
    ```
4.  **Add API Key**
    Create a `.env` file in the project root and add your Google AI API key.
    ```
    GEMINI_API_KEY="YOUR_SECRET_API_KEY"
    ```
5.  **Run the App**
    ```sh
    flutter run
    ```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
