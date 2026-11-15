/*
  Warnings:

  - You are about to alter the column `number` on the `Card` table. The data in that column could be lost. The data in that column will be cast from `Text` to `VarChar(16)`.

*/
-- DropForeignKey
ALTER TABLE "Loan" DROP CONSTRAINT "Loan_borrowerCardId_fkey";

-- AlterTable
ALTER TABLE "Card" ADD COLUMN     "expiry" VARCHAR(5),
ADD COLUMN     "isActive" BOOLEAN NOT NULL DEFAULT true,
ALTER COLUMN "number" SET DATA TYPE VARCHAR(16);

-- AlterTable
ALTER TABLE "Item" ADD COLUMN     "amount" DECIMAL(18,2) NOT NULL DEFAULT 0;

-- AlterTable
ALTER TABLE "Loan" ADD COLUMN     "borrowerName" TEXT,
ALTER COLUMN "borrowerCardId" DROP NOT NULL;

-- CreateTable
CREATE TABLE "ItemTransfer" (
    "id" SERIAL NOT NULL,
    "amount" DECIMAL(18,2) NOT NULL,
    "date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "note" TEXT,
    "fromItemId" INTEGER NOT NULL,
    "toItemId" INTEGER NOT NULL,

    CONSTRAINT "ItemTransfer_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "ItemTransfer_fromItemId_date_idx" ON "ItemTransfer"("fromItemId", "date");

-- CreateIndex
CREATE INDEX "ItemTransfer_toItemId_date_idx" ON "ItemTransfer"("toItemId", "date");

-- AddForeignKey
ALTER TABLE "ItemTransfer" ADD CONSTRAINT "ItemTransfer_fromItemId_fkey" FOREIGN KEY ("fromItemId") REFERENCES "Item"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ItemTransfer" ADD CONSTRAINT "ItemTransfer_toItemId_fkey" FOREIGN KEY ("toItemId") REFERENCES "Item"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Loan" ADD CONSTRAINT "Loan_borrowerCardId_fkey" FOREIGN KEY ("borrowerCardId") REFERENCES "Card"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- هر کاربر حداکثر یک کارت بانک شخصی داشته باشد
CREATE UNIQUE INDEX "Card_one_bank_per_user" ON "Card"("userId") WHERE "isBank" = true;