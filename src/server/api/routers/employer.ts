import { z } from "zod";

import {
  createTRPCRouter,
  protectedProcedure,
  publicProcedure,
} from "~/server/api/trpc";
import { employers } from "~/server/db/schema";

export const employerRouter = createTRPCRouter({
  create: protectedProcedure
    .input(z.object({
      name: z.string()
    }))
    .mutation(async ({input, ctx}) => {
      await ctx.db.insert(employers).values({
        name: input.name
      })
    })
});
