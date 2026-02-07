# Windows Backup Checklist

Backup personal files from Windows installation before ZenaOS install.

> **Goal:** Preserve documents, photos, videos, and other personal data.
> **Not needed:** Programs, games, system files (will do fresh install)

---

## Preparation

### 1. Boot Into Windows
- [ ] Ensure laptop boots to Windows (not Fedora USB)
- [ ] Log in to your Windows account

### 2. Prepare Backup Destination
Choose one or more:
- [ ] **External HDD/SSD** - Fastest for large files
- [ ] **USB Flash Drive** - For smaller important files
- [ ] **Cloud Storage** - OneDrive, Google Drive, Dropbox
- [ ] **Network Drive/NAS** - If available

---

## Files to Backup

### User Profile Folders
Location: `C:\Users\<YourUsername>\`

- [ ] **Documents** - `Documents\`
  - Word docs, PDFs, spreadsheets
  - Any project files

- [ ] **Pictures** - `Pictures\`
  - Photos
  - Screenshots
  - Wallpapers you want to keep

- [ ] **Videos** - `Videos\`
  - Personal videos
  - Downloaded content

- [ ] **Music** - `Music\` (if any local files)

- [ ] **Downloads** - `Downloads\`
  - Check for anything important you forgot to move
  - ISOs, installers you might want again

- [ ] **Desktop** - `Desktop\`
  - Files saved to desktop
  - Don't forget shortcuts to files (find the actual files)

### Special Locations

- [ ] **OneDrive** - `C:\Users\<Username>\OneDrive\`
  - Should sync to cloud, but verify
  - Check offline-only files

- [ ] **Game Saves** (if any non-Steam saves)
  - Check `Documents\My Games\`
  - Check `AppData\Local\` and `AppData\Roaming\` for specific games

- [ ] **Browser Data**
  - Bookmarks (export from Chrome/Firefox/Edge)
  - Saved passwords (use a password manager!)
  - Extensions list (screenshot or note down)

- [ ] **Email** (if using local client)
  - Export Outlook data if applicable
  - Most email is cloud-based now, verify

### Application Data Worth Checking

- [ ] **SSH Keys** - Check if any exist:
  - `C:\Users\<Username>\.ssh\`

- [ ] **WSL Data** - If you used Windows Subsystem for Linux:
  - Export important files from WSL distros
  - `wsl --export <distro> backup.tar`

- [ ] **Development Projects** - Any code not in git:
  - Check common locations: Desktop, Documents, custom folders

- [ ] **Virtual Machines** - VirtualBox/VMware VMs if any

### Don't Forget

- [ ] **Custom Fonts** - `C:\Windows\Fonts\` (user-installed only)
- [ ] **License Keys** - Document any software licenses
- [ ] **Authenticator Apps** - Ensure 2FA is backed up properly
- [ ] **Bookmarks** - Export from all browsers

---

## Backup Process

### Quick Method: Robocopy (Recommended)
Open PowerShell as Administrator:

```powershell
# Backup Documents
robocopy "C:\Users\YourUsername\Documents" "E:\Backup\Documents" /E /Z /R:3 /W:10

# Backup Pictures
robocopy "C:\Users\YourUsername\Pictures" "E:\Backup\Pictures" /E /Z /R:3 /W:10

# Backup Videos
robocopy "C:\Users\YourUsername\Videos" "E:\Backup\Videos" /E /Z /R:3 /W:10

# Backup Desktop
robocopy "C:\Users\YourUsername\Desktop" "E:\Backup\Desktop" /E /Z /R:3 /W:10

# Backup Downloads (optional, check first)
robocopy "C:\Users\YourUsername\Downloads" "E:\Backup\Downloads" /E /Z /R:3 /W:10
```

Replace:
- `YourUsername` with your Windows username
- `E:\Backup` with your backup drive path

Flags:
- `/E` - Copy subdirectories including empty ones
- `/Z` - Restartable mode (can resume if interrupted)
- `/R:3` - Retry 3 times on failure
- `/W:10` - Wait 10 seconds between retries

### Alternative: File Explorer
1. Open File Explorer
2. Navigate to `C:\Users\<Username>\`
3. Select folders: Documents, Pictures, Videos, Desktop
4. Right-click → Copy
5. Navigate to backup drive
6. Right-click → Paste

### For Cloud Backup
1. Install cloud client (OneDrive, Google Drive, Dropbox)
2. Move files to synced folder
3. Wait for upload to complete
4. Verify files appear in web interface

---

## Verification

Before wiping Windows:

- [ ] **Check file counts** - Compare source vs backup
- [ ] **Open sample files** - Verify files aren't corrupted
- [ ] **Check hidden files** - Enable "Show hidden files" in Explorer
- [ ] **Verify cloud sync** - Check web interface for cloud backups
- [ ] **Test external drive** - Unmount and remount, files still there?

---

## Accessing Backup from ZenaOS

Once ZenaOS is installed:

```bash
# Mount external drive
sudo mount /dev/sdX1 /mnt/backup

# Copy files to new home
cp -r /mnt/backup/Documents ~/Documents
cp -r /mnt/backup/Pictures ~/Pictures
cp -r /mnt/backup/Videos ~/Videos

# Set correct ownership
sudo chown -R $USER:$USER ~/Documents ~/Pictures ~/Videos
```

Or use a file manager like Nautilus/Dolphin/Thunar to drag and drop.

---

## Post-Backup Notes

After backup is complete and verified:
- [ ] Document what was backed up and where
- [ ] Note any files that couldn't be backed up (in use, permissions)
- [ ] Keep backup drive safe until ZenaOS is fully working
- [ ] Consider keeping Windows backup for 1-2 weeks after migration

---

## Size Estimates

Check your folder sizes before backup:

```powershell
# In PowerShell
Get-ChildItem -Path "C:\Users\YourUsername" -Recurse |
    Measure-Object -Property Length -Sum |
    Select-Object @{Name="Size(GB)";Expression={[math]::Round($_.Sum/1GB,2)}}
```

Or right-click each folder → Properties to see size.

---

*Created: 2026-02-06*
