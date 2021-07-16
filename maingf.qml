import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls
//import QtMultimedia 5.8
import QtQml 2.0

import QtQuick.Layouts 1.3

Window {
    id: wnd
    width: Screen.width
    height: Screen.height
    visible: true
    title: "Funny farm 0.12.1 v release"

    color: "lightgoldenrodyellow"

    maximumHeight: height // temp block resizing
        maximumWidth: width

        minimumHeight: height
        minimumWidth: width



	/*========General info=================
    - there is a game 'Farm Frenzy' (russian 'веселая ферма').
    I tried to make smth similar to it.
	*/

    /*========Update list=================
      v.0.1.x
        added chickens
        now chickens cant cross borders
        chickens have x and y speed
      v 0.2.x
        added grass
        now chicken go to grass and "sticks" to it
        now chickens have random x and y speed
      v 0.3.x
        grass changes color correctly
        chicken changes color when eat
        now chickens randomly changes x and y speed with 1/10 chanse
        added food parameter
      v 0.4.x
        chickens dont sticks to grass when its fed
        bug fix with grass
        now chickens randomly changes x and y speed with 1/15 chanse correctly
        chickens became faster
      v 0.5.x
        chickens now go to nearest grass to eat
        grass dissapears when its food = 0
      v 0.6.x
        chickens dont sticks to grass when its food = 0
        chickens dont go out the field when theirs target grass disapears
        chickens now go to nearest grass to eat faster than theirs real speed
        fixed chickens algoritm: now they find the nearest grass correctly
      v 0.7.x
        added eggs counter
        added timer from last eat to egg
        added truck
      v 0.8.x
        now grass can respawn
      v 0.9.x
        fixed truck
      v 0.10.x
        added cows, pigs, sheeps
        added wool, milk, pork
        added truck levels
        fixed bugs
      v 0.11.x Items update
        items reworked
        now items dont collect automatically
        items can spoil
      v 0.12.x Storage update - CURRENT
        grass fix - disapearing corrected
        items storage algorithm
        sell interface
        storage levels
        truck interface
        animals data optimized
        layouts fixed

        (item capacity level)
        (total price)
        (+ and shift)(- and shift)
        (pause)
        (fix known bug -- full storage can work unpredictable)
      v 0.13.x Buildings update - coming soon
        Buildings added
        Grass now depend on well

    */
    //=========VALUES=================
    property int balance: 10000
    property int level: 0
    property int numbOfAnimals: 0
    property int ticksPlayed: 0
    property int grassNumb: 0

    property int egg: 0
    property int pork: 0
    property int wool: 0
    property int milk: 0

    property int totalPrice: 0

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

    ColumnLayout {
        anchors.fill: parent
        spacing: 10
        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: font.pointSize
            id: txt
            text: "Funny farm I"
            font.family: "Helvetica"
            font.pointSize: 40
            font.bold: true
            color: "orange"
        }
        Text {
            id: info
            //Layout.marginsLeft: parent.spacing
            Layout.preferredHeight: font.pointSize / 2
            text: "animals: " + numbOfAnimals + ",  bal: " + balance + "$,  time played: "
                  + ticksPlayed + ",  money in way: " + totalPrice + "$"
            font.family: "Helvetica"
            font.pointSize: 15
            font.bold: true
        }
        Text {
            //Layout.marginsLeft: parent.spacing
            Layout.preferredHeight: font.pointSize / 2
            id: mouseCords
            text: "mouse X Y"
            font.family: "Helvetica"
            font.pointSize: 15
            font.bold: true
        }
        ColumnLayout {
            id: menu
            Layout.alignment: Qt.AlignHCenter
            Layout.margins: parent.spacing
            visible: true
            spacing: 15

            Button {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: wnd.width / 10
                Layout.preferredHeight: Layout.preferredWidth / 3
                //x: (wnd.width - 300) / 2
                //y: (wnd.height - 100) / 2

                text: "Start Game"
                onClicked: start()
            }

//            Button { // temp
//                Layout.alignment: Qt.AlignHCenter
//                Layout.preferredWidth: wnd.width * 0.05
//                Layout.preferredHeight: Layout.preferredWidth
//                text: "||" //timed
//                onClicked: pause()
//            }
        }
        ColumnLayout {
            id: inGame
            visible: false
            spacing: 5
            Layout.margins: parent.spacing
            Layout.alignment: Qt.AlignHCenter

            RowLayout {
                Layout.alignment: Qt.AlignRight
                Layout.margins: parent.spacing
                Rectangle {
                    id: city_farm
                    Layout.margins: parent.spacing
                    Layout.preferredWidth: wnd.width * 0.4
                    Layout.preferredHeight: wnd.height * 0.1
                    color: "slategray"
                    radius: 25
                    Transport {
                        id: transport
                        width: parent.width
                        height: parent.height
                        y: -parent.height * 0.5
                    }
                }

                ColumnLayout {
                    Button {
                        id: send
                        enabled: totalPrice == 0 ? true : false
                        Layout.preferredWidth: 200
                        text: "Send truck\n   (level " + transport.your[0].lvl + ")"
                        onClicked: {
                            //if (egg > 0 || wool > 0 || milk > 0 || pork > 0) {
                            sellInterface.visible = true
                            buttonsPanel.active = false

                            for (var i = 0; i < storage.inStock.length; i++) {
                                listView.itemAtIndex(i).updateTexts()
                                listView.itemAtIndex(i).clear()
                            }
                            car_storage.clear()

                            pause()
                        }
                    }
                    Button {
                        id: up
                        //x: 1100
                        //y: 750
                        enabled: balance >= transport.your[0].upPrice ? (totalPrice
                                                                         == 0 ? true : false) : false
                        Layout.preferredWidth: 200
                        text: "Up truck level\n   (cost " + transport.your[0].upPrice + ")"
                        onClicked: {
                            transport.levelUp()
                            send.text = "Send truck\n   (level " + transport.your[0].lvl + ")"
                            up.text = "Up truck level\n   (cost " + transport.your[0].upPrice + ")"
                            if (transport.your[0].lvl >= 5) {
                                up.enabled = false
                                up.text = "Truck level is max"
                            }
                        }
                    }
                }

            }
            RowLayout {
                spacing: 25
                Layout.margins: parent.spacing

                Rectangle {
                    id: field
                    Layout.preferredWidth: wnd.width * 0.6
                    Layout.preferredHeight: wnd.height * 0.5
                    Layout.alignment: Qt.AlignCenter

                    color: "tan"
                    radius: 25
                    Animals {
                        id: animals
                        anchors.fill: parent
                    }
                    Items {
                        id: items
                    }
                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        hoverEnabled: true
                        onClicked: {
                            if (balance >= 10 && mouse.button === Qt.LeftButton) {
                                animals.addGrass(mouseX, mouseY)
                            }
                            if (items.onField.length > 0
                                    && mouse.button === Qt.RightButton) {
                                items.deleteItemAt(mouseX, mouseY)
                            }
                        }
                        onPositionChanged: {
                            mouseCords.text = "mouse X " + parseInt(
                                        mouseX) + " Y " + parseInt(mouseY)
                        }
                    }
                }

                Storage {
                    id: storage
                    //width: 500
                    //height: 500
                    Layout.preferredWidth: wnd.width * 0.3
                    Layout.preferredHeight: wnd.height * 0.3

                    Button { // upgrade storage
                        property int upPrice: 150
                        property int level: 1

                        id: up_storage
                        x: parent.width / 2 - 100 / 2
                        y: parent.height + 10
                        width: 100
                        height: 40
                        enabled: balance >= upPrice ? (level < 5 ? true : false) : false
                        text: "Up storage level\n   (cost " + upPrice + ")\n     now " + level + " level"
                        onClicked: {
                            storage.level++
                            level++

                            balance -= upPrice

                            storage.reset() //level!!!
                            upPrice = upPrice * 2
                        }
                    }
                }
            }

            RowLayout {
                id: buttonsPanel
                spacing: 15
                property bool active: true
                Button {
                    //x: 100
                    //y: 850
                    Layout.preferredWidth: 200
                    enabled: (balance >= animals.basic[0].price) & active ? true : false
                    text: "Buy " + animals.basic[0].name + "\n    " + animals.basic[0].price + "$"
                    onClicked: {
                        animals.add(0)
                        numbOfAnimals++
                    }
                }
                Button {
                    //x: 300
                    //y: 850
                    enabled: (balance >= animals.basic[1].price) & active ? true : false
                    Layout.preferredWidth: 200
                    text: "Buy " + animals.basic[1].name + "\n    " + animals.basic[1].price + "$"
                    onClicked: {
                        animals.add(1)
                        numbOfAnimals++
                    }
                }
                Button {
                    //x: 500
                    //y: 850
                    enabled: (balance >= animals.basic[2].price) & active ? true : false
                    Layout.preferredWidth: 200
                    text: "Buy " + animals.basic[2].name + "\n    " + animals.basic[2].price + "$"
                    onClicked: {
                        animals.add(2)
                        numbOfAnimals++
                    }
                }
                Button {
                    //x: 700
                    //y: 850
                    enabled: (balance >= animals.basic[3].price) & active ? true : false
                    Layout.preferredWidth: 200
                    text: "Buy " + animals.basic[3].name + "\n    " + animals.basic[3].price + "$"
                    onClicked: {
                        animals.add(3)
                        numbOfAnimals++
                    }
                }
            }
        }
    }

    Rectangle {
        id: sellInterface
        visible: false

        color: "darksalmon"

        property int shift: 150

        x: shift
        y: shift
        width: (wnd.width - shift * 2)
        height: (wnd.height - shift * 2)

        RowLayout {

            anchors.fill: parent
            spacing: 20

            ListView {
                id: listView
                Layout.preferredWidth: sellInterface.width / 2
                Layout.preferredHeight: sellInterface.height - 2 * Layout.margins - 50
                Layout.margins: 30

                model: items.basic.length
                spacing: 10

                delegate: Item {
                    id: element
                    width: listView.width
                    height: 50
                    y: index * height

                    property int amount: 0

                    RowLayout {
                        spacing: listView.spacing
                        Rectangle {
                            id: itemImg
                            Layout.preferredWidth: element.height
                            Layout.preferredHeight: element.height

                            color: "red"
                        }

                        Text {
                            id: name_text
                            Layout.preferredWidth: element.height * 2
                            Layout.preferredHeight: element.height


                            text: items.basic[index].name
                            font.family: "Helvetica"
                            font.pointSize: 15
                            font.bold: true
                        }
                        Text {
                            id: amount_text
                            Layout.preferredWidth: element.height * 2
                            Layout.preferredHeight: element.height


                            text: "x" + element.amount + "  (0)"
                            font.family: "Helvetica"
                            font.pointSize: 15
                            font.bold: true
                        }
                        Text {
                            id: price_text
                            Layout.preferredWidth: element.height * 2
                            Layout.preferredHeight: element.height


                            text: "$" + element.amount * items.basic[index].price
                            font.family: "Helvetica"
                            font.pointSize: 15
                            font.bold: true
                        }

                        Button {
                            Layout.preferredWidth: element.height
                            Layout.preferredHeight: element.height

                            text: "+"
                            onClicked: {
                                console.log("updateTexts storage.inStock[index].length ",
                                            storage.inStock[0], " index ", index)
                                if (amount < storage.inStock[index]
                                        && car_storage.addElement(index)) {
                                    amount++
                                    updateTexts()
                                }
                            }
                        }
                        Button {
                            Layout.preferredWidth: element.height
                            Layout.preferredHeight: element.height

                            text: "-"
                            onClicked: {
                                if (amount > 0) {
                                    amount--
                                    car_storage.sell(index, 1)
                                    updateTexts()
                                }
                            }
                        }

                    }
                    function clear() {
                        amount = 0
                        itemImg.color = items.basic[index].color
                    }

                    function updateTexts() {
                        console.log("updateTexts")
                        price_text.text = "$" + amount * items.basic[index].price
                        amount_text.text = "x" + amount + "  (" + storage.inStock[index] + ")"
                    }
                }
            }

            ColumnLayout {
                Storage {
                    id: car_storage
                    color: "mediumpurple"
                    s_WIDTH: 2
                    s_HEIGTH: 1
                    level: 6

                    Layout.preferredWidth: sellInterface.width / 4
                    Layout.preferredHeight: sellInterface.height / 4
                }

                Button {
                    Layout.preferredWidth: sellInterface.width / 10
                    Layout.preferredHeight: sellInterface.height / 10
                    text: "Sell"
                    onClicked: {
                        transport.go()
                    }
                }

                Button {
                    Layout.preferredWidth: sellInterface.width / 10
                    Layout.preferredHeight: sellInterface.height / 10
                    text: "Return"
                    onClicked: {
                        sellInterface.visible = false
                        buttonsPanel.active = true

                        pause()
                    }
                }
            }

        }
    }

    function refresh() {
        animals.moveAnimals()
        animals.ifItemReady()
        animals.repaint()

        items.update()

        //console.log("refreshing")
        if (transport.isArrived() === true) {
            console.log("truck has already returned")
            //send.enabled = true
            balance += totalPrice
            totalPrice = 0
        }
    }

    function start() {
        updater.running = true
        inGame.visible = true
        menu.visible = false
    }

    function pause() {
        updater.running = !updater.running
    }

    function getRandomInt(max) {
        return Math.floor(Math.random() * Math.floor(max))
    }
}
