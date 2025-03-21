import { z } from "zod";
import { createJobFormSchema } from '~/app/_components/createJob';

import {
  createTRPCRouter,
  protectedProcedure,
  publicProcedure,
} from "~/server/api/trpc";
import { jobs } from "~/server/db/schema";

export const jobRouter = createTRPCRouter({
  create: protectedProcedure
    .input(createJobFormSchema)
    .mutation(async ({input, ctx}) => {
      await ctx.db.insert(jobs).values({
        title: input.jobName
      })
    })
});
