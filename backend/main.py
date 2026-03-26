from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from typing import List
import json

from config import settings
import models
from models import SessionLocal, engine, DBUser
from schemas import (
    QuestionResponse, CareerResponse, QuizSubmission, QuizResult, 
    UserCreate, UserResponse, Token, GenerateQuestionsRequest, QuestionOption
)
from auth import (
    get_password_hash, verify_password, create_access_token, get_current_user, authenticate_user
)
from fastapi.security import OAuth2PasswordRequestForm
import gemini_service

models.Base.metadata.create_all(bind=engine)

app = FastAPI(title=settings.app_name, version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"] if settings.environment != "production" else settings.cors_origins,
    allow_credentials=True if settings.environment == "production" else False,
    allow_methods=["*"],
    allow_headers=["*"],
)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def parse_career(db_career: models.DBCareer) -> CareerResponse:
    return CareerResponse(
        title=db_career.title,
        code=db_career.code,
        emoji=db_career.emoji,
        description=db_career.description,
        stream=db_career.stream,
        salary=db_career.salary,
        growth=db_career.growth,
        education=db_career.education,
        class_11_subjects=json.loads(db_career.class_11_subjects) if db_career.class_11_subjects else [],
        riasec_codes=json.loads(db_career.riasec_codes) if db_career.riasec_codes else [],
        skills=json.loads(db_career.skills) if db_career.skills else [],
        top_colleges=json.loads(db_career.top_colleges) if db_career.top_colleges else [],
        bright_outlook=db_career.bright_outlook
    )

@app.get("/")
def read_root():
    return {"message": "Welcome to FutureNex API"}

@app.get("/api/questions", response_model=List[QuestionResponse])
def get_questions(db: Session = Depends(get_db)):
    questions = db.query(models.DBQuestion).all()
    return questions

@app.post("/api/questions/generate", response_model=List[QuestionResponse])
def generate_questions(req: GenerateQuestionsRequest):
    # Call Gemini to get 5 dynamic questions avoiding previous_questions
    questions_data = gemini_service.generate_dynamic_questions(req.previous_questions)
    
    # ensure proper format
    valid_qs = []
    for i, q in enumerate(questions_data):
        if 'id' in q and 'text' in q and 'options' in q:
            valid_qs.append(QuestionResponse(
                id=str(q['id']), 
                text=q['text'], 
                emoji=q.get('emoji', '❓'),
                options=[QuestionOption(text=o['text'], category=o['category']) for o in q['options']]
            ))
    return valid_qs

@app.get("/api/careers", response_model=List[CareerResponse])
def get_careers(db: Session = Depends(get_db)):
    try:
        careers = db.query(models.DBCareer).all()
        return [parse_career(c) for c in careers]
    except Exception as e:
        raise HTTPException(status_code=500, detail="Error fetching careers from database")

@app.post("/api/quiz/submit", response_model=QuizResult)
def submit_quiz(submission: QuizSubmission, db: Session = Depends(get_db)):
    try:
        questions = db.query(models.DBQuestion).all()
        if not questions:
            raise HTTPException(status_code=404, detail="Quiz questions not found in DB")
            
        q_map = {q.id: q.category for q in questions}
        
        scores = {"R": 0, "I": 0, "A": 0, "S": 0, "E": 0, "C": 0}
        
        for q_id, answer in submission.answers.items():
            if isinstance(answer, str):
                # Catgeory was selected directly (Dynamic MC questions)
                if answer in scores:
                    scores[answer] += 5
            elif q_id in q_map:
                # Likert score for a specific category (Static questions)
                cat = q_map[q_id]
                scores[cat] += int(answer)

        sorted_scores = sorted(scores.items(), key=lambda x: x[1], reverse=True)
        top_categories = [sorted_scores[i][0] for i in range(min(3, len(sorted_scores)))]

        db_careers = db.query(models.DBCareer).all()
        all_careers = [parse_career(c) for c in db_careers]

        def match_score(c: CareerResponse):
            return len(set(c.riasec_codes).intersection(set(top_categories)))

        recommended = [c for c in all_careers if match_score(c) > 0]
        recommended.sort(key=match_score, reverse=True)
        top_careers = recommended[:5]

        # Generate Gemini guidance
        guidance = gemini_service.generate_career_guidance(scores, top_categories, top_careers)

        return QuizResult(
            scores=scores,
            top_categories=top_categories,
            recommended_careers=top_careers,
            career_guidance=guidance
        )
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail="Internal server error parsing quiz results")

@app.post("/api/signup", response_model=UserResponse)
def signup(user: UserCreate, db: Session = Depends(get_db)):
    db_user = db.query(DBUser).filter(DBUser.email == user.email).first()
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    hashed_password = get_password_hash(user.password)
    new_user = DBUser(email=user.email, password_hash=hashed_password)
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user

@app.post("/api/login", response_model=Token)
def login(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    user = db.query(DBUser).filter(DBUser.email == form_data.username).first()
    if not user or not verify_password(form_data.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token = create_access_token(data={"sub": user.email})
    return {"access_token": access_token, "token_type": "bearer"}

@app.get("/api/users/me", response_model=UserResponse)
def read_users_me(current_user: DBUser = Depends(get_current_user)):
    return current_user
