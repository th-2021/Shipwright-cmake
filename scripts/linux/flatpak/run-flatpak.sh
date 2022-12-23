flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak remove --user -y --noninteractive com.shipofharkinian.soh

#../flatpak-builder/flatpak-builder build -v --install-deps-from=flathub --force-clean --ccache --install com.shipofharkinian.soh.yaml
flatpak install --user -y --noninteractive flathub org.flatpak.Builder
~/.local/share/flatpak/exports/bin/org.flatpak.Builder build -v --install-deps-from=flathub --force-clean --ccache --install --user scripts/linux/flatpak/com.shipofharkinian.soh.yaml

flatpak build-bundle ~/.local/share/flatpak/repo/ soh.flatpak com.shipofharkinian.soh stable
