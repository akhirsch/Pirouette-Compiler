+++
title = "Git Workflow for Content Teams"
description = "How to use Git and pull requests to manage content on static sites, even if you're not a developer."
date = 2024-12-08
[taxonomies]
tags = ["git", "workflow", "static-sites"]
+++

# Git Workflow for Content Teams

Static sites store content as files in a Git repository. This unlocks powerful workflows for content teams.

## Why Git for Content?

Traditional CMS platforms have their own versioning, but Git offers:

- **Complete history**: Every change is tracked forever
- **Branching**: Work on drafts without affecting the live site
- **Review process**: Pull requests for editorial review
- **Rollback**: Instantly revert any change
- **Collaboration**: Multiple people can work simultaneously

## The Basic Workflow

### 1. Create a Branch

Never work directly on `main`. Create a branch for your changes:

```bash
git checkout -b post/new-article-title
```

### 2. Make Your Changes

Edit or create Markdown files in the `content/` directory:

```markdown
+++
title = "My New Article"
date = 2024-12-08
+++

Article content goes here...
```

### 3. Commit Your Work

Save your changes with a descriptive message:

```bash
git add content/my-new-article.md
git commit -m "Add article about Git workflows"
```

### 4. Push and Create a Pull Request

```bash
git push origin post/new-article-title
```

Then create a pull request on GitHub for review.

### 5. Review and Merge

Team members can:
- Comment on specific lines
- Suggest edits
- Preview the changes (with deploy previews)
- Approve and merge

## Deploy Previews

Services like Netlify and Vercel create preview URLs for every pull request. This lets editors see exactly how their changes will look before merging.

## Branch Naming Conventions

Use consistent prefixes:

- `post/` - New blog posts
- `docs/` - Documentation updates
- `fix/` - Corrections and typos
- `feature/` - New site features

## Handling Conflicts

If two people edit the same file:

```bash
git pull origin main
# Resolve conflicts in your editor
git add .
git commit -m "Resolve merge conflict"
```

## Tips for Non-Developers

1. **Use GitHub's web editor** for simple changes
2. **Use a desktop app** like GitHub Desktop or VS Code
3. **Write good commit messages** describing what and why
4. **Don't fear branches** - they're cheap and easy to delete
5. **Ask for help** - Git has a learning curve

## Automating Quality Checks

Add CI checks to catch issues before merge:

- Spell checking
- Link validation
- Build verification
- Image optimization

Git transforms content management from a black box into a transparent, collaborative process.
