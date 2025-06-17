import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { Logger } from '@nestjs/common';
import { GoogleMailService } from './module/google/mail.service';

const logger = new Logger('./debug.ts');

const manuallyLabeledEmailData = 'Label_458396951645540400';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const mail = app.get(GoogleMailService);

  // Do a thing

  // Get all threads and list ids
  // const threads = await mail.getAllMessages('me');
  // console.log(threads.map((thread) => thread.labelIds));

  // Get all label names and id
  // const labels = await mail.getLabels('me');
  // console.log(labels?.map((label) => ({ name: label.name, id: label.id })));

  // Get all emails with label and list
  const emails =
    (await mail.getEmailsByLabel('me', manuallyLabeledEmailData)) ?? [];
  console.log(emails);

  //  try to only extract human readable text from the email body, strip html tags and decode base64
  console.log(
    emails.map((email) => {
      const emailBody = email.body;
      let decodedBody = '';
      if (emailBody) {
        decodedBody = Buffer.from(emailBody, 'base64').toString('utf-8');
      }
      return {
        id: email.id,
        threadId: email.threadId,
        subject: email.subject,
        body: decodedBody,
      };
    }),
  );

  // Done a thing
  await app.close();
  logger.log('done');
}

void bootstrap();
