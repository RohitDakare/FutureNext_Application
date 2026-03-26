from pydantic import BaseModel, EmailStr
from typing import List, Optional

class Token(BaseModel):
    access_token: str
    token_type: str

class UserCreate(BaseModel):
    email: str
    password: str

class UserResponse(BaseModel):
    id: int
    email: str

    class Config:
        from_attributes = True

class QuestionOption(BaseModel):
    text: str
    category: str  # R, I, A, S, E, or C

class QuestionResponse(BaseModel):
    id: str
    text: str
    category: Optional[str] = None # For static questions
    emoji: str
    options: Optional[List[QuestionOption]] = None # For dynamic MC questions

class CareerResponse(BaseModel):
    title: str
    code: str
    emoji: str
    description: str
    stream: str
    salary: str
    growth: str
    education: str
    class_11_subjects: List[str]
    riasec_codes: List[str]
    skills: List[str]
    top_colleges: List[str]
    bright_outlook: bool

    class Config:
        from_attributes = True

class GenerateQuestionsRequest(BaseModel):
    previous_questions: List[str] = []

class QuizSubmission(BaseModel):
    answers: dict[str, str | int] # question_id -> score (1-5) or category string ("R", etc)

class QuizResult(BaseModel):
    scores: dict[str, int] # Category (R, I, A, S, E, C) -> Total Score
    top_categories: List[str]
    recommended_careers: List[CareerResponse]
    career_guidance: Optional[str] = None
