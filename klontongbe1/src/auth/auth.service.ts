import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UserService } from '../user/user.service';
import * as argon2 from 'argon2';  // Import the UserWithoutPassword interface
import { UserWithoutPassword } from './interfaces/userwithoutpassword.interface';
import { AuthTokens } from './interfaces/auth-token';
import { User } from 'src/user/schemas/user.schema';

@Injectable()
export class AuthService {
  constructor(
    private userService: UserService,
    private jwtService: JwtService,
  ) {}

  async validateUser(email: string, pass: string): Promise<UserWithoutPassword | null> {
    const user = await this.userService.findByEmail(email);

    if (user && (await argon2.verify(user.password, pass))) {
      const { password, ...userWithoutPassword } = user.toObject();  // Assuming Mongoose is used, convert to plain object
      return userWithoutPassword as UserWithoutPassword;
    }

    return null;
  }

  async login(user: UserWithoutPassword): Promise<AuthTokens> {
    const payload = { email: user.email, sub: user._id };
    return {
      access_token: this.jwtService.sign(payload, { expiresIn: '1m' }),
      refresh_token: this.jwtService.sign(payload, { expiresIn: '2m' }),
    };
  }

  async register(email: string, password: string): Promise<User> {
    const hashedPassword = await argon2.hash(password);
    return this.userService.create({ email, password: hashedPassword });
  }
}