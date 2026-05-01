# Git Basic Commands Cheat Sheet

## Configure Git
```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
git config --list
```

## Initialize Repository
```bash
git init
```

## Clone Repository
```bash
git clone <repo-url>
```

## Check Status
```bash
git status
```

## Add Files
```bash
git add .
git add <file-name>
```

## Commit Changes
```bash
git commit -m "Your commit message"
```

## View Commit History
```bash
git log
git log --oneline
```

## Connect Remote Repository
```bash
git remote add origin <repo-url>
git remote -v
```

## Push Code
```bash
git push -u origin main
git push
```

## Pull Latest Changes
```bash
git pull
```

## Fetch Changes
```bash
git fetch
```

## Branch Commands
```bash
git branch
git branch <branch-name>
git checkout <branch-name>
git switch <branch-name>
git checkout -b <branch-name>
```

## Merge Commands
```bash
git merge <branch-name>
git merge --no-ff <branch-name>
git merge --abort
```

## Delete Branch
```bash
git branch -d <branch-name>
git branch -D <branch-name>
```

## Check Current Branch
```bash
git branch --show-current
```

## See Differences
```bash
git diff
```

## Restore Changes
```bash
git restore <file-name>
git restore --staged <file-name>
```

## Reset Commits
```bash
git reset --soft HEAD~1
git reset --hard HEAD~1
```

## Stash Changes
```bash
git stash
git stash pop
```

## Remove File
```bash
git rm <file-name>
```

## Rename File
```bash
git mv <old-name> <new-name>
```

## Tags
```bash
git tag <tag-name>
git push origin --tags
```

## Typical Daily Workflow
```bash
git status
git add .
git commit -m "Updated project"
git push
```

## First Time GitHub Push
```bash
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin <repo-url>
git push -u origin main
```

## Typical Branch Workflow
```bash
git checkout -b feature-login

git add .
git commit -m "Added login feature"

git checkout main
git pull

git merge feature-login

git push
```