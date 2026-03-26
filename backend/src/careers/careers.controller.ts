import { Controller, Get } from '@nestjs/common';
import { CareersService } from './careers.service';

@Controller('api/careers')
export class CareersController {
  constructor(private careersService: CareersService) {}

  @Get()
  async getCareers() {
    return this.careersService.findAll();
  }
}
