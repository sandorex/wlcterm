import QtQuick
import QtQuick.Window
import QtWayland.Compositor
import QtWayland.Compositor.XdgShell
import QtQuick.Layouts

WaylandCompositor {
    WaylandOutput {
        sizeFollowsWindow: true
        window: Window {
            id: win

            width: 1024
            height: 720
            visible: true

            function onResize() {
                if (baseLayout.count != 0) {
                    toplevels.get(baseLayout.currentIndex).toplevel.sendFullscreen(Qt.size(this.width, this.height))
                }
            }
            onWidthChanged: { onResize() }
            onHeightChanged: { onResize() }

            Shortcut {
                sequence: "Alt+z"
                onActivated: {
                    if (baseLayout.count != 0) {
                        baseLayout.currentIndex = baseLayout.currentIndex + 1
                        if (baseLayout.currentIndex == baseLayout.count)
                            baseLayout.currentIndex = 0

                        baseLayout.children[baseLayout.currentIndex].focus = true
                        win.onResize()
                    }
                }
            }

            StackLayout {
                id: baseLayout
                anchors.fill: parent

                Repeater {
                    model: shellSurfaces
                    ShellSurfaceItem {
                        shellSurface: modelData
                        onSurfaceDestroyed: {
                            shellSurfaces.remove(index)
                            toplevels.remove(index)
                        }

                        // show only one surface for now
                        visible: index == win.selectedSurface
                        enabled: this.visible
                    }
                }
            }

            Rectangle {
                anchors.fill: parent
                color: "black"

                // this is the background
                z: -1
            }
        }
    }

    // TODO confirm closing
    //onClosing: (close) => {
    //    if (document.changed) {
    //        close.accepted = false
    //        confirmExitPopup.open()
    //    }
    //}

    XdgShell {
        onToplevelCreated: (toplevel, xdgSurface) => {
            shellSurfaces.append({shellSurface: xdgSurface})
            toplevels.append({toplevel: toplevel})
            toplevel.sendFullscreen(Qt.size(win.width, win.height))
        }
    }

    XdgDecorationManagerV1 {
        preferredMode: XdgToplevel.ServerSideDecoration
    }

    ListModel { id: shellSurfaces }
    ListModel { id: toplevels }
}
