import { JwtService } from '@nestjs/jwt';
import { UserService } from '../user/user.service';
import { UserWithoutPassword } from './interfaces/userwithoutpassword.interface';
import { AuthTokens } from './interfaces/auth-token';
import { User } from 'src/user/schemas/user.schema';
export declare class AuthService {
    private userService;
    private jwtService;
    constructor(userService: UserService, jwtService: JwtService);
    validateUser(email: string, pass: string): Promise<UserWithoutPassword | null>;
    login(user: UserWithoutPassword): Promise<AuthTokens>;
    register(email: string, password: string): Promise<User>;
}
