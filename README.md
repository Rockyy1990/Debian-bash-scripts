
# Debian System Configuration Guide

This guide provides steps to add `non-free` and `contrib` repositories, update and upgrade the system, clean unnecessary packages, and set environment variables in `/etc/environment`.

---

## 1. Add `contrib` and `non-free` repositories

Edit your `/etc/apt/sources.list` to include `contrib` and `non-free` components.

```bash
sudo nano /etc/apt/sources.list
```

Find your repository lines (they typically look like):
```
deb http://deb.debian.org/debian/ bullseye main
```

Modify them to include `contrib` and `non-free`, for example:

```
deb http://deb.debian.org/debian/ bullseye main contrib non-free
```

If you have multiple lines, update each accordingly.

Save and exit the editor.

---

## 2. Update the package list

```bash
sudo apt update
```

This fetches the latest package information from the repositories.

---

## 3. Upgrade the system

To upgrade all installed packages to their latest versions:

```bash
sudo apt upgrade -y
```

For a full upgrade (handles dependency changes):

```bash
sudo apt full-upgrade -y
```

---

## 4. Clean unnecessary packages

Remove packages that are no longer needed:

```bash
sudo apt autoremove -y
sudo apt clean
```

---

## 5. Set environment variables in `/etc/environment`

Edit `/etc/environment` to include your desired variables:

```bash
sudo nano /etc/environment
```

Add or modify entries as needed. For example:

```plaintext
# Set /etc/environment variables
echo -e "
CPU_LIMIT=0
CPU_GOVERNOR=performance
GPU_USE_SYNC_OBJECTS=1
PYTHONOPTIMIZE=1
ELEVATOR=kyber
TRANSPARENT_HUGEPAGES=always
MALLOC_CONF=background_thread:true
MALLOC_CHECK=0
MALLOC_TRACE=0
LD_DEBUG_OUTPUT=0
LP_PERF=no_mipmap,no_linear,no_mip_linear,no_tex,no_blend,no_depth,no_alphatest
LESSSECURE=1
PAGER=less
EDITOR=nano
VISUAL=nano
AMD_VULKAN_ICD=RADV
RADV_PERFTEST=aco,sam,nggc
RADV_DEBUG=novrsflatshading
GAMEMODE=1
vblank_mode=1
PROTON_LOG=0
PROTON_USE_WINED3D=0
PROTON_FORCE_LARGE_ADDRESS_AWARE=1
PROTON_NO_ESYNC=1
PROTON_USE_FSYNC=1
DXVK_ASYNC=1
WINE_FSR_OVERRIDE=1
WINE_FULLSCREEN_FSR=1
WINE_VK_USE_FSR=1
WINEFSYNC_FUTEX2=1
WINEFSYNC_SPINCOUNT=24
MESA_BACK_BUFFER=ximage
MESA_NO_DITHER=0
MESA_SHADER_CACHE_DISABLE=false
mesa_glthread=true
MESA_DEBUG=0
" | sudo tee -a /etc/environment
```

Save and exit.

**Note:** Changes to `/etc/environment` require re-login or reboot to take effect.

---

## 6. Enable trim

```bash
sudo systemctl enable fstrim.timer
sudo fstrim -av
```



## Additional Tips

- Always backup configuration files before editing.
- After modifying `/etc/environment`, log out and log back in or reboot to apply changes.
- For more complex environment setup, consider editing `/etc/profile` or user-specific files like `~/.profile`.

---

**End of Guide**
```