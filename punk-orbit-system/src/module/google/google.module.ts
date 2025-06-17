import { Module } from '@nestjs/common';
import { GoogleAuthService } from './auth.service';
import { GoogleMailService } from './mail.service';
import { PrismaService } from 'src/prisma.service';

@Module({
  imports: [],
  controllers: [],
  providers: [
    {
      provide: GoogleAuthService,
      useFactory: async () => {
        const authService = new GoogleAuthService();
        await authService.onModuleInit();
        return authService;
      },
    },
    GoogleMailService,
    PrismaService,
  ],
  exports: [GoogleMailService],
})
export class GoogleModule {}
