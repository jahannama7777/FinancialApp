/*
  Warnings:

  - You are about to drop the `ItemTransfer` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "ItemTransfer" DROP CONSTRAINT "ItemTransfer_fromItemId_fkey";

-- DropForeignKey
ALTER TABLE "ItemTransfer" DROP CONSTRAINT "ItemTransfer_toItemId_fkey";

-- DropTable
DROP TABLE "ItemTransfer";
