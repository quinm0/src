import { Injectable, OnModuleDestroy, OnModuleInit } from '@nestjs/common';
import ollama from 'ollama'
import { z, ZodType } from 'zod';
import zodToJsonSchema from 'zod-to-json-schema';


@Injectable()
export class OllamaService {

  async extractDataFromBulk<T>(
      schema: ZodType<T>, 
      bulk: string, 
      examples?: {
        bulk: string, 
        result: ZodType<T>
      }[]
  ): Promise<T> {

    const systemPrompt = `
      YOU'RE A DATA EXTRACTION ASSISTANT.
      EXTRACT ONLY THE DATA FROM THE BULK EMAIL.
      YOU MUST FOLLOW THE SCHEMA STRICTLY.
      DO NOT ADD ANYTHING ELSE.
      DO NOT EXPLAIN YOUR ANSWER.
      THE SCHEMA IS: ${zodToJsonSchema(schema)}
      THE EXAMPLES ARE: ${examples?.map(e => `Bulk: <<<${e.bulk}>>>, Result: <<<${zodToJsonSchema(e.result)}>>>`).join(', ')}
    `;

    const resp = await ollama.chat({
      model: 'llama3.2',
      messages: [
        {
          role: 'system',
          content: systemPrompt,
        },
        {
          role: 'user',
          content: `THE DATA YOURE EXTRACTING IS: <<<${bulk}>>>`
        }
      ],
      format: zodToJsonSchema(schema),
    });

    const parsedResponse = schema.parse(JSON.parse(resp.message.content));
    return parsedResponse;
  }
}
