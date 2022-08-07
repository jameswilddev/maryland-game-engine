# Maryland Game Engine

Simple game engine.

## Deployment

To trigger a deployment, [create a GitHub release](https://github.com/jameswilddev/maryland_game_engine/releases/new), and the [GitHub Action](./.github/workflows/main.yaml) will automatically start producing artifacts.  The name/version of the GitHub release must be of the format `v{major}.{minor}.{patch}` and will be included in the build artifacts automatically.

### Web

The web build is uploaded to a S3 bucket configured to allow public HTTP reads, and a Cloudflare cache which sits in front to provide HTTPS is automatically invalidated.

#### Configuring GitHub secrets

Add the following secrets on GitHub:

##### `DOMAIN`

This is:

- The name of the S3 bucket which will be uploaded to.
- The public URL which Cloudflare will host.

For example, for `https://www.google.com/`, this would be `www.google.com` - no protocol, no trailing slash.

##### `AWS_ACCESS_KEY_ID`/`AWS_SECRET_ACCESS_KEY`

The access key ID and secret access key of an IAM user with the following permissions against the S3 bucket and objects within:

- `PutObject`
- `PutObjectAcl`
- `GetObject`
- `ListBucket`
- `DeleteObject`
- `GetBucketLocation`

##### `CLOUDFLARE_TOKEN`/`CLOUDFLARE_ZONE`

A Cloudflare access token with the `Zone.Cache Purge` permission.  The Zone ID can be found on your domain's dashboard.
