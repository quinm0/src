import { Injectable } from '@nestjs/common';
import { gmail_v1, google } from 'googleapis';
import { GoogleAuthService } from './auth.service';
import { PrismaService } from 'src/prisma.service';
import { GaxiosResponse } from 'gaxios';

@Injectable()
export class GoogleMailService {
  constructor(
    private authService: GoogleAuthService,
    private prismaService: PrismaService,
  ) {}

  async getAllMessages(userId: string) {
    const auth = this.authService.getAuth(userId);
    const gmail = google.gmail({ version: 'v1', auth });
    let messages: gmail_v1.Schema$Message[] = [];
    let nextPageToken: string | undefined | null = undefined;

    do {
      const res: GaxiosResponse<gmail_v1.Schema$ListMessagesResponse> =
        await gmail.users.messages.list({
          userId: 'me',
          maxResults: 500,
          pageToken: nextPageToken,
        });

      if (res.data.messages) {
        messages = messages.concat(res.data.messages);
      }

      nextPageToken = res.data.nextPageToken;
    } while (nextPageToken);

    return messages;
  }

  // method to get email by id for a specific user
  async getEmailById(userId: string, emailId: string) {
    const auth = this.authService.getAuth(userId);
    const gmail = google.gmail({ version: 'v1', auth });
    const res = await gmail.users.messages.get({
      userId: 'me',
      id: emailId,
    });

    // log the email body (decode from base64)
    const emailBody = res.data.payload?.body?.data;
    let decodedBody = '';
    if (emailBody) {
      decodedBody = Buffer.from(emailBody, 'base64').toString('utf-8');
    }

    return {
      id: res.data.id,
      threadId: res.data.threadId,
      subject: res.data.payload?.headers?.find(
        (header) => header.name === 'Subject',
      )?.value,
      body: decodedBody,
    };
  }

  // get threads for a specific user
  async getThreads(userId: string) {
    const auth = this.authService.getAuth(userId);
    const gmail = google.gmail({ version: 'v1', auth });
    const res = await gmail.users.threads.list({
      userId: 'me',
      maxResults: 500,
    });

    return res.data.threads;
  }

  async getLabels(userId: string) {
    const auth = this.authService.getAuth(userId);
    const gmail = google.gmail({ version: 'v1', auth });
    const res = await gmail.users.labels.list({
      userId: 'me',
    });
    return res.data.labels;
  }

  async getEmailsByLabel(userId: string, labelId: string) {
    const auth = this.authService.getAuth(userId);
    const gmail = google.gmail({ version: 'v1', auth });
    const res = await gmail.users.messages.list({
      userId: 'me',
      labelIds: [labelId],
    });

    // Call getEmailById for each email in the list
    const emails = await Promise.all(
      (res.data.messages ?? []).map(async (message) => {
        const email = await this.getEmailById(userId, message.id ?? '');
        return email;
      }),
    );
    return emails;
  }

  async getThreadsByLabel(userId: string, labelId: string) {
    const auth = this.authService.getAuth(userId);
    const gmail = google.gmail({ version: 'v1', auth });
    const res = await gmail.users.threads.list({
      userId: 'me',
      labelIds: [labelId],
    });

    return res.data.threads;
  }
}
