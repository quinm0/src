import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PrismaService } from './prisma.service';
import { OllamaModule } from './module/ollama/ollama.module';
import { GoogleModule } from './module/google/google.module';

@Module({
  imports: [OllamaModule, GoogleModule],
  controllers: [AppController],
  providers: [AppService, PrismaService],
})
export class AppModule {}
