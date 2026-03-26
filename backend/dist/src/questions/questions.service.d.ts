import { PrismaService } from '../prisma.service';
import { GeminiService } from '../gemini/gemini.service';
export declare class QuestionsService {
    private prisma;
    private geminiService;
    constructor(prisma: PrismaService, geminiService: GeminiService);
    findAll(): Promise<{
        id: string;
        text: string;
        category: string | null;
        emoji: string;
    }[]>;
    generateDynamic(previousQuestions: string[]): Promise<any[]>;
}
