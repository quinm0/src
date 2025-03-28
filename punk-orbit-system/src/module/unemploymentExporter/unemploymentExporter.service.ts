import { Injectable, OnModuleInit } from '@nestjs/common';
import { PrismaService } from 'src/prisma.service';
import { GoogleMailService } from '../google/mail.service';
import { OllamaService } from '../ollama/ollama.service';
import { z } from 'zod';

@Injectable()
export class UnemploymentExporterService implements OnModuleInit {
  constructor(
    private prismaService: PrismaService,
    private gmail: GoogleMailService,
    private ollama: OllamaService,
  ) {}

  async onModuleInit() {
    console.log('UnemploymentExporterService initalizing...');
    console.log('Recording email ids to db...');
    await this.recordEmailIdsToDb();
    console.log('Processing emails...');
    await this.processEmails();
    console.log('Finished processing emails');
    console.log('UnemploymentExporterService initialized');
  }

  async recordEmailIdsToDb(){
    const emails = await this.gmail.getAllMessages('me');

    const emailIds = emails.map((email) => email.id);

    // add non-existing email ids to the database
    const existingEmails = await this.prismaService.email.findMany({
      where: {
        id: {
          in: emailIds,
        },
      },
    });
    const existingEmailIds = existingEmails.map((email) => email.id);
    const newEmailIds = emailIds.filter((emailId) => !existingEmailIds.includes(emailId));

    await this.prismaService.email.createMany({
      data: newEmailIds.map((emailId) => ({
        id: emailId,
      })),
    });

  }

  async processEmails(){
    const run = await this.prismaService.run.create({data: {}});

    const unprocessedEmais = await this.prismaService.email.findMany({});
    const emailIds = unprocessedEmais.map((email) => email.id);

    // just test for now
    for (const emailId of emailIds) {
      const email = await this.gmail.getEmailById('me', emailId);
      const response = await this.ollama.extractJobApplicationInformation(email.body);
      console.log('processed email:', emailId);
      
      // Mark the email as processed
      await this.prismaService.results.create({
        data: { 
          emailId,
          runId: run.id,

          jobRelated: response.isRelatedToJobApplication,
          jobTitle: response.jobTitle,
          employer: response.companyNamesMentioned.concat().join(', '),
        },
      });
    }

    await this.prismaService.run.update({
      where: {
        id: run.id,
      },
      data: {
        finishedAt: new Date(),
      },
    });
  }
  
}
