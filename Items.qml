import QtQuick 2.0

Item {

    property int itemsNum: 0
    property double spoilPartTIME: 0.66

    property var basic: [{
            "name": "egg",
            "id": 0,
            "weight": 1,
            "value": 0,
            "price": 7,
            "lifetime": 650,
            "sizeX": 25,
            "sizeY": 35,
            "color": "sandybrown",
            "colorBad": "darkgoldenrod"
        }, {
            "name": "meat",
            "id": 1,
            "weight": 2,
            "value": 0,
            "price": 22,
            "lifetime": 400,
            "sizeX": 45,
            "sizeY": 20,
            "color": "salmon",
            "colorBad": "indianred"
        }, {
            "name": "wool",
            "id": 2,
            "weight": 2,
            "value": 0,
            "price": 35,
            "lifetime": 1000,
            "sizeX": 45,
            "sizeY": 50,
            "color": "seashell",
            "colorBad": "dimgrey"
        }, {
            "name": "milk",
            "id": 3,
            "weight": 4,
            "value": 0,
            "price": 60,
            "lifetime": 500,
            "sizeX": 25,
            "sizeY": 55,
            "color": "paleturquoise",
            "colorBad": "powderblue"
        }]
    property var onField: []

    //===============================
    function deleteItemAt(X, Y) {
        var deletedN = 0
        for (var j = 0; j < onField.length; j++) {
            if ((Math.abs(onField[j].x - X) < basic[onField[j].id].sizeX)
                    && (Math.abs(
                            onField[j].y - Y) < basic[onField[j].id].sizeY)) {

                //inStock.push(onField[j])
                //add to storage
                if (storage.addElement(onField[j].id)) {
                    console.log("Deleted item at ", j)
                    onField.splice(j, 1) //delete item

                    deletedN++
                } else
                    console.log("PIVSEH HAXOI DOLBOIB!")
            }
        }
        repaint(deletedN)
        //updateStored()
    }

    function addItemOnField(id, X, Y) {
        var item = {
            "id": id,
            "x": X,
            "y": Y,
            "lived": 0
        }
        onField.push(item)
        console.log("Added item id ", id, " itemsNum ", onField.length)

        repaint(0)
    }

    function update() {
        var deletedN = 0
        for (var j = 0; j < onField.length; j++) {
            onField[j].lived++
            if (onField[j].lived === parseInt(
                        basic[onField[j].id].lifetime * spoilPartTIME)) {
                itemsDrawer.itemAt(j).color = basic[onField[j].id].colorBad
            }
            if (onField[j].lived > basic[onField[j].id].lifetime) {
                //console.log("ITEM SPOILED!")
                onField.splice(j, 1) //delete item
                deletedN++
            }
        }
        if (deletedN > 0)
            repaint(deletedN)
    }

    function repaint(oldLen) {
        //redraws items
        for (var i = 0; i < onField.length + oldLen; i++) {
            if (i >= onField.length) {
                itemsDrawer.itemAt(i).width = 0
                itemsDrawer.itemAt(i).height = 0
            } else {
                //set cords
                itemsDrawer.itemAt(
                            i).x = onField[i].x - basic[onField[i].id].sizeX / 2
                itemsDrawer.itemAt(
                            i).y = onField[i].y - basic[onField[i].id].sizeY / 2

                //set w, h
                itemsDrawer.itemAt(i).width = basic[onField[i].id].sizeX
                itemsDrawer.itemAt(i).height = basic[onField[i].id].sizeY

                //check if spoil close enough
                if (onField[i].lived >= parseInt(
                            basic[onField[i].id].lifetime * spoilPartTIME))
                    itemsDrawer.itemAt(i).color = basic[onField[i].id].colorBad
                else {
                    itemsDrawer.itemAt(i).color = basic[onField[i].id].color
                    //itemsDrawer.itemAt(i).color = Qt.hsva((i % 10) / 10, 1, 1,
                    //                                      1) //rainbow
                }
            }
        }
    }


    /*function updateStored() {
        var storedItems = [0, 0, 0, 0]
        for (var i = 0; i < inStock.length; i++) {
            storedItems[inStock[i].id]++
        }

        if (storedItems[0] !== null)
            egg = storedItems[0]
        if (storedItems[1] !== undefined)
            pork = storedItems[1]
        if (storedItems[2] !== null)
            wool = storedItems[2]
        if (storedItems[3] !== null)
            milk = storedItems[3]
    }*/

    //======drawer=====================
    Repeater {
        id: itemsDrawer //drawes all on field
        model: 100
        Rectangle {
            id: itemsElement
            width: 0
            height: 0
            x: 0
            y: 0
            color: index < onField.length ? onField[index].color : "00000000"
        }
    }
}
