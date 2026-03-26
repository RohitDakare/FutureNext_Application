import { JwtService } from '@nestjs/jwt';
import { UsersService } from '../users/users.service';
import { UserCreateDto, UserLoginDto } from './dto/auth.dto';
export declare class AuthService {
    private usersService;
    private jwtService;
    constructor(usersService: UsersService, jwtService: JwtService);
    signup(dto: UserCreateDto): Promise<{
        id: number;
        email: string;
    }>;
    login(dto: UserLoginDto): Promise<{
        access_token: string;
        token_type: string;
    }>;
    validateUser(email: string): Promise<{
        id: number;
        email: string;
        passwordHash: string;
        createdAt: Date;
    } | null>;
}
