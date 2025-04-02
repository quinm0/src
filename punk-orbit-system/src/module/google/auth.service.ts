/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
import { Injectable, OnModuleInit } from '@nestjs/common';
import { Auth, google } from 'googleapis';
import { authenticate } from '@google-cloud/local-auth';
import { promises as fs } from 'fs';

export type Auth = Awaited<ReturnType<typeof authenticate>>;

@Injectable()
export class GoogleAuthService implements OnModuleInit{

  private clients: Map<string, Auth> = new Map();
  private CREDENTIALS_PATH = 'credentials.json';
  private TOKEN_PATH = 'tokens';

  async onModuleInit() {
    console.log('GoogleAuthService initalizing...');

    // load all tokens from the tokens folder into the clients map
    const files = await fs.readdir(this.TOKEN_PATH);
    for (const file of files) {
      const content = await fs.readFile(`${this.TOKEN_PATH}/${file}`);
      const keys = JSON.parse(content.toString());
      const client = google.auth.fromJSON(keys);
      this.clients.set(file.replace('.json', ''), client as Auth);
      console.log(`Loaded token for user ${file.replace('.json', '')}`);
    }

    if (this.clients.size === 0) {
      console.log('No tokens found, please authenticate first');
      await this.auth('me');
      console.log('Authenticated successfully');
    }

    console.log('GoogleAuthService initialized');
  }
  
  async saveCredentials(userId: string, client: Auth) {
    const content = await fs.readFile(this.CREDENTIALS_PATH);
    const keys = JSON.parse(content.toString());
    const key = keys.installed || keys.web;
    const payload = JSON.stringify({
      type: 'authorized_user',
      client_id: key.client_id,
      client_secret: key.client_secret,
      refresh_token: client.credentials.refresh_token,
    });
    await fs.writeFile(`${this.TOKEN_PATH}/${userId}.json`, payload);
  }

  async initCredentialsFile() {
    const credentials = {
      installed: {
        client_id: process.env.GCLOUD_CLIENT_ID,
        project_id: process.env.GCLOUD_PROJECT_ID,
        auth_uri: process.env.GCLOUD_AUTH_URI,
        token_uri: process.env.GCLOUD_TOKEN_URI,
        auth_provider_x509_cert_url: process.env.GCLOUD_AUTH_PROVIDER_CERT_URL,
        client_secret: process.env.GCLOUD_CLIENT_SECRET,
        redirect_uris: process.env.GCLOUD_REDIRECT_URIS?.split(','),
      },
    };

    // Assume the credentials.json file already exists, just overwrite it
    await fs.writeFile(this.CREDENTIALS_PATH, JSON.stringify(credentials, null, 2));

    // ensure file is written and reflected in cache
    await fs.access(this.CREDENTIALS_PATH);

    console.log('Credentials file initialized successfully');
  }

  private async auth(user: string){

    await this.initCredentialsFile();

    // await 10s delay to ensure file is written
    await new Promise((resolve) => setTimeout(resolve, 10000));
    
    const auth = await authenticate({
      scopes: ['https://www.googleapis.com/auth/gmail.readonly'],
      keyfilePath: this.CREDENTIALS_PATH,
    });

    if (auth.credentials) {
      await this.saveCredentials(user, auth);
    }

    return auth;
  }

  public async getAuth(user: string): Promise<Auth> {
    const client = this.clients.get(user);

    if (!client) {
      throw new Error(`No client found for user ${user}`);
    }

    return client;
  }

}
