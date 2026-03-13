# Update-GitHubDescriptions

> Bulk-updates GitHub repository descriptions by extracting short summaries from the top of each local README.md.

Requires [GitHub CLI](https://cli.github.com/) (`gh`) and a local clone of all repos under `d:\Gorstak`. Reads each `README.md`, picks the first blockquote or paragraph, trims markdown, and runs `gh repo edit` to set the description.

## Usage

```powershell
.\Update-GitHubDescriptions.ps1
```

Ensure `gh auth login` has been run first.
