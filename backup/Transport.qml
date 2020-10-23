import QtQuick 2.0

Item {
    //basic transport props
    property var your: [{
            name: "truck",
            id: 0,
            destinationCompleted: 0,
            lvl: 1,
            itemCapacity: Math.floor(5 * 1 * 1.5),
            items: 0,
            speed: Math.floor(0.4 * 1 * 2.5),
            upPrice: Math.floor(200 * 1 * 2.5),
            sizeX: 100,
            sizeY: 60,
            x: 0,
            y: 0
        }, {
            name: "plane",
            id: 1,
            item: 1,
            eff: 300,
            price: 50,
            foodNeeded: 1,
            foodCollected: 0
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
            your[0].destinationCompleted++
            truck.y = 125 - your[0].sizeX / 2
            truck.x = your[0].destinationCompleted / 2 - your[0].sizeX / 2
            if (animals.eggs <= your[0].itemCapacity) {
                your[0].items = animals.eggs
                animals.setEggs(0)
            } else {
                animals.eggsInWay = your[0].itemCapacity
                animals.setEggs(animals.getEggs -= your[0].itemCapacity)
            }
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
                var k = [animals.eggsInWay, (your[0].itemCapacity) * 6]
                animals.eggsInWay = 0
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
