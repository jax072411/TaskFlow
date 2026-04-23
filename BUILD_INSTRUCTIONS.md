# Build Instructions for TaskFlow Windows App

Since you cannot install Visual Studio C++ tools locally, we will use GitHub Actions to automatically build your Windows executable.

## Prerequisites
- A GitHub account (free)
- Git installed on your computer

## Step 1: Create a GitHub Repository

1. Go to [github.com/new](https://github.com/new)
2. Enter repository name: `TaskFlow` (or any name you prefer)
3. Set visibility to **Public** (GitHub Actions is free for public repos)
4. **Important**: Do NOT initialize with README or .gitignore (we have our own)
5. Click "Create repository"

## Step 2: Push Your Code to GitHub

Open PowerShell and run the following commands:

```powershell
# Navigate to your project directory
cd C:\taskflow

# Run the push script
.\push_to_github.ps1
```

When prompted, enter your GitHub repository URL (e.g., `https://github.com/yourusername/TaskFlow.git`)

## Step 3: Wait for Automatic Build

1. Go to your GitHub repository in the browser
2. Click on the **Actions** tab
3. You should see "Build Windows Release" workflow running
4. Wait for it to complete (usually takes 5-10 minutes)
5. When finished, you'll see a green checkmark ✅

## Step 4: Download Your Executable

1. On the Actions tab, click on the completed workflow run
2. Scroll down to the "Artifacts" section
3. Download the `taskflow-windows` zip file
4. Extract it to find your `TaskFlow.exe` file

The executable will be located in:
```
taskflow-windows/
├── TaskFlow.exe
├── flutter_windows.dll
└── other required DLLs
```

## Troubleshooting

### Workflow fails with "intl version conflict"
The workflow already includes a fix for the intl version conflict. If it still fails, check the workflow logs for details.

### Workflow fails with other errors
Check the Actions logs by clicking on the failed workflow run. The logs will show exactly what went wrong.

### Can't find the artifact
Ensure the workflow completed successfully (green checkmark). Artifacts are only available after successful completion.

## Alternative: Manual Build

If you have access to a Windows machine with Visual Studio installed locally:

1. Open PowerShell as Administrator
2. Run:
   ```powershell
   cd C:\taskflow
   flutter pub get
   flutter build windows --release
   ```
3. Find your executable at: `build\windows\runner\Release\TaskFlow.exe`

## Files Included in This Project

- `.github/workflows/build-windows.yml` - GitHub Actions workflow configuration
- `pubspec.yaml` - Flutter dependencies (with intl: 0.19.0 to avoid conflicts)
- `push_to_github.ps1` - Helper script to push code to GitHub
- This `BUILD_INSTRUCTIONS.md` file

## Next Steps

Once you have the executable:
1. Test it on a Windows machine
2. Distribute it to your users
3. For future updates, push changes to GitHub and the workflow will automatically rebuild

## Need Help?

If you encounter issues:
1. Check the workflow logs on GitHub
2. Ensure your project structure is correct
3. Make sure all dependencies are compatible with Flutter 3.29.3
