# otabi.net

## Requirements
- Nix with flakes

or
- NodeJS
- pnpm
- terraform

## Development
Run `nix develop` and all the requirements you need are provided.

### Web page with Astro
1. Install the NodeJS dependencies with `pnpm install`.
2. Run `pnpm run dev`.

### Cloudflare Pages with terraform
1. Set up your cloudflare account and your domain.
2. Get your credentials for cloudflare. (api tokens, zone id, account id)
3. Go to the `deploy` directory with `cd deploy`.
4. Initialize the directory with `terraform init`.
5. Deploy with `terraform apply`.
