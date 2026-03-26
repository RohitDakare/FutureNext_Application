import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma.service';
import { GeminiService } from '../gemini/gemini.service';

@Injectable()
export class QuizService {
  constructor(
    private prisma: PrismaService,
    private geminiService: GeminiService,
  ) {}

  async submitQuiz(answers: Record<string, string | number>) {
    const questions = await this.prisma.question.findMany();
    if (questions.length === 0) {
      throw new NotFoundException('Quiz questions not found in DB');
    }

    const qMap = questions.reduce((acc, q) => {
      acc[q.id] = q.category || '';
      return acc;
    }, {} as Record<string, string>);

    const scores = { R: 0, I: 0, A: 0, S: 0, E: 0, C: 0 };

    for (const [qId, answer] of Object.entries(answers)) {
      if (typeof answer === 'string') {
        // Category was selected directly (Dynamic MC questions)
        if (scores.hasOwnProperty(answer)) {
          scores[answer] += 5;
        }
      } else if (qMap[qId]) {
        // Likert score for a specific category (Static questions)
        const cat = qMap[qId];
        scores[cat] += Number(answer);
      }
    }

    const sortedScores = Object.entries(scores).sort((a, b) => b[1] - a[1]);
    const topCategories = sortedScores.slice(0, 3).map((s) => s[0]);

    const dbCareers = await this.prisma.career.findMany();
    const allCareers = dbCareers.map((c) => ({
      ...c,
      class_11_subjects: JSON.parse(c.class11Subjects || '[]'),
      riasec_codes: JSON.parse(c.riasecCodes || '[]'),
      skills: JSON.parse(c.skills || '[]'),
      top_colleges: JSON.parse(c.topColleges || '[]'),
    }));

    const matchScore = (c: any) => {
      return c.riasec_codes.filter((code: string) => topCategories.includes(code)).length;
    };

    const recommended = allCareers
      .filter((c) => matchScore(c) > 0)
      .sort((a, b) => matchScore(b) - matchScore(a))
      .slice(0, 5);

    const guidance = await this.geminiService.generateCareerGuidance(scores, topCategories, recommended);

    return {
      scores,
      top_categories: topCategories,
      recommended_careers: recommended,
      career_guidance: guidance,
    };
  }
}
