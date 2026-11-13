import { Body, Controller, Post } from '@nestjs/common';
import { BankService } from './bank.service';
import { DepositDto } from './dto/deposit.dto';
import { WithdrawDto } from './dto/withdraw.dto';

@Controller('bank')
export class BankController {
  constructor(private readonly bankService: BankService) {}

  @Post('deposits')
  deposit(@Body() dto: DepositDto) {
    return this.bankService.deposit(dto);
  }

  @Post('withdrawals')
  withdraw(@Body() dto: WithdrawDto) {
    return this.bankService.withdraw(dto);
  }
}
