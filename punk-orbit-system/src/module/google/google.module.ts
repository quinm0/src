import { Module } from '@nestjs/common';
import { GoogleAuthService } from './auth.service';
import { GoogleMailService } from './mail.service';

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
    GoogleMailService
  ],
  exports: [GoogleMailService],
})
export class GoogleModule {}
