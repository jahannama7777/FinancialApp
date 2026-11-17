import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PrismaModule } from './prisma/prisma.module';
import { BankController } from './bank/bank.controller';
import { BankService } from './bank/bank.service';
import { AuthModule } from './auth/auth.module';

@Module({
  imports: [PrismaModule, AuthModule],
  controllers: [AppController, BankController],
  providers: [AppService, BankService],
})
export class AppModule {}
