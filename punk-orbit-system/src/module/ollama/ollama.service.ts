import { Injectable, OnModuleDestroy, OnModuleInit } from '@nestjs/common';
import ollama from 'ollama'
import { z, ZodType } from 'zod';
import zodToJsonSchema from 'zod-to-json-schema';

@Injectable()
export class OllamaService {


  async extractJobApplicationInformation<T>(body: string) {
    const schema = z.object({
      isRelatedToJobApplication: z.boolean(),
      jobTitle: z.string(),
      companyNamesMentioned: z.string().array(),
      emailDate: z.string(),
    })

    // Strip out all HTML tags from the email body
    const strippedBody = body.replace(/<[^>]*>/g, '');
    
    // Strip out any banned phrases from the email body (make sure to match all cases and variations)
    const bannedPhrases = [
      'Indeed',
      'LinkedIn',
    ];
    const regex = new RegExp(bannedPhrases.join('|'), 'gi');
    const sanitizedBody = strippedBody.replace(regex, '');


    const resp = await ollama.chat({
      model: 'llama3.2',
      options: {
        temperature: 0,
      },
      messages: [
        {
          role: 'system', 
          content: `
            GIVEN THE FOLLOWING DATA PLEASE DETERMINE IF AN EMAIL IS RELATED TO A JOB APPLICATION OR NOT.
            ACCURATELY EXTRACT THE JOB TITLE, ALL COMPANY NAMES, AND DATE OF THE EMAIL (IN DD-MM-YYYY FORMAT).
            RETURN THE RESULT IN JSON FORMAT.
            "INDEED" AND "LINKEDIN" ARE NOT CONSIDERED COMPANIES. 
            SEARCH THROUGHLY FOR THE JOB TITLE AND COMPANY NAMES.
          `, 
        },
        { 
          role: 'user', 
          content: `
            Email body: <<<${sanitizedBody}>>>
          `, 
        }
      ],
      format: zodToJsonSchema(schema),
    });

    const parsedResponse = schema.parse(JSON.parse(resp.message.content));
    return parsedResponse;
  }
}
