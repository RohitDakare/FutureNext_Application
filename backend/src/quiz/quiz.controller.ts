import { Controller, Post, Body } from '@nestjs/common';
import { QuizService } from './quiz.service';

@Controller('api/quiz')
export class QuizController {
  constructor(private quizService: QuizService) {}

  @Post('submit')
  async submitQuiz(@Body('answers') answers: Record<string, string | number>) {
    return this.quizService.submitQuiz(answers);
  }
}
