import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PrismaService } from './prisma.service';
import { OllamaModule } from './module/ollama/ollama.module';
import { GoogleModule } from './module/google/google.module';
import { UnemploymentExporterModule } from './module/unemploymentExporter/unemploymentExporter.module';

@Module({
  imports: [OllamaModule, GoogleModule, UnemploymentExporterModule],
  controllers: [AppController],
  providers: [AppService, PrismaService],
})
export class AppModule {}
