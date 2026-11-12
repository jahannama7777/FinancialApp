import { Body, Controller, Post } from '@nestjs/common';
import { BankService } from './bank.service';
import { DepositDto } from './dto/deposit.dto';

@Controller('bank')
export class BankController {
  constructor(private readonly bankService: BankService) {}

  @Post('deposits')
  deposit(@Body() dto: DepositDto) {
    return this.bankService.deposit(dto);
  }
}
