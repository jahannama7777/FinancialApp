import { IsInt, IsNumber, IsOptional, IsString, Min } from 'class-validator';

export class DepositDto {
  @IsInt()
  cardId: number;

  @IsNumber({ maxDecimalPlaces: 2 })
  @Min(0.01)
  amount: number;

  @IsOptional()
  @IsString()
  description?: string;
}
