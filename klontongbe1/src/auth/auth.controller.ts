import { Controller, Post, Body, UseGuards, Req, Res, UnauthorizedException } from '@nestjs/common';
import { AuthService } from './auth.service';
import { Response, Request } from 'express';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { LoginDto } from 'src/auth/dto/login.dto';
import { RegisterDto } from 'src/auth/dto/register.dto';
import { UserWithoutPassword } from './interfaces/userwithoutpassword.interface';

export interface RequestWithUser extends Request {
  body: UserWithoutPassword;
}

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('login')
  async login(@Body() loginDto: LoginDto) {
    const user: UserWithoutPassword | null = await this.authService.validateUser(loginDto.email, loginDto.password);
    if (!user) {
      throw new UnauthorizedException();
    }
    return this.authService.login(user);
  }

  @Post('register')
  async register(@Body() registerDto: RegisterDto, @Res() res: Response) {
    const user = await this.authService.register(registerDto.email, registerDto.password);
    return res.status(user ? 201 : 500).send();
  }

  @UseGuards(JwtAuthGuard)
  @Post('refresh')
  refreshToken(@Req() req: RequestWithUser) {
    return this.authService.login(req.body);
  }
}