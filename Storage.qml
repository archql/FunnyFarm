import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle {
    property int s_WIDTH: 8
    property int s_HEIGTH: 5
    property int level: 2

    property var inStock: [] // it is total amount of items dep on id
    property var sets: [] // [item_id][amount]

    color: "wheat"

    Component.onCompleted: {
        clear()
    }

    function clear() {
        for (var i = 0; i < items.basic.length; i++) {
            inStock[i] = 0

            sets[i] = []
        }
        for (i = 0; i < s_WIDTH * s_HEIGTH; i++) {
            itemsDrawer.itemAt(i).width = 0
            itemsDrawer.itemAt(i).height = 0
        }
    }

    function reset() {
        for (var i = 0; i < items.basic.length; i++) {
            sets[i] = []

            addToSets(i, inStock[i])
        }

        redraw()
    }

    Repeater {
        id: itemsDrawer //drawes all on field
        model: s_WIDTH * s_HEIGTH
        anchors.fill: parent
        delegate: Rectangle {
            id: itemsElement
            radius: 13
            color: "red"
            height: 0
            //property alias value: amountProgress.value
            //property alias amountVisible: amountProgress.visible
//            ProgressBar {
//                id: amountProgress
//                anchors.bottom: parent.bottom
//                anchors.left: parent.left
//                //anchors.right: parent.right
//                //width: itemsElement.width

//                height: itemsElement ? itemsElement.height * 0.1 : 0
//                //y: itemsElement ? itemsElement.height * 0.9 : 0
//                //width: itemsElement ? itemsElement.width : 0
//                //visible: parent.visible
//           }
        }
    }

    function redraw() {
        var ix, iy, setNumber = 0
        var sWidth = parseInt(width / s_WIDTH)
        var sHeight = parseInt(height / s_HEIGTH)

        for (var i = 0; i < sets.length; i++) {
            for (var j = 0; j < sets[i].length; j++) {
                if (sets[i][j] > 0) {
                    itemsDrawer.itemAt(setNumber).width = sWidth
                    itemsDrawer.itemAt(setNumber).height = sHeight

                    ix = setNumber % s_WIDTH
                    iy = parseInt(setNumber / s_WIDTH)

                    itemsDrawer.itemAt(setNumber).x = sWidth * ix
                    itemsDrawer.itemAt(
                                setNumber).y = height - sHeight * (iy + 1)

                    itemsDrawer.itemAt(setNumber).color = items.basic[i].color

                    //itemsDrawer.itemAt(setNumber).value = sets[i][j] / level
                    //itemsDrawer.itemAt(setNumber).amountVisible = true
                    setNumber++
                }
            }
        }
        for (i = setNumber; i < s_WIDTH * s_HEIGTH; i++) {
            itemsDrawer.itemAt(i).width = 0
            itemsDrawer.itemAt(i).height = 0
            //itemsDrawer.itemAt(i).amountVisible = false
        }
    }

    function sell(id, amount) {
        console.log("sell")
        var takedPrice = 0

        if (amount <= inStock[id]) {
            inStock[id] -= amount
            takedPrice += amount * items.basic[id].price

            sets[id] = [] // reset
            addToSets(id, inStock[id])

            redraw()
        }

        return takedPrice
    }

    function addToSets(id, number) {
        //there is no defence from lack of place
        var total_weight = items.basic[id].weight * number
        var pushes = 0
        var len = 0
        //count full length
        for (var i = 0; i < sets.length; i++) {
            len += sets[i].length
        }

        while (total_weight > 0) {
            //count push amount of weight
            if (parseInt(total_weight / level) > 0)
                var amount = level
            else
                amount = total_weight % level

            //check what to do
            if (sets[id].length <= 0
                    || sets[id][sets[id].length - 1] === level) {
                //push if no elements or full
                if (len >= s_WIDTH * s_HEIGTH)
                    return false
                console.log("PUSH!")

                sets[id].push(amount)
                total_weight -= amount
            } else {
                //count add amount of weight
                var delta = level - sets[id][sets[id].length - 1]
                if (total_weight > delta)
                    amount = delta
                else
                    amount = total_weight

                //fill stack
                sets[id][sets[id].length - 1] += amount
                total_weight -= amount
            }
        }

        return true
    }

    function addElement(id) {
        if (addToSets(id, 1)) {
            inStock[id]++
            redraw()

            info2.text = "eggs collected: " + inStock[0] + "\n porks collected: " + inStock[1]
                    + "\n wool collected: " + inStock[2] + "\n milk collected: " + inStock[3]

            return true
        }
        return false
    }

    Text {
        x: 700
        y: 500
        id: info2
        text: ""
        font.family: "Helvetica"
        font.pointSize: 12
        font.bold: true
    }
}
