# hyprdashboard-qt6
Dashboard / Launcher for hyprland

This project is not yet finished but maybe worth to take a look already.

## Dependencies:
Arch Linux: `sudo pacman -Syu base-devel qt6-base qt6-declarative qt6-svg cmake ninja`

Ubuntu noble: `sudo apt install build-essential cmake ninja-build qt6-base-dev qt6-declarative-dev qml-module-qtquick2 libgl1-mesa-dev libxkbcommon-dev`
(there is still a qt6 dependency issue: although the binary compiles successfullly on ubuntu, it does not launch - it's on my #todo list ;-) - please use a distrobox to build and run on arch instead or by chance post a solution in the issue tracker.)

KDE neo: all qt6 deps should be either already installed or easily to install.

NixOs: copy `flake.nix` and `build.nix` into an empty folder. Run `nix build` inside that folder - after building you can find the binary in `./result/bin`

flatpak: run `flatpak-builder --force-clean --user --install-deps-from=flathub --repo=repo --install builddir de.inquies.hyprdash.yml` ... result is inside of builddir

## Building & Running:
`cmake -S. -B./build -G Ninja`

`cmake --build ./build --config Debug --target hyprdash --`

`./hyprdash.sh -s` to bring up a socket server for receiving commands

`./hyprdash.sh -d` to toggle dashboard

In your hyprland config:

`exec-once /path/to/hyprdash.sh -s`

and a binding to a keyboard shortcut like: `bind = $mainMod, D, exec, /path/to/hyprdash.sh -d` in order to toggle dashboard.

 ## Configuration:
 copy `hyprdash.json.example` to `~/.config/hyprdash/hyprdash.json` - it should speak for itself.
... always keep a backup! If there is any json syntax error, the file will be overwritten.

## short preview:
check `preview.mp4`
