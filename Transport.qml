import QtQuick 2.0

Item {
    //basic transport props
    property var your: [{
            "name": "truck",
            "id": 0,
            "destinationCompleted": 0,
            "lvl": 1,
            "maxLvl": 5,
            "itemCapacityX": 2,
            "itemCapacityY": 1,
            "speed": Math.floor(2.2),
            "upPrice": 125 * Math.pow(2, 0),
            "sizeX": 100,
            "sizeY": 60,
            "x": 0,
            "y": 0
        }, {
            "name": "plane",
            "id": 1,
            "item": 1,
            "eff": 300,
            "price": 50,
            "foodNeeded": 1,
            "foodCollected": 0
        }]
    Rectangle {
        id: truck
        width: 100
        height: 60
        x: 450
        color: "purple"
        y: 600
    }

    function go() {
        if (your[0].destinationCompleted === 0) {
            var sellPrice = 0
            for (var i = 0; i < items.basic.length; i++) {
                sellPrice += storage.sell(i, listView.itemAtIndex(i).amount)
                car_storage.sell(i, listView.itemAtIndex(i).amount)

                listView.itemAtIndex(i).amount = 0
                listView.itemAtIndex(i).updateTexts()
            }

            if (sellPrice > 0) {
                totalPrice += sellPrice

                your[0].destinationCompleted++
                truck.y = 125 - your[0].sizeX / 2
                truck.x = your[0].destinationCompleted / 2 - your[0].sizeX / 2
            }
        }
    }
    function update() {
        your[0].itemCapacity = 15 * your[0].lvl - 5
        your[0].speed = Math.floor(2.2 + 1.1 * (your[0].lvl - 1))
        your[0].upPrice = 125 * Math.pow(2, your[0].lvl - 1)

        car_storage.s_WIDTH = your[0].itemCapacityX + your[0].lvl-1
        car_storage.s_HEIGTH = your[0].itemCapacityY + parseInt(your[0].lvl/2)
        //car_storage.level= 6
    }

    function levelUp() {
        if (balance >= your[0].upPrice && your[0].maxLvl !== your[0].lvl) {
            balance -= your[0].upPrice
            your[0].lvl++
            update()
        }
    }
    function isArrived(dest) {


        /* console.log("dest: ", 2 * dest, " km, dest compl: ",
                    your[0].destinationCompleted, " km ,speed  ",
                    your[0].speed, " km/h , time: ",
                    (dest * 2) / your[0].speed, " s")*/
        if (your[0].destinationCompleted !== 0) {
            if (your[0].destinationCompleted >= 2 * dest) {
                truck.x = 450
                truck.y = 600
                your[0].destinationCompleted = 0
                var k = 1
                console.log("speed  ", your[0].speed * 20, " p/s , time: ",
                            (dest * 2) / (your[0].speed * 20),
                            " s, Items delivered ", your[0].itemCapacity)
                return k
            } else {
                your[0].destinationCompleted += your[0].speed
                if (your[0].destinationCompleted / (dest * 2) <= 0.5) {
                    truck.x = your[0].destinationCompleted - your[0].sizeX / 2
                } else {
                    truck.x = (2 * dest - your[0].destinationCompleted) - your[0].sizeX / 2
                }
                return [0, 0]
            }
        }
        return [0, 0]
    }
}
