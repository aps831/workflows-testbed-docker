# Basic Template

## Usage

To use this repository as a template run
`gh repo create <repo_name> --clone --private -p aps831/basic-template`.

Replace `--private` with `--public` as necessary.

Once cloned:

-   run the init script `init.sh`
-   delete the init script `init.sh`
-   update `username` and `repositoryname` in `.github/workflows/bitbucket-mirror.yaml`
-   update `.github/dependabot.yml`
-   update `LICENCE.md`, if a public repo
-   remove codeql workflows as appropriate, if a public repo
