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
import QtQuick.Window 2.2
import Ubuntu.Components 1.3
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import QtMultimedia 5.9

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'mirror.brouits'
    automaticOrientation: true

    //width: units.gu(45)
    //height: units.gu(75)

    anchors.fill: parent

    Page {
        anchors.fill: parent

        header: PageHeader {
          id: header
          title: i18n.tr('Mirror')
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
        }

        Rectangle {
            color: "pink"
            radius: units.gu(1)
            anchors {
              top: header.bottom
              bottom: parent.bottom
              left: parent.left
              right: parent.right
            }

            border {
                width: units.gu(2)
                color: "pink"
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
            
                focus : visible
            }
        }
    }
}
