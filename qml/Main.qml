/*
 * Copyright (C) 2020  Benoît Rouits
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * ubuntu-calculator-app is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.7
import QtQml 2.2
import QtQuick.Window 2.2
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import QtMultimedia 5.9
import Ubuntu.Content 1.3
import TempPath 1.0

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'mirror.brouits'
    automaticOrientation: true

    anchors.fill: parent

    property var exportTransfer
    property list<ContentItem> snapshotItems
    property bool exportRequested

    Component {
        id: snapComponent
        ContentItem {
        }
    }

    Settings {
        id: settings
        property alias frame: frame.color
    }

    PageStack {
        id: pages
        anchors.fill: parent

        Component.onCompleted: pages.push(main)

        Page {
            id: main
            anchors.fill: parent
            visible: false

            header: PageHeader {
                id: header
                title: i18n.tr('Mirror')
                trailingActionBar.actions: [
                    Action {
                        iconName: "settings"
                        text: i18n.tr("Settings")
                        onTriggered: {
                            PopupUtils.open(dialog)
                        }
                    }
                ]
            }

            Camera {
                id: camera
                position: Camera.FrontFace
                imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceAuto
                exposure {
                    exposureCompensation: -1.0
                    exposureMode: Camera.ExposurePortrait
                }

                flash.mode: Camera.FlashOff

                imageCapture {
                    onImageCaptured: {
                        snapshotItems = []
                        photoPreview.source = preview

                        var path = TempPath.path + '/' + "mirror.jpg";
                        clock.visible = false
                        info.text = ""
                        photoPreview.visible = true

                        photoPreview.grabToImage(function (result) { result.saveToFile(path); info.text = i18n.tr("Share your Snapshot!"); });
                        var item = snapComponent.createObject(root, { "url": path })
                        snapshotItems.push(item)
                    }
                }
            }

            Rectangle {
                id: frame
                color: "pink"
                radius: units.gu(2)
                anchors {
                    top: header.bottom
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }

                border {
                    width: units.gu(2)
                    color: frame.color
                }

                VideoOutput {
                    id: videoOutput

                    anchors {
                        margins: units.gu(2)
                        fill: parent
                    }

                    autoOrientation: true
                    fillMode: VideoOutput.PreserveAspectCrop
                    source: camera
                    visible: !photoPreview.visible

                    MultiPointTouchArea {
                        anchors.fill: parent
                        maximumTouchPoints: 2
                        minimumTouchPoints: 1
                        mouseEnabled: true

                        onReleased: {
                            clock.visible = true;
                            timer.start()
                        }
                    }
                }
            }

            Image {
                id: photoPreview
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                visible: false

                Text {
                    id: info
                    anchors.centerIn: parent
                    font.pixelSize: units.gu(3)
                    font.bold: true
                    color: "white"
                }

                MultiPointTouchArea {
                    anchors.fill: parent
                    maximumTouchPoints: 2
                    minimumTouchPoints: 1
                    mouseEnabled: true

                    onReleased: {
                        photoPreview.visible = false;
                        if (root.exportRequested) {
                            root.exportTransfer.items = snapshotItems
                            root.exportTransfer.state = ContentTransfer.Charged
                        } else if (snapshotItems.length > 0) {
                            pages.push(sharePage)
                        }
                    }
                }
            }

            Image {
                id: clock
                visible: false
                anchors.centerIn: parent
                source: "../assets/clock.png"
            }

            Timer {
                id: timer
                onTriggered: {
                    camera.imageCapture.capture()
                }
            }

            Component {
                id: dialog

                Dialog {
                    id: options
                    anchors {
                        fill: parent
                    }

                    title: i18n.tr("Preferences")
                    text: i18n.tr("Mirror frame color:")

                    Button {
                        text: "pink"
                        color: text
                        onClicked: {
                            settings.frame = color
                            PopupUtils.close(options)
                        }
                    }

                    Button {
                        text: "steelblue"
                        color: text
                        onClicked: {
                            settings.frame = color
                            PopupUtils.close(options)
                        }
                    }

                    Button {
                        text: "gray"
                        color: text
                        onClicked: {
                            settings.frame = color
                            PopupUtils.close(options)
                        }
                    }
                }
            }
        }

        ContentPeerPicker {
            id: sharePage
            visible: false
            contentType: ContentType.Pictures
            handler: ContentHandler.Share

            onPeerSelected: {
                var transfer = peer.request()
                if (transfer.state === ContentTransfer.InProgress) {
                    transfer.items = snapshotItems
                    transfer.state = ContentTransfer.Charged
                }

                pages.pop()
            }

            onCancelPressed: pages.pop()
        }
    }

    Connections {
        target: ContentHub
        onExportRequested: {
            root.exportTransfer = transfer
            root.exportRequested = true
        }
    }
}
