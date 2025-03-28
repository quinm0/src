import { Injectable, OnModuleDestroy, OnModuleInit } from '@nestjs/common';
import ollama from 'ollama'
import { z, ZodType } from 'zod';
import zodToJsonSchema from 'zod-to-json-schema';

// 2. Provide explicit examples (few-shot) in the system prompt
//    along with strict definitions of what "job application update" means.
const examples = `
TRUE EXAMPLE:
Email body: <<<Hello John, we are following up on your recent application for the Software Engineer position.>>>
Output: {"isJobApplicationUpdate": true, "certainty": 0.95}

FALSE EXAMPLE:
Email body: <<<We saw your LinkedIn profile and wanted to send you information about open roles at our company.>>>
Output: {"isJobApplicationUpdate": false, "certainty": 0.4}

FALSE EXAMPLE:
Email body: <<<Buy one get one free on all electronics this weekend only!>>>
Output: {"isJobApplicationUpdate": false, "certainty": 0.1}
`


@Injectable()
export class OllamaService {


  async extractJobApplicationInformation<T>(body: string) {
    const schema = z.object({
      isJobApplicationUpdate: z.boolean(),
      certainty: z.number()
    })

    const systemPrompt = `
      You are an email classification model. 
      - Respond true ONLY if the email specifically references an existing job application that the user has already submitted, 
        including mentions of application status, next steps, interviews, or an offer.
      - If the email does not clearly reference a previously submitted application, respond false.
      - Provide a certainty score from 0 to 1. If you are even slightly unsure, use a lower certainty (<0.5).

      Here are some examples for guidance:
      ${examples}

      Now classify the next email:
    `

    const resp = await ollama.chat({
      model: 'llama3.2',
      messages: [
        {
          role: 'system',
          content: systemPrompt,
        },
        {
          role: 'user',
          content: `Email body: <<<${body}>>>`
        }
      ],
      format: zodToJsonSchema(schema),
    });

    const parsedResponse = schema.parse(JSON.parse(resp.message.content));
    return parsedResponse;
  }
}
