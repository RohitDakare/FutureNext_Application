import { QuestionsService } from './questions.service';
export declare class QuestionsController {
    private questionsService;
    constructor(questionsService: QuestionsService);
    getQuestions(): Promise<{
        id: string;
        text: string;
        category: string | null;
        emoji: string;
    }[]>;
    generateQuestions(previousQuestions: string[]): Promise<any[]>;
}
