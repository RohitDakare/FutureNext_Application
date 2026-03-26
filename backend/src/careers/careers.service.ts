import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma.service';

@Injectable()
export class CareersService {
  constructor(private prisma: PrismaService) {}

  async findAll() {
    const careers = await this.prisma.career.findMany();
    return careers.map((c) => ({
      ...c,
      class_11_subjects: JSON.parse(c.class11Subjects || '[]'),
      riasec_codes: JSON.parse(c.riasecCodes || '[]'),
      skills: JSON.parse(c.skills || '[]'),
      top_colleges: JSON.parse(c.topColleges || '[]'),
    }));
  }
}
