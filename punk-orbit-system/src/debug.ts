import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { Logger } from '@nestjs/common';

const logger = new Logger('./debug.ts');

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  // Do a thing

  // Done a thing
  await app.close();
  logger.log('done');
}



bootstrap();
