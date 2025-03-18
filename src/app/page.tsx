import { api, HydrateClient } from "~/trpc/server";
import { Button } from "./_components/ui/button";
import Link from "next/link";
import { auth } from "~/server/auth";
import CreateJob from './_components/createJob';

export default async function Home() {
  const session = await auth();

  // if (session?.user) {
  //   void api.post.getLatest.prefetch();
  // }

  const indexData = await api.homepage.index({ text: "world" });

  return (
    <HydrateClient>
      <main className="">
        <p>Hey thing {indexData.greeting}</p>
        <p>{indexData.thing.length} jobs</p>
        <p>NAME: {session?.user?.name ?? "logged out"}</p>
        {session?.user ? (
          <>
            <Link href={"/api/auth/signout"}>
              <Button>Log out</Button>
            </Link>
            <CreateJob />
          </>
        ) : (
          <Link href={"/api/auth/signin"}>
            <Button>Log in</Button>
          </Link>
        )}
      </main>
    </HydrateClient>
  );
}
