import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtMultimedia 5.8
import QtQml 2.0

Window {
    id: wnd
    width: 1450
    height: 950
    visible: true
    title: "Funny farm 0.0.0 pre alpha beta"
    //=========VALUES=================
    property int balance: 1000
    property int level: 0
    property int numbOfAnimals: 0
    property int ticksPlayed: 0
    property int grassNumb: 0

    //===BASIC===================================
    Timer {
        id: updater
        running: false
        interval: 50
        repeat: true
        onTriggered: {
            ticksPlayed++
            refresh()
        }
    }

    //=======PLAYER'S=================================
    //==============================================
    Text {
        x: (wnd.width - 300) / 2
        id: txt
        text: "Funny farm I"
        font.family: "Helvetica"
        font.pointSize: 40
        font.bold: true
        color: "darkolivegreen"
    }
    Text {
        x: 100
        y: 50
        id: info
        text: "animals: " + numbOfAnimals + ", bal: " + balance
              + ",time played: " + ticksPlayed + ",fst animal bought: "
        font.family: "Helvetica"
        font.pointSize: 15
        font.bold: true
    }
    Item {
        id: menu
        visible: true

        Button {
            x: (wnd.width - 300) / 2
            y: (wnd.height - 100) / 2
            width: 300
            height: 100
            text: "Start Game"
            onClicked: start()
        }
    }
    Item {
        id: inGame
        visible: false
        focus: true
        Rectangle {
            id: field
            x: 250
            y: 300
            width: 750
            height: 500
            color: "sienna"
            radius: 25
            Animals {
                id: animals
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (balance >= 10) {
                        balance -= 10
                        animals.grassChange(mouseX, mouseY)
                    }
                }
            }
        }

        Rectangle {
            id: city_farm
            x: 700
            y: 100
            width: 550
            height: 150
            color: "slategray"
            radius: 25
            Transport {
                id: transport
            }
        }

        Button {
            x: 100
            y: 850
            width: 200
            enabled: balance >= 20 ? true : false
            height: 100
            text: "Buy chicken\n    20$"
            onClicked: animals.add(0)
        }
        Button {
            x: 300
            y: 850
            enabled: balance >= 50 ? true : false
            width: 200
            height: 100
            text: "Buy goose\n    50$"
            onClicked: animals.add(1)
        }
        Button {
            id: send
            x: 1100
            y: 850
            enabled: true
            width: 200
            height: 100
            text: "Send truck\n   (level " + transport.your[0].lvl + ")"
            onClicked: {
                if (animals.eggs > 0) {
                    transport.go()
                }
            }
        }
    }

    function refresh() {
        animals.moveAnimals()
        animals.ifItemReady()
        animals.repaint()
        var k = transport.isArrived(550)
        if (k[0] === 1) {
            send.enabled = true
        }
        balance += k[1]
    }

    function start() {
        balance = 1000
        updater.running = true
        inGame.visible = true
        menu.visible = false
    }

    function getRandomInt(max) {
        return Math.floor(Math.random() * Math.floor(max))
    }
}
