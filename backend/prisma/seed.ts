import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  const username = process.env.SEED_USERNAME;
  const password = process.env.SEED_PASSWORD;
  if (!username || !password) {
    throw new Error('SEED_USERNAME and SEED_PASSWORD are required');
  }
  const passwordHash = await bcrypt.hash(password, 10);
  const user = await prisma.user.upsert({
    where: { username },
    update: { passwordHash },
    create: {
      username,
      passwordHash,
      name: process.env.SEED_NAME ?? username,
    },
  });

  console.log('seeded user id', user.id);
}

main().finally(() => prisma.$disconnect());
