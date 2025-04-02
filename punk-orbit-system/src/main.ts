import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { UnemploymentExporterService } from './module/unemploymentExporter/unemploymentExporter.service';
import { Logger } from '@nestjs/common';

const logger = new Logger('./debug.ts');

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  
  await syncEmails(app.get(UnemploymentExporterService));
  await app.close();
  logger.log('done');
}


async function syncEmails(ues: UnemploymentExporterService) {
  logger.log('Syncing emails...');
  await ues.recordEmailIdsToDb();
  logger.log('Emails synced');
}

bootstrap();
