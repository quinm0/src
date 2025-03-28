import { Module } from '@nestjs/common';
import { OllamaModule } from '../ollama/ollama.module';
import { GoogleModule } from '../google/google.module';

@Module({
  imports: [OllamaModule, GoogleModule],
  controllers: [],
  providers: [],
  exports: [],
})
export class UnemploymentExporterModule {}
