import { ConfigService } from '@nestjs/config';
export declare class GeminiService {
    private configService;
    private genAI;
    private model;
    private jsonModel;
    constructor(configService: ConfigService);
    generateDynamicQuestions(previousQuestions: string[]): Promise<any[]>;
    generateCareerGuidance(scores: any, topCategories: string[], recommendedCareers: any[]): Promise<any>;
}
