import json
from models import SessionLocal, engine, DBQuestion, DBCareer, Base

def seed_data():
    db = SessionLocal()
    
    # Check if already seeded
    if db.query(DBQuestion).first():
        print("Data already seeded.")
        db.close()
        return

    questions = [
        {"id": "r1", "text": "Would you enjoy building a wooden birdhouse or cabinet?", "category": "R", "emoji": "🔨"},
        {"id": "r2", "text": "Would you enjoy fixing a bicycle or a broken toy?", "category": "R", "emoji": "🔧"},
        {"id": "r3", "text": "Would you enjoy assemblying a computer or gaming console?", "category": "R", "emoji": "💻"},
        {"id": "r4", "text": "Would you enjoy operating heavy machinery or tools?", "category": "R", "emoji": "🚜"},
        {"id": "r5", "text": "Would you enjoy working on a small organic farm?", "category": "R", "emoji": "🌱"},
        {"id": "i1", "text": "Would you enjoy studying how viruses or medicines work?", "category": "I", "emoji": "🔬"},
        {"id": "i2", "text": "Would you enjoy doing experiments in a chemistry lab?", "category": "I", "emoji": "🧪"},
        {"id": "i3", "text": "Would you enjoy solving complex math puzzles or riddles?", "category": "I", "emoji": "🧩"},
        {"id": "i4", "text": "Would you enjoy researching about stars and galaxies?", "category": "I", "emoji": "🔭"},
        {"id": "i5", "text": "Would you enjoy analyzing data to find hidden patterns?", "category": "I", "emoji": "📊"},
        {"id": "a1", "text": "Would you enjoy designing your own clothing or fashion accessories?", "category": "A", "emoji": "👗"},
        {"id": "a2", "text": "Would you enjoy writing a script for a play or YouTube video?", "category": "A", "emoji": "✍️"},
        {"id": "a3", "text": "Would you enjoy painting or sketching digital art?", "category": "A", "emoji": "🎨"},
        {"id": "a4", "text": "Would you enjoy composing music or playing in a band?", "category": "A", "emoji": "🎸"},
        {"id": "a5", "text": "Would you enjoy acting in a dramatic stage performance?", "category": "A", "emoji": "🎭"},
        {"id": "s1", "text": "Would you enjoy teaching a younger child how to read?", "category": "S", "emoji": "📚"},
        {"id": "s2", "text": "Would you enjoy helping people who are sick or injured?", "category": "S", "emoji": "🚑"},
        {"id": "s3", "text": "Would you enjoy counseling friends when they are feeling low?", "category": "S", "emoji": "🛋️"},
        {"id": "s4", "text": "Would you enjoy working at a community help center?", "category": "S", "emoji": "🏘️"},
        {"id": "s5", "text": "Would you enjoy coaching a group of kids in sports?", "category": "S", "emoji": "⚽"},
        {"id": "e1", "text": "Would you enjoy starting your own small online shop?", "category": "E", "emoji": "🚀"},
        {"id": "e2", "text": "Would you enjoy being the class representative or leader?", "category": "E", "emoji": "🏛️"},
        {"id": "e3", "text": "Would you enjoy negotiating deals or selling products?", "category": "E", "emoji": "🤝"},
        {"id": "e4", "text": "Would you enjoy managing a team of people on a project?", "category": "E", "emoji": "📋"},
        {"id": "e5", "text": "Would you enjoy giving a speech to a large audience?", "category": "E", "emoji": "🎤"},
        {"id": "c1", "text": "Would you enjoy keeping tracks of money and expenses?", "category": "C", "emoji": "💵"},
        {"id": "c2", "text": "Would you enjoy organizing a large library of books or files?", "category": "C", "emoji": "📁"},
        {"id": "c3", "text": "Would you enjoy proofreading a book to find small errors?", "category": "C", "emoji": "🔍"},
        {"id": "c4", "text": "Would you enjoy creating a detailed budget for an event?", "category": "C", "emoji": "📉"},
        {"id": "c5", "text": "Would you enjoy managing a database of student records?", "category": "C", "emoji": "💻"},
    ]

    for q in questions:
        db.add(DBQuestion(**q))

    careers = [
        {
            "code": "soft-dev", "title": "Software Developer", "emoji": "💻", "description": "Build apps and websites that solve real-world problems. You use logic and creativity to write code.",
            "stream": "Science", "salary": "₹5 LPA - ₹45 LPA+", "growth": "25% 🚀", "education": "B.Tech in CS/IT → Specialized Courses",
            "class_11_subjects": ["Physics", "Chemistry", "Maths"], "riasec_codes": ["I", "R", "A"], "skills": ["Coding", "Logic", "Problem Solving", "Algorithm Design"],
            "top_colleges": ["IITs", "BITS Pilani", "IIITs"], "bright_outlook": True
        },
        {
            "code": "doctor", "title": "Doctor (Medical)", "emoji": "👨‍⚕️", "description": "Diagnose and treat illnesses to help people live healthy lives. You are the frontline helper of society.",
            "stream": "Science", "salary": "₹8 LPA - ₹60 LPA+", "growth": "5% 📈", "education": "MBBS → MD/MS Specialized Internship",
            "class_11_subjects": ["Physics", "Chemistry", "Biology"], "riasec_codes": ["I", "S", "R"], "skills": ["Empathy", "Diagnosis", "Surgery", "Patience"],
            "top_colleges": ["AIIMS", "CMC Vellore", "MAMC Delhi"], "bright_outlook": False
        },
        {
            "code": "entrep", "title": "Entrepreneur", "emoji": "🚀", "description": "Starting your own business venture based on a problem you want to solve in the market.",
            "stream": "Commerce", "salary": "Variable (High Risk/Reward)", "growth": "90% 🌟", "education": "Any Degree → Networking/Experience (BBA/MBA helpful)",
            "class_11_subjects": ["Business Studies", "Entrepreneurship", "Maths"], "riasec_codes": ["E", "A", "S"], "skills": ["Risk Taking", "Leadership", "Sales", "Innovation"],
            "top_colleges": ["IIMs (for MBA)", "St.Stephens", "Narsee Monjee"], "bright_outlook": True
        },
        {
            "code": "ux-des", "title": "UX Designer", "emoji": "✨", "description": "Making apps and websites easy and fun to use. You study user behavior and design interfaces.",
            "stream": "Arts", "salary": "₹6 LPA - ₹40 LPA+", "growth": "25% 📱", "education": "B.Des in Interaction/User Experience Design",
            "class_11_subjects": ["Psychology", "Fine Arts", "Informatic Practices"], "riasec_codes": ["A", "I", "S"], "skills": ["User Research", "Prototyping", "Figma", "Analytical Design"],
            "top_colleges": ["NID", "IIT Guwahati", "Srishti Manipal"], "bright_outlook": True
        }
    ]

    for c in careers:
        db.add(DBCareer(
            code=c["code"],
            title=c["title"],
            emoji=c["emoji"],
            description=c["description"],
            stream=c["stream"],
            salary=c["salary"],
            growth=c["growth"],
            education=c["education"],
            class_11_subjects=json.dumps(c["class_11_subjects"]),
            riasec_codes=json.dumps(c["riasec_codes"]),
            skills=json.dumps(c["skills"]),
            top_colleges=json.dumps(c["top_colleges"]),
            bright_outlook=c["bright_outlook"]
        ))

    db.commit()
    db.close()
    print("Database seeded completely!")

if __name__ == "__main__":
    Base.metadata.create_all(bind=engine)
    seed_data()
