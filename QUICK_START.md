# Quick Start Guide for Building TaskFlow Windows Executable

## The Problem
You cannot install Visual Studio C++ tools locally, so we use GitHub Actions to build your app automatically.

## The Solution
1. Create a GitHub repository
2. Push your code
3. Download the built .exe from GitHub Actions

## What You Need to Do Right Now

### Step 1: Create GitHub Repository (2 minutes)
1. Go to: https://github.com/new
2. Enter name: `TaskFlow`
3. Select: **Public** (free for GitHub Actions)
4. **IMPORTANT**: Do NOT initialize with README
5. Click "Create repository"
6. Copy the repository URL (you'll need it next)

### Step 2: Push Your Code to GitHub (3 minutes)

Open **PowerShell as Administrator** and run:

```powershell
cd C:\taskflow

# Add all files and commit
git init
git add .
git commit -m "Initial commit: TaskFlow"

# Connect to GitHub (replace with YOUR URL)
git remote add origin https://github.com/YOUR_USERNAME/TaskFlow.git
git branch -M main
git push -u origin main
```

**OR** use the helper script (easier):
```powershell
cd C:\taskflow
.\push_to_github.ps1
# When prompted, paste your GitHub repository URL
```

### Step 3: Wait for Automatic Build (5-10 minutes)

1. Go to your GitHub repository in browser
2. Click **"Actions"** tab
3. You'll see "Build Windows Release" running
4. Wait for the green checkmark ✅

### Step 4: Download Your .exe (2 minutes)

1. Click on the completed workflow run
2. Scroll to **"Artifacts"** section
3. Download `taskflow-windows.zip`
4. Extract to find `TaskFlow.exe`

## What Gets Built

The artifact contains:
- `TaskFlow.exe` - Your main application
- `flutter_windows.dll` - Flutter engine
- Various .dll files - Required libraries

**Total size:** ~30-50 MB (compressed in zip)

## Files Provided in This Project

| File | Purpose |
|------|---------|
| `.github/workflows/build-windows.yml` | Automatic build configuration |
| `push_to_github.ps1` | Helper script to push code |
| `BUILD_INSTRUCTIONS.md` | Detailed instructions |
| `SETUP_GITHUBActions.md` | Complete guide |

## Common Issues

**"Workflow not starting"**
- Ensure you pushed to `main` or `master` branch
- Check the `.github/workflows/build-windows.yml` file exists

**Workflow fails**
- Click on the failed workflow in Actions tab
- Expand the failed step to see the error
- Most common: dependency conflicts (already fixed in workflow)

**Can't find .exe in artifacts**
- Workflow might still be running
- Click on the workflow run to see progress
- Only successful builds have artifacts

## Testing Your App

Once you have `TaskFlow.exe`:
1. Copy it to any Windows computer
2. Double-click to run
3. No installation required
4. Works offline

## Next Steps After Download

1. Test the app thoroughly
2. Share the .exe with users
3. For updates: push code → workflow builds automatically
4. Download new .exe from Actions tab

## Why This Works

✅ GitHub provides Windows servers with Visual Studio pre-installed
✅ No cost for public repositories
✅ Automatic builds on every code push
✅ Easy sharing of executable files

## Need Help?

Read the detailed guides:
- `BUILD_INSTRUCTIONS.md` - Step-by-step with screenshots
- `SETUP_GITHUBActions.md` - Complete technical guide
- `README.md` - Project overview
