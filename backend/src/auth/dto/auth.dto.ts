import { IsEmail, IsString, MinLength } from 'class-validator';

export class UserCreateDto {
  @IsEmail()
  email: string;

  @IsString()
  @MinLength(6)
  password: string;
}

export class UserLoginDto {
  @IsEmail()
  email: string;

  @IsString()
  password: string;
}
