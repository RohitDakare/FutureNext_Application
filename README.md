# FutureNext | AI Career Guidance Platform

FutureNext is a comprehensive AI-powered career counseling platform. It features a **NestJS Backend**, a **Next.js Frontend**, and a **Flutter Mobile App**. 🧭

## 🚀 Overview
- **AI Guidance**: Uses Google Gemini to generate dynamic MCQ questions and personalized career reports.
- **RIASEC Model**: Built on the Holland Code (RIASEC) interest model to match students with the best-fit careers.
- **Full Stack**: Features a robust REST API, a premium glassmorphic web dashboard, and a sleek mobile experience.

## 🛠 Tech Stack
- **Backend**: NestJS, Prisma ORM, PostgreSQL (via Supabase), Google Gemini SDK.
- **Frontend**: Next.js 15+, React 19, Vanilla CSS (Premium Glassmorphism).
- **Mobile**: Flutter, Dart, SharedPreferences, http.

## 📦 Project Structure
- `/backend`: NestJS source code and Prisma schema.
- `/frontend`: Next.js web application.
- `/lib`: Flutter mobile source code (root level).

## 🚀 Deployment
To deploy this project for public use, follow our **[Deployment Guide](./deployment_guide.md)** which covers:
1.  **Database**: Setting up Supabase.
2.  **Backend**: Hosting on Render.
3.  **Frontend**: Hosting on Vercel.
4.  **Mobile**: Building for Google Play Store.

## 🛠 Local Setup

### Backend
1. `cd backend`
2. `npm install`
3. Configure `.env` with `DATABASE_URL` and `GEMINI_API_KEY`.
4. `npx prisma db push`
5. `npm run start:dev`

### Frontend
1. `cd frontend`
2. `npm install`
3. `npm run dev`

### Mobile
1. Ensure Flutter is installed.
2. `flutter pub get`
3. `flutter run`

## 📄 License
This project is licensed under the MIT License.
