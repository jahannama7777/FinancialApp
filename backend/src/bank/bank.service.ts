import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { DepositDto } from './dto/deposit.dto';

@Injectable()
export class BankService {
  constructor(private readonly prisma: PrismaService) {}

  async deposit(dto: DepositDto) {
    const { cardId, amount, description } = dto;

    if (amount <= 0) {
      throw new BadRequestException('amount must be greater than zero');
    }

    // همان «یک تراکنش دیتابیسی» که در نمودار توالی بود
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

      return {
        cardId,
        amount,
        newBalance: updated.balance,
      };
    });
  }
}
