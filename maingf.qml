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
    title: "Funny farm 0.12.0 v release"

    color: "lightgoldenrodyellow"


    /*========Update list=================
      v.0.1.0
        added chickens
        now chickens cant cross borders
        chickens have x and y speed
      v 0.2.0
        added grass
        now chicken go to grass and "sticks" to it
        now chickens have random x and y speed
      v 0.3.0
        grass changes color correctly
        chicken changes color when eat
        now chickens randomly changes x and y speed with 1/10 chanse
        added food parameter
      v 0.4.0
        chickens dont sticks to grass when its fed
        bug fix with grass
        now chickens randomly changes x and y speed with 1/15 chanse correctly
        chickens became faster
      v 0.5.0
        chickens now go to nearest grass to eat
        grass dissapears when its food = 0
      v 0.6.0
        chickens dont sticks to grass when its food = 0
        chickens dont go out the field when theirs target grass disapears
        chickens now go to nearest grass to eat faster than theirs real speed
        fixed chickens algoritm: now they find the nearest grass correctly
      v 0.7.0
        added eggs counter
        added timer from last eat to egg
        added truck
      v 0.8.0
        now grass can respawn
      v 0.9.0
        fixed truck
      v 0.10.0
        added cows, pigs, sheeps
        added wool, milk, pork
        added truck levels
        fixed bugs
      v 0.11.0 Items update
        items reworked
        now items dont collect automatically
        items can spoil
      v 0.12.0 Storage update - CURRENT
        grass fix - disapearing
        items storage algorithm
        sell interface
        storage levels
        truck interface
        animals data optimized

        (item capacity level)
        (total price)
        (+ and shift)(- and shift)
        (pause)
      v 0.13.0 Buildings update - coming soon
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
    Text {
        x: (wnd.width - 300) / 2
        id: txt
        text: "Funny farm I"
        font.family: "Helvetica"
        font.pointSize: 40
        font.bold: true
        color: "orange"
    }
    Text {
        x: 100
        y: 60
        id: info
        text: "animals: " + numbOfAnimals + ",  bal: " + balance + "$,  time played: "
              + ticksPlayed + ",  money in way: " + totalPrice + "$"
        font.family: "Helvetica"
        font.pointSize: 15
        font.bold: true
    }
    Text {
        x: 750
        y: 60
        id: mouseCords
        text: "mouse X Y"
        font.family: "Helvetica"
        font.pointSize: 15
        font.bold: true
    }
    Button {
        x: 200
        y: 100
        width: 75
        height: 75
        text: "||" //timed
        onClicked: pause()
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

            color: "tan"
            radius: 25
            Animals {
                id: animals
            }
            Items {
                id: items
            }
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                hoverEnabled: true
                onClicked: {
                    if (balance >= 10 && mouse.button == Qt.LeftButton) {
                        animals.addGrass(mouseX, mouseY)
                    }
                    if (items.onField.length > 0
                            && mouse.button == Qt.RightButton) {
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
            x: 1050
            y: 400
            width: 320
            height: 200

            Button {
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

        Item {
            id: buttonsPanel

            Button {
                x: 100
                y: 850
                width: 200
                enabled: balance >= animals.basic[0].price ? true : false
                height: 100
                text: "Buy " + animals.basic[0].name + "\n    " + animals.basic[0].price + "$"
                onClicked: {
                    animals.add(0)
                    numbOfAnimals++
                }
            }
            Button {
                x: 300
                y: 850
                enabled: balance >= animals.basic[1].price ? true : false
                width: 200
                height: 100
                text: "Buy " + animals.basic[1].name + "\n    " + animals.basic[1].price + "$"
                onClicked: {
                    animals.add(1)
                    numbOfAnimals++
                }
            }
            Button {
                x: 500
                y: 850
                enabled: balance >= animals.basic[2].price ? true : false
                width: 200
                height: 100
                text: "Buy " + animals.basic[2].name + "\n    " + animals.basic[2].price + "$"
                onClicked: {
                    animals.add(2)
                    numbOfAnimals++
                }
            }
            Button {
                x: 700
                y: 850
                enabled: balance >= animals.basic[3].price ? true : false
                width: 200
                height: 100
                text: "Buy " + animals.basic[3].name + "\n    " + animals.basic[3].price + "$"
                onClicked: {
                    animals.add(3)
                    numbOfAnimals++
                }
            }
            Button {
                id: send
                x: 1100
                y: 850
                enabled: totalPrice == 0 ? true : false
                width: 200
                height: 100
                text: "Send truck\n   (level " + transport.your[0].lvl + ")"
                onClicked: {
                    //if (egg > 0 || wool > 0 || milk > 0 || pork > 0) {
                    sellInterface.visible = true
                    buttonsPanel.visible = false

                    for (var i = 0; i < storage.inStock.length; i++) {
                        listView.itemAtIndex(i).updateTexts()
                        listView.itemAtIndex(i).clear()
                        console.log("UPPP!!!!!!!!!!!!!!!!!!!!")
                    }
                    car_storage.clear()

                    pause()
                }
            }
            Button {
                id: up
                x: 1100
                y: 750
                enabled: balance >= transport.your[0].upPrice ? (totalPrice
                                                                 == 0 ? true : false) : false
                width: 200
                height: 100
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

    Rectangle {
        id: sellInterface
        visible: false

        color: "darksalmon"

        property int shift: 150

        x: shift
        y: shift
        width: (wnd.width - shift * 2)
        height: (wnd.height - shift * 2)

        Button {
            x: (parent.width - 300)
            y: (parent.height - 75)
            width: 300
            height: 75
            text: "Return"
            onClicked: {
                parent.visible = false
                buttonsPanel.visible = true

                pause()
            }
        }

        Button {
            x: (parent.width - 300 - 300 - 20)
            y: (parent.height - 75)
            width: 300
            height: 75
            text: "Sell"
            onClicked: {
                transport.go()
            }
        }

        Storage {
            id: car_storage
            color: "mediumpurple"
            s_WIDTH: 2
            s_HEIGTH: 1
            level: 6

            width: sellInterface.width / 4
            height: sellInterface.height / 4
            x: sellInterface.width * 5 / 8
            y: sellInterface.height * 1 / 4
        }

        ListView {
            id: listView
            width: parent.width / 2
            height: parent.height

            model: items.basic.length
            spacing: 10

            delegate: Item {
                width: listView.width
                height: 50
                y: index * 50

                property int amount: 0

                Rectangle {
                    id: itemImg
                    width: parent.height
                    height: parent.height

                    color: "red"
                }

                Text {
                    id: name_text
                    x: parent.height + listView.spacing
                    width: 75
                    height: parent.height

                    text: items.basic[index].name
                    font.family: "Helvetica"
                    font.pointSize: 15
                    font.bold: true
                }
                Text {
                    id: amount_text
                    x: parent.height + 75 + listView.spacing * 2
                    width: 75
                    height: parent.height

                    text: "x" + amount + "  (0)"
                    font.family: "Helvetica"
                    font.pointSize: 15
                    font.bold: true
                }
                Text {
                    id: price_text
                    x: parent.height + listView.spacing + 2 * 75 + 50 + listView.spacing * 3
                    width: 75
                    height: parent.height

                    text: "$" + amount * items.basic[index].price
                    font.family: "Helvetica"
                    font.pointSize: 15
                    font.bold: true
                }

                Button {
                    x: (parent.height + listView.spacing + 150 + 50 + 75 + listView.spacing * 4)
                    width: 50
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
                    x: (parent.height + listView.spacing + 150 + 2 * 50 + 75 + listView.spacing * 5)
                    width: 50
                    text: "-"
                    onClicked: {
                        if (amount > 0) {
                            amount--
                            car_storage.sell(index, 1)
                            updateTexts()
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
    }

    function refresh() {
        animals.moveAnimals()
        animals.ifItemReady()
        animals.repaint()

        items.update()

        //items
        var k = transport.isArrived(550)
        //console.log("refreshing")
        if (k === 1) {
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
