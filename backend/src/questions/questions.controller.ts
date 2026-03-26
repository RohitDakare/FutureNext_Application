import { Controller, Get, Post, Body } from '@nestjs/common';
import { QuestionsService } from './questions.service';

@Controller('api/questions')
export class QuestionsController {
  constructor(private questionsService: QuestionsService) {}

  @Get()
  async getQuestions() {
    return this.questionsService.findAll();
  }

  @Post('generate')
  async generateQuestions(@Body('previous_questions') previousQuestions: string[]) {
    return this.questionsService.generateDynamic(previousQuestions || []);
  }
}
