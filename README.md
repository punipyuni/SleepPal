![animlogo](https://i.giphy.com/media/v1.Y2lkPTc5MGI3NjExZGY3a2Y3cmlxemZvbzJtanp0azMwejdxZGFzc3ZpZWx0emJlOXM1YSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/AsM8vRtVbQzzAAzX3Q/giphy.gif)

# SleepPal
SleepPal is an app designed to improve sleep quality by analyzing user behavior and promoting healthier sleep habits. It collects data from wearable devices to evaluate sleep duration, quality, and timing, generating a personalized sleep score. The app also assesses lifestyle factors like caffeine intake, exercise, and stress through AI-driven analysis, providing tailored recommendations for improvement. Key features include a SleepBot for guidance, relaxing sounds for stress relief, and bedtime notifications, all aimed at fostering better sleep routines and enhancing overall well-being.

## Table of Contents
* [SleepPal](https://github.com/punipyuni/SleepPal?tab=readme-ov-file#sleeppal)
* [Requirements](https://github.com/punipyuni/SleepPal?tab=readme-ov-file#requirements)
* [Technology Stack](https://github.com/punipyuni/SleepPal?tab=readme-ov-file#technology-stack)
* [Getting Start](https://github.com/punipyuni/SleepPal?tab=readme-ov-file#getting-start)

## Requirements
* Android Mobile Devices (API > 26)
* Health Connect Supported Smartwatches (eg. Fitbit, Samsung Health)

## Technology Stack
### AI Model
* nvidia/Llama-3.1-Nemotron-70B-Instruct-HF

### Front-End
* Flutter

### Back-End
* Node.js
* Express

### Database
* MongoDB Atlas

### Tools
* MongoDBCompass
* Postman

### 3rd-Party APIs
* OpenRouter
* Health Connect

## Features
### Core Features
* **Sleep Tracking:** Collect sleep data by using wearable devices such as smartwatch the sleep data contains Sleep duration, Sleep state, Time Asleep, Bedtime and Wake Up time. and use a research base to develop the sleep score algorithms to measure your sleep quality.
* **Behavior Analysis:** Use daily questionnaires of caffeine intake, weekly exercise and monthly stress questionnaires by using Perceived Stress Scale (PSS) to calculate Behavior Score to recommend for better behavior.

### Supporting Features
* **SleepBot:** Suggest users to develop healthy sleep habits. Provide educational resources on the importance of sleep, strategies for improving sleep quality and how to handle some of the sleep problems
* **Relaxing or ASMR Sounds:** Suggest users to develop healthy sleep habits. Provide educational resources on the importance of sleep, strategies for improving sleep quality and how to handle some of the sleep problems
* **Bedtime Reminder Notification:** Customize your notification time before sleep.
* **Late Sleeptime Notification:** Auto set the sleep time earlier for 1 hour to get the better sleep caution icon will show when your sleep time is more than 1 AM.
* **User Authentication:** Login/Sign up Authentication for accounts.

## Getting Start
### Setup Project
1. Install `Flutter` `Node` `VSCode` `Git`
> **Note:** You can use any Code Editor you prefer.
2. Cloning github or downloading the code from the [Releases](https://github.com/punipyuni/SleepPal/releases) to your local device.
3. Download [MongoDB Compass](https://www.mongodb.com/products/tools/compass) to connect to the database.
> **Note:** Create your own database cluster in MongoDB. Copy your database connection string to `backend/config/database.js` file to use the database.
4. Download [Android Studio](https://developer.android.com/studio) to use virtual device emulator.
> **Note:** You can use any virtual devices emulator you prefer.

### Backend Setup
1. Install dependencies `bcrypt`, `body-parser`, `express`, `jsonwebtoken`, `mongodb`, `mongoose`, and `nodemon`.
```bash
cd backend
```
```bash
npm install bcrypt body-parser express jsonwebtoken mongodb mongoose
```
* Install `nodemon` and setting up `npm run dev`.
```bash
npm install -D nodemon
```
* In `package.json` file.
```bash
...
"scripts": {
    "dev": "nodemon index.js"
  },
...
```
2. In `database.js` file. Change the database string to your database connection string.
```bash
const connection = mongoose.createConnection(`database connection string`).on('open', () => {
    console.log('MongoDB connected');
}).on('error', () => {
    console.log('MongoDB Connection error');
});
```
3. Setting up Port in `index.js`
```bash
const port = 3000;
```
> **Note:** You can use any port. The project default port is `3000`.

> If you do change the port, please change the url in the `const.dart` file

### Frontend Setup
1. Install Flutter dependencies.
```bash
flutter pub get
```
2. Change the port in the `const.dart` file to your port.
```bash
/// IP Address for API
final url = "http://localhost:3000";
```

### Running SleepPal
1. In `backend` folder, run `npm run dev`
```bash
cd backend
```
```bash
npm run dev
```
2. Select your virtual device or physical device.
3. Before running `main.dart`. Check the port of the device to the same port in the project.
```
adb reverse tcp:3000 tcp:3000
```
> **Note:** Change port to the same one you use inn the backend.
4. Run `main.dart` to run SleepPal.
```bash
flutter run
```
