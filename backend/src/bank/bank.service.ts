import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { DepositDto } from './dto/deposit.dto';
import { WithdrawDto } from './dto/withdraw.dto';

@Injectable()
export class BankService {
  constructor(private readonly prisma: PrismaService) {}

  async deposit(dto: DepositDto) {
    const { cardId, amount, description } = dto;

    if (amount <= 0) {
      throw new BadRequestException('amount must be greater than zero');
    }

    return this.prisma.$transaction(async (tx) => {
      const card = await tx.card.findUnique({ where: { id: cardId } });
      if (!card) {
        throw new NotFoundException('card not found');
      }

      const updated = await tx.card.update({
        where: { id: cardId },
        data: { balance: { increment: amount } },
      });

      await tx.transaction.create({
        data: {
          cardId,
          amount,
          direction: 'IN',
          sourceType: 'DEPOSIT',
          description,
        },
      });

      return { cardId, amount, newBalance: updated.balance };
    });
  }

  async withdraw(dto: WithdrawDto) {
    const { cardId, amount, description } = dto;

    if (amount <= 0) {
      throw new BadRequestException('amount must be greater than zero');
    }

    return this.prisma.$transaction(async (tx) => {
      const card = await tx.card.findUnique({ where: { id: cardId } });
      if (!card) {
        throw new NotFoundException('card not found');
      }

      // بررسی موجودی و کم کردن در یک دستور SQL اتمیک
      const result = await tx.card.updateMany({
        where: { id: cardId, balance: { gte: amount } },
        data: { balance: { decrement: amount } },
      });

      if (result.count === 0) {
        throw new BadRequestException('insufficient balance');
      }

      const updated = await tx.card.findUniqueOrThrow({ where: { id: cardId } });

      await tx.transaction.create({
        data: {
          cardId,
          amount,
          direction: 'OUT',
          sourceType: 'WITHDRAW',
          description,
        },
      });

      return { cardId, amount, newBalance: updated.balance };
    });
  }
}
