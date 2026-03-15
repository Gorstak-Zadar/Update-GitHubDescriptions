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

---

## Disclaimer

**NO WARRANTY.** THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.

**Limitation of Liability.** IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MODIFIES AND/OR CONVEYS THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
