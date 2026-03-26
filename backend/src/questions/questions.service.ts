import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma.service';
import { GeminiService } from '../gemini/gemini.service';

@Injectable()
export class QuestionsService {
  constructor(
    private prisma: PrismaService,
    private geminiService: GeminiService,
  ) {}

  async findAll() {
    return this.prisma.question.findMany();
  }

  async generateDynamic(previousQuestions: string[]) {
    return this.geminiService.generateDynamicQuestions(previousQuestions);
  }
}
