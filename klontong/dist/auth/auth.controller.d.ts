import { AuthService } from './auth.service';
import { Response, Request } from 'express';
import { LoginDto } from 'src/auth/dto/login.dto';
import { RegisterDto } from 'src/auth/dto/register.dto';
import { UserWithoutPassword } from './interfaces/userwithoutpassword.interface';
export interface RequestWithUser extends Request {
    body: UserWithoutPassword;
}
export declare class AuthController {
    private authService;
    constructor(authService: AuthService);
    login(loginDto: LoginDto): Promise<import("./interfaces/auth-token").AuthTokens>;
    register(registerDto: RegisterDto, res: Response): Promise<Response<any, Record<string, any>>>;
    refreshToken(req: RequestWithUser): Promise<import("./interfaces/auth-token").AuthTokens>;
}
