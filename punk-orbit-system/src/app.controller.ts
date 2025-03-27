import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';
import { PrismaService } from './prisma.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService, private readonly prisma: PrismaService) {}

  @Get()
  async getHello(): Promise<string> {
    await this.prisma.user.create({
      data: {
        email: 'test@pl;ace.com'
      }
    })
    console.log(await this.prisma.user.findMany())
    return this.appService.getHello();
  }
}
