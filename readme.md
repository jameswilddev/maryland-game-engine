# Maryland Game Engine

Simple game engine.

## Deployment

The [GitHub Action](./.github/workflows/main.yaml) will build the SPA, upload it to a S3 bucket (configured to allow public HTTP reads), then invalidate a Cloudflare cache (which sits in front and provides HTTPS).

### Configuring GitHub secrets

Add the following secrets on GitHub:

#### `DOMAIN`

This is:

- The name of the S3 bucket which will be uploaded to.
- The public URL which Cloudflare will host.

For example, for `https://www.google.com/`, this would be `www.google.com` - no protocol, no trailing slash.

#### `AWS_ACCESS_KEY_ID`/`AWS_SECRET_ACCESS_KEY`

The access key ID and secret access key of an IAM user with the following permissions against the S3 bucket and objects within:

- `PutObject`
- `PutObjectAcl`
- `GetObject`
- `ListBucket`
- `DeleteObject`
- `GetBucketLocation`

#### `CLOUDFLARE_TOKEN`/`CLOUDFLARE_ZONE`

A Cloudflare access token with the `Zone.Cache Purge` permission.  The Zone ID can be found on your domain's dashboard.

### Triggering a deployment

To trigger a deployment, create a GitHub release.  The name/version of the GitHub release will be included in the deployed HTML.