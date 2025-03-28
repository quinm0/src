import { Injectable } from '@nestjs/common';
import { google } from 'googleapis';
import { GoogleAuthService } from './auth.service';

export type GoogleMailMessage = {
  id: string;
  threadId: string;
};

@Injectable()
export class GoogleMailService {

  constructor(
    private authService: GoogleAuthService,
  ){}

  async getAllMessages(userId: string) {
    const auth = await this.authService.getAuth(userId);
    const gmail = google.gmail({ version: 'v1', auth });
    let messages: GoogleMailMessage[] = [];
    let nextPageToken: string | undefined = undefined;

    do { 
      const res = await gmail.users.messages.list({
        userId: 'me',
        maxResults: 500,
        pageToken: nextPageToken,
      });

      if (res.data.messages) {
        messages = messages.concat(res.data.messages);
      }

      nextPageToken = res.data.nextPageToken;
    } while (nextPageToken);

    return messages
  }

  // method to get email by id for a specific user
  async getEmailById(userId: string, emailId: string) {
    const auth = await this.authService.getAuth(userId);
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
      body: decodedBody,
      subject: res.data.payload?.headers?.find((header) => header.name === 'Subject')?.value,
    }
  }

}
