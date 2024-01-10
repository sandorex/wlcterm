import QtQuick
import QtQuick.Window
import QtWayland.Compositor
import QtWayland.Compositor.XdgShell

WaylandCompositor {
    WaylandOutput {
        sizeFollowsWindow: true
        window: Window {
            id: win

            property int selectedSurface: 0

            width: 1024
            height: 768
            visible: true

            Repeater {
                model: shellSurfaces
                ShellSurfaceItem {
                    anchors.fill: parent
                    shellSurface: modelData
                    onSurfaceDestroyed: shellSurfaces.remove(index)

                    // show only one surface for now
                    visible: index == win.selectedSurface
                    enabled: this.visible
                }
            }
        }
    }

    // this does not work
    //Shortcut { sequence: "space"; onActivated: win.selectedSurface = (win.selectedSurface + 1) % shellSurfaces.length }

    XdgShell {
        onToplevelCreated: (toplevel, xdgSurface) => {
            shellSurfaces.append({shellSurface: xdgSurface});
        }    
    }

    ListModel { id: shellSurfaces }
}
