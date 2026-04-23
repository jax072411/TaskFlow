# GitHub Actions Setup Guide for TaskFlow Windows Build

This guide will help you set up automatic Windows builds using GitHub Actions.

## Why GitHub Actions?

- ✅ **Free for public repositories** - No cost to build your app
- ✅ **No Visual Studio needed** - GitHub provides Windows runners with all tools pre-installed
- ✅ **Automatic builds** - Every push automatically builds your app
- ✅ **Easy download** - Get your .exe file as a downloadable artifact

## Step 1: Create a GitHub Repository

1. **Sign in to GitHub** at [github.com](https://github.com)
2. **Create a new repository**:
   - Click the "+" icon in top-right → "New repository"
   - Name: `TaskFlow` (or your preferred name)
   - Description: "A comprehensive project management tool"
   - **Visibility: Public** (crucial - GitHub Actions is free for public repos)
   - **Initialize with README: NO** (we have our own files)
   - **Add .gitignore: NO** (we have our own .gitignore)
   - Click "Create repository"

3. **Copy the repository URL**:
   - You'll see a URL like: `https://github.com/YOUR_USERNAME/TaskFlow.git`
   - Copy this URL - you'll need it in the next step

## Step 2: Push Your Code to GitHub

Open PowerShell as Administrator and run these commands:

```powershell
# Navigate to your project directory
cd C:\taskflow

# Initialize Git (if not already done)
git init

# Add all files to Git
git add .

# Commit the files
git commit -m "Initial commit: TaskFlow with GitHub Actions workflow"

# Rename branch to main
git branch -M main

# Add your GitHub repository (replace with YOUR actual URL)
git remote add origin https://github.com/YOUR_USERNAME/TaskFlow.git

# Push to GitHub
git push -u origin main
```

**Alternative**: Run the provided script and enter your URL when prompted:
```powershell
cd C:\taskflow
.\push_to_github.ps1
```

## Step 3: Verify the Workflow

1. **Go to your GitHub repository** in the browser
2. **Click the "Actions" tab**
3. You should see "Build Windows Release" workflow
4. The workflow should start automatically
5. Wait for it to complete (5-10 minutes)

**Status indicators:**
- 🟡 Yellow circle: Running
- 🟢 Green check: Success
- 🔴 Red X: Failed

## Step 4: Download Your Executable

Once the workflow completes successfully:

1. Click on the workflow run (click on the workflow name)
2. Scroll down to the **"Artifacts"** section
3. Download `taskflow-windows` zip file
4. Extract the zip to find:
   - `TaskFlow.exe` (your main application)
   - `flutter_windows.dll` (Flutter engine)
   - Other required DLL files

## Step 5: Test Your Application

1. Copy the extracted files to any Windows computer
2. Double-click `TaskFlow.exe` to run
3. The app should launch without requiring installation

## Troubleshooting

### Workflow fails with dependency errors
Check the workflow logs:
1. Go to Actions tab
2. Click on the failed workflow
3. Expand the failed step to see detailed error messages

### intl version conflict
The workflow includes a fix for this. If it still fails, manually update `pubspec.yaml`:
```yaml
dependencies:
  intl: 0.19.0  # Change from ^0.20.2
```

### "TaskFlow.exe" not found in artifacts
The build might have failed. Check the logs to see what went wrong.

### Workflow doesn't start
- Ensure you pushed to the `main` or `master` branch
- Check that the `.github/workflows/build-windows.yml` file exists
- Verify the file is on the main branch

## Updating Your App

To build a new version:

1. Make changes to your code
2. Commit and push changes:
   ```powershell
   git add .
   git commit -m "Your changes description"
   git push origin main
   ```
3. The workflow will automatically run
4. Download the new executable from Actions tab

## File Structure After Setup

```
TaskFlow/
├── .github/
│   └── workflows/
│       └── build-windows.yml    # GitHub Actions workflow
├── lib/                         # Your Dart code
├── windows/                     # Windows-specific code
├── pubspec.yaml                 # Dependencies (with intl: 0.19.0)
├── .gitignore                   # Git ignore rules
├── README.md                    # Project documentation
├── BUILD_INSTRUCTIONS.md        # This file
└── push_to_github.ps1           # Helper script
```

## Benefits of This Setup

✅ **No Visual Studio required** on your local machine
✅ **Always up-to-date builds** - GitHub uses latest Windows and tools
✅ **Shareable builds** - Download and share the .exe with anyone
✅ **Version control** - Every build is tied to a specific code version
✅ **Free** - Unlimited builds for public repositories

## Next Steps

Once you have your executable:
1. Test it thoroughly on different Windows versions
2. Consider code signing for distribution (optional)
3. Share the .exe with your users
4. For updates, push new code and download new builds

## Need Help?

If you encounter issues:
1. Check the workflow logs on GitHub (most detailed info)
2. Ensure your `pubspec.yaml` dependencies are compatible
3. Verify your Flutter version (3.29.3 recommended)
4. Make sure you're pushing to the correct branch (main/master)
