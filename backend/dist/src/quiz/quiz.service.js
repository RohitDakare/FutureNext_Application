"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.QuizService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma.service");
const gemini_service_1 = require("../gemini/gemini.service");
let QuizService = class QuizService {
    prisma;
    geminiService;
    constructor(prisma, geminiService) {
        this.prisma = prisma;
        this.geminiService = geminiService;
    }
    async submitQuiz(answers) {
        const questions = await this.prisma.question.findMany();
        if (questions.length === 0) {
            throw new common_1.NotFoundException('Quiz questions not found in DB');
        }
        const qMap = questions.reduce((acc, q) => {
            acc[q.id] = q.category || '';
            return acc;
        }, {});
        const scores = { R: 0, I: 0, A: 0, S: 0, E: 0, C: 0 };
        for (const [qId, answer] of Object.entries(answers)) {
            if (typeof answer === 'string') {
                if (scores.hasOwnProperty(answer)) {
                    scores[answer] += 5;
                }
            }
            else if (qMap[qId]) {
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
        const matchScore = (c) => {
            return c.riasec_codes.filter((code) => topCategories.includes(code)).length;
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
};
exports.QuizService = QuizService;
exports.QuizService = QuizService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService,
        gemini_service_1.GeminiService])
], QuizService);
//# sourceMappingURL=quiz.service.js.map