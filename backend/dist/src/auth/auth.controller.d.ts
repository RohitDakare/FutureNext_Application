import { AuthService } from './auth.service';
import { UserCreateDto, UserLoginDto } from './dto/auth.dto';
export declare class AuthController {
    private authService;
    constructor(authService: AuthService);
    signup(dto: UserCreateDto): Promise<{
        id: number;
        email: string;
    }>;
    login(dto: UserLoginDto): Promise<{
        access_token: string;
        token_type: string;
    }>;
    getMe(req: any): Promise<any>;
}
