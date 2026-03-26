import { PrismaService } from '../prisma.service';
import { GeminiService } from '../gemini/gemini.service';
export declare class QuizService {
    private prisma;
    private geminiService;
    constructor(prisma: PrismaService, geminiService: GeminiService);
    submitQuiz(answers: Record<string, string | number>): Promise<{
        scores: {
            R: number;
            I: number;
            A: number;
            S: number;
            E: number;
            C: number;
        };
        top_categories: string[];
        recommended_careers: {
            class_11_subjects: any;
            riasec_codes: any;
            skills: any;
            top_colleges: any;
            emoji: string;
            code: string;
            title: string;
            description: string;
            stream: string;
            salary: string;
            growth: string;
            education: string;
            class11Subjects: string;
            riasecCodes: string;
            topColleges: string;
            brightOutlook: boolean;
        }[];
        career_guidance: any;
    }>;
}
