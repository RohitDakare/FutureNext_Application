# Career Compass Backend

Career Compass is a FastAPI-based backend for an AI-powered career guidance platform. It provides RESTful APIs for user authentication, career path recommendations, and skill gap analysis using Google Gemini.

## Features

- **User Authentication**: Secure user registration and login with JWT-based authentication
- **Career Recommendations**: AI-powered career path suggestions based on user interests and skills
- **Skill Gap Analysis**: Identify skill gaps and recommend learning resources
- **Database Integration**: PostgreSQL database with SQLAlchemy ORM
- **AI Integration**: Google Gemini API for intelligent career guidance

## Prerequisites

- Python 3.8+
- PostgreSQL 13+
- Google Gemini API Key

## Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd backend
   ```

2. Create a virtual environment:
   ```bash
   python -m venv venv
   venv\Scripts\activate
   ```

3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

4. Configure environment variables:
   Create a `.env` file in the `backend` directory with the following variables:
   ```env
   DATABASE_URL=postgresql://user:password@host:port/database
   GEMINI_API_KEY=your-gemini-api-key
   JWT_SECRET=your-jwt-secret
   ```

5. Initialize the database:
   ```bash
   python seed.py
   ```

## Usage

Run the development server:
```bash
uvicorn main:app --reload
```

The API will be available at `http://localhost:8000`.

## API Endpoints

### Authentication

- `POST /auth/register`: Register a new user
- `POST /auth/login`: Login and get JWT token

### Career Guidance

- `POST /career/recommend`: Get career recommendations
- `POST /career/skills`: Analyze skills and get gap analysis

## License

This project is licensed under the MIT License.
