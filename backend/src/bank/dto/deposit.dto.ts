import { IsInt, IsOptional, IsString, Max, Min } from 'class-validator';

export class DepositDto {
  @IsInt()
  cardId: number;

  // مبلغ به تومان: عدد صحیح و مثبت
  @IsInt()
  @Min(1)
  @Max(2147483647)
  amount: number;

  @IsOptional()
  @IsString()
  description?: string;
}