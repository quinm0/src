import { z } from "zod";

import {
  createTRPCRouter,
  protectedProcedure,
  publicProcedure,
} from "~/server/api/trpc";
import { jobs } from "~/server/db/schema";

export const homepageRouter = createTRPCRouter({
  index: publicProcedure
    .input(z.object({ text: z.string() }))
    .query(async ({ input, ctx }) => {
      const thing = await ctx.db.select().from(jobs);

      console.log(ctx.session);

      return {
        greeting: `Hello ${input.text}`,
        thing,
      };
    }),
});
