import { PrismaService } from '../prisma.service';
export declare class CareersService {
    private prisma;
    constructor(prisma: PrismaService);
    findAll(): Promise<{
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
    }[]>;
}
