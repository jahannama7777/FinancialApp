/*
  Warnings:

  - You are about to alter the column `balance` on the `Card` table. The data in that column could be lost. The data in that column will be cast from `Decimal(18,2)` to `Integer`.
  - You are about to alter the column `amount` on the `Installment` table. The data in that column could be lost. The data in that column will be cast from `Decimal(18,2)` to `Integer`.
  - You are about to alter the column `amount` on the `Investment` table. The data in that column could be lost. The data in that column will be cast from `Decimal(18,2)` to `Integer`.
  - You are about to alter the column `currentValue` on the `Investment` table. The data in that column could be lost. The data in that column will be cast from `Decimal(18,2)` to `Integer`.
  - You are about to alter the column `amount` on the `Item` table. The data in that column could be lost. The data in that column will be cast from `Decimal(18,2)` to `Integer`.
  - You are about to alter the column `amount` on the `ItemTransfer` table. The data in that column could be lost. The data in that column will be cast from `Decimal(18,2)` to `Integer`.
  - You are about to alter the column `amount` on the `Loan` table. The data in that column could be lost. The data in that column will be cast from `Decimal(18,2)` to `Integer`.
  - You are about to alter the column `amount` on the `Transaction` table. The data in that column could be lost. The data in that column will be cast from `Decimal(18,2)` to `Integer`.

*/
-- DropForeignKey
ALTER TABLE "Item" DROP CONSTRAINT "Item_cardId_fkey";

-- DropForeignKey
ALTER TABLE "Transaction" DROP CONSTRAINT "Transaction_cardId_fkey";

-- AlterTable
ALTER TABLE "Card" ALTER COLUMN "balance" SET DEFAULT 0,
ALTER COLUMN "balance" SET DATA TYPE INTEGER;

-- AlterTable
ALTER TABLE "Installment" ALTER COLUMN "amount" SET DATA TYPE INTEGER;

-- AlterTable
ALTER TABLE "Investment" ALTER COLUMN "amount" SET DATA TYPE INTEGER,
ALTER COLUMN "currentValue" SET DATA TYPE INTEGER;

-- AlterTable
ALTER TABLE "Item" ALTER COLUMN "amount" DROP NOT NULL,
ALTER COLUMN "amount" DROP DEFAULT,
ALTER COLUMN "amount" SET DATA TYPE INTEGER;

-- AlterTable
ALTER TABLE "ItemTransfer" ALTER COLUMN "amount" SET DATA TYPE INTEGER;

-- AlterTable
ALTER TABLE "Loan" ALTER COLUMN "amount" SET DATA TYPE INTEGER;

-- AlterTable
ALTER TABLE "Transaction" ALTER COLUMN "amount" SET DATA TYPE INTEGER;

-- AddForeignKey
ALTER TABLE "Item" ADD CONSTRAINT "Item_cardId_fkey" FOREIGN KEY ("cardId") REFERENCES "Card"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_cardId_fkey" FOREIGN KEY ("cardId") REFERENCES "Card"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
