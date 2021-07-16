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
            "speed": 0.002,
            "upPrice": 125 * Math.pow(2, 0),
            "x": 0,
            "y": 0
        }, {
            "name": "plane",
            "id": 1
        }]
    Rectangle {
        id: truck
        x: - truck.width * 0.5
        width: parent.width * 0.1
        height: parent.height * 0.8
        color: "purple"
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

                your[0].destinationCompleted+= your[0].speed
                truck.x = your[0].destinationCompleted / 2 - truck.width / 2
            }
        }
    }
    function update() {
        your[0].itemCapacity = 15 * your[0].lvl - 5
        your[0].speed = 0.002 + 0.001 * (your[0].lvl - 1)
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
    function isArrived() {


        /* console.log("dest: ", 2 * dest, " km, dest compl: ",
                    your[0].destinationCompleted, " km ,speed  ",
                    your[0].speed, " km/h , time: ",
                    (dest * 2) / your[0].speed, " s")*/
        if (your[0].destinationCompleted !== 0) {
            if (your[0].destinationCompleted >= 1) {
                your[0].destinationCompleted = 0
                console.log("speed  ", your[0].speed, " p/s , time: ",
                            20 / your[0].speed,
                            " s, Items delivered ", your[0].itemCapacity)
                return true
            } else {
                your[0].destinationCompleted += your[0].speed
                if (your[0].destinationCompleted <= 0.5) {
                    truck.x = your[0].destinationCompleted * width * 2 - truck.width * 0.5
                } else {
                    truck.x = 2*(1 - your[0].destinationCompleted) * width - truck.width * 0.5
                }
                return false
            }
        }
        return false
    }
}
