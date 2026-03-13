# Update-GitHubDescriptions

> Bulk-updates GitHub repository descriptions from a dedicated `<!-- description: ... -->` block in each README.md.

Requires [GitHub CLI](https://cli.github.com/) (`gh`) and local clones under `d:\Gorstak`.

## Format

Add at the top of each README.md:

```html
<!-- description: Your one-line description for GitHub (max 350 chars) -->
```

The extraction script reads this first. Edit it to control what appears as the repo description.

## Scripts

| Script | Purpose |
|--------|---------|
| `Add-ReadmeDescriptions.ps1` | Adds `<!-- description: ... -->` to READMEs that lack it (seeds from current GitHub description) |
| `Update-GitHubDescriptions.ps1` | Reads the description block (or fallback blockquote), runs `gh repo edit` for each repo |

## Usage

1. **One-time setup:** Run `Add-ReadmeDescriptions.ps1` to add the description block to all READMEs.
2. **Edit** the `<!-- description: ... -->` lines in each README to improve them.
3. **Update GitHub:** Run `Update-GitHubDescriptions.ps1` to push descriptions.

```powershell
.\Add-ReadmeDescriptions.ps1
# ... edit READMEs ...
.\Update-GitHubDescriptions.ps1
```
