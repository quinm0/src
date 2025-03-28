import { Module } from '@nestjs/common';
import { OllamaModule } from '../ollama/ollama.module';
import { GoogleModule } from '../google/google.module';
import { UnemploymentExporterService } from './unemploymentExporter.service';
import { PrismaService } from 'src/prisma.service';

@Module({
  imports: [OllamaModule, GoogleModule],
  controllers: [],
  providers: [UnemploymentExporterService, PrismaService],
  exports: [],
})
export class UnemploymentExporterModule {}
