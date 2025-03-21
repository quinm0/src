"use client"
import React from 'react';
import { Input } from './ui/input';
import { Button } from './ui/button';
import { api } from '~/trpc/react';
import { z } from 'zod';
import { useForm } from 'react-hook-form';
import { zodResolver } from "@hookform/resolvers/zod"
import { Form, FormControl, FormDescription, FormField, FormItem, FormLabel, FormMessage } from './ui/form';


export const createJobFormSchema = z.object({
  jobName: z.string().min(2, {
    message: "job name must be at least 2 characters.",
  }),
})

export default function CreateJob(){
  const {
    mutateAsync: createJob,
  } = api.job.create.useMutation();

  const form = useForm<z.infer<typeof createJobFormSchema>>({
    resolver: zodResolver(createJobFormSchema),
    defaultValues: {
      jobName: "",
    },
  })

  function onSubmit(values: z.infer<typeof createJobFormSchema>) {
    void createJob(values);
  }

  return (
    <Form {...form}>
      <form 
        onSubmit={form.handleSubmit(onSubmit)}
        className='space-y-8'
      >
        <FormField
          control={form.control}
          name={'jobName'}
          render={({field}) => (
            <FormItem>
              <FormLabel>Job Name</FormLabel>
              <FormControl>
                <Input {...field} />
              </FormControl>
              <FormDescription>
                Name of job
              </FormDescription>
              <FormMessage />
            </FormItem>
          )}
        />
      </form>
    </Form>
  )
}