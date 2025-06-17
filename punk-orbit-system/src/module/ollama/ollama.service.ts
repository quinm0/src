import { Injectable } from '@nestjs/common';
import ollama from 'ollama';
import { z, ZodType } from 'zod';
import zodToJsonSchema from 'zod-to-json-schema';

@Injectable()
export class OllamaService {
  constructor() {
    // Initialize the Ollama service if needed
  }

  async extractDataFromBulk<T>(schema: ZodType<T>, bulk: string): Promise<T> {
    const systemPrompt = `
      YOU'RE A DATA EXTRACTION ASSISTANT.
      EXTRACT ONLY THE DATA FROM THE BULK EMAIL.
      YOU MUST FOLLOW THE SCHEMA STRICTLY.
      DO NOT ADD ANYTHING ELSE.
      DO NOT EXPLAIN YOUR ANSWER.
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
          content: `THE DATA YOURE EXTRACTING IS: <<<${bulk}>>>`,
        },
      ],
      format: zodToJsonSchema(schema),
      options: {},
    });

    const parsedResponse = schema.parse(JSON.parse(resp.message.content));
    return parsedResponse;
  }
}
