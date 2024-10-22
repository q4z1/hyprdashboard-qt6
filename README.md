# hyprdashboard-qt6
Dashboard / Launcher for hyprland

Arch Linux: sudo pacman -Syu base-devel qt6-base qt6-declarative qt6-svg cmake ninja

Ubuntu noble: sudo apt install build-essential cmake ninja-build qt6-base-dev qt6-declarative-dev qml-module-qtquick2 libgl1-mesa-dev libxkbcommon-dev

## for creating a nixos qt6 dev environment there exists a flake.nix file

### Bulding & Running:
`cmake -S. -B./build -G Ninja`

`cmake --build ./build --config Debug --target hyprdash --` # build

`./hyprdash.sh` # run


