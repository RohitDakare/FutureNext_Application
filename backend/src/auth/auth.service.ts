import { Injectable, UnauthorizedException, ConflictException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UsersService } from '../users/users.service';
import * as bcrypt from 'bcrypt';
import { UserCreateDto, UserLoginDto } from './dto/auth.dto';

@Injectable()
export class AuthService {
  constructor(
    private usersService: UsersService,
    private jwtService: JwtService,
  ) {}

  async signup(dto: UserCreateDto) {
    const existingUser = await this.usersService.findOne(dto.email);
    if (existingUser) {
      throw new ConflictException('Email already registered');
    }

    const hashedPassword = await bcrypt.hash(dto.password, 10);
    const user = await this.usersService.create({
      email: dto.email,
      passwordHash: hashedPassword,
    });

    return {
      id: user.id,
      email: user.email,
    };
  }

  async login(dto: UserLoginDto) {
    const user = await this.usersService.findOne(dto.email);
    if (!user || !(await bcrypt.compare(dto.password, user.passwordHash))) {
      throw new UnauthorizedException('Incorrect email or password');
    }

    const payload = { sub: user.email };
    return {
      access_token: await this.jwtService.signAsync(payload),
      token_type: 'bearer',
    };
  }

  async validateUser(email: string) {
    return this.usersService.findOne(email);
  }
}
