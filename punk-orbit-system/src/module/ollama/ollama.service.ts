import { Injectable, OnModuleDestroy, OnModuleInit } from '@nestjs/common';
import ollama from 'ollama'

@Injectable()
export class OllamaService {


  async testMessage(): Promise<string> {
    const resp = await ollama.chat({
      model: 'llama3.2-vision',
      messages: [
        { 
          role: 'user', 
          content: 'What image is this?', 
          images: ['test.pdf']
        }
      ],
      // format: zodToJsonSchema(Country),
    })

    return resp.message.content;
  }
}
