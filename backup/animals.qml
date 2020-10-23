import QtQuick 2.0

Item {
    property int numb: 0
    property int eggs: 0
    property int eggsInWay: 0
    property int grassNumb: 0
    property var basic: [{
            name//basic animals props
            : "chicken",
            id: 0,
            item: 1,
            eff: 400,
            price: 20,
            foodNeeded: 1,
            foodCollected: 0,
            sizeX: 50,
            sizeY: 75
        }, {
            name: "goose",
            id: 1,
            item: 1,
            eff: 300,
            price: 50,
            foodNeeded: 1,
            foodCollected: 0
        }]
    property var grass: []
    property var your: []

    Items {
        id: items
    }

    Repeater {
        id: grasses //drawes grass on field
        model: 21
        Rectangle {
            id: gras
            width: 250
            height: 75
            x: -600
            color: index <= grassNumb ? (grass[grassNumb].food > 3 ? "green" : (grass[grassNumb].food > 0 ? "lightgreeen" : "sienna")) : "00000000"
            y: -300
        }
    }
    Repeater {
        id: chickens //drawes all on field
        model: 100
        Rectangle {
            id: chicken
            width: 50
            height: 75
            x: index < numb ? your[index].x : -500
            color: index <= numb ? (your[index].foodCollected
                                    > 0 ? "yellow" : "papayawhip") : "00000000"
            y: index < numb ? your[index].y : -250
        }
    }
    Text {
        x: 500
        y: 500
        id: info2
        text: "egg collected: " + eggs
        font.family: "Helvetica"
        font.pointSize: 10
        font.bold: true
    }
    ///// functions for outside using
    function moveAnimals() {
        for (var i = 0; i < numb; i++) {
            //calculate x-speed and y-speed
            if (grassNumb >= 0 && your[i].foodCollected < your[i].foodNeeded) {
                var minI = find(i)
                if (minI >= 0 && grass[minI].food > 0) {
                    gotoFood(i, minI)
                } else {
                    if (getRandomInt(15) === 2) {
                        your[i].diry = getRandomInt(11) - 5
                        your[i].dirx = getRandomInt(11) - 5
                    }
                    simpleLogic(i)
                }
                //console.log("finding grass by  ", i)
            } else {
                if (getRandomInt(15) === 2) {
                    your[i].diry = getRandomInt(11) - 5
                    your[i].dirx = getRandomInt(11) - 5
                }
            }
            simpleLogic(i)
            //calculate coords
            your[i].x += your[i].dirx
            your[i].y += your[i].diry
        }
    }

    function grassChange(X, Y) {
        //adds new grass
        if (grassNumb < 20) {
            //check on free place
            for (var i = 0; i <= grassNumb; i++) {
                if (i == grassNumb) {
                    rewriteGrassProps(grassNumb, X, Y)
                    grassNumb++
                    //console.log("writing new grass ", i)
                    break
                } else if (grass[i].food === 0) {
                    rewriteGrassProps(i, X, Y)
                    //console.log("rewriting grass ", i)
                    break
                }
                /*console.log("i ", i, ",grassNumb ", grassNumb, ", food ",
                            grass[i].food)*/
            }
        }
    }
    function rewriteGrassProps(i, X, Y) {
        var gra = {
            id: i,
            food: 5,
            x: X,
            y: Y
        }
        grasses.itemAt(i).x = X - 125
        grasses.itemAt(i).y = Y - 75 / 2
        grass[i] = gra
        //console.log("grass x ", grass[i].x, " nmb ", i)
        if (grass[i].food > 3) {
            grasses.itemAt(i).color = "green"
        } else if (grass[i].food > 0) {
            grasses.itemAt(i).color = "lightgreen"
        } else {
            grasses.itemAt(i).color = "sienna"
        }
    }

    function ifItemReady() {
        for (var i = 0; i < numb; i++) {
            if (your[i].timeFromLunch !== 0) {
                if (your[i].timeFromLunch % your[i].eff == 0
                        && your[i].foodCollected === your[i].foodNeeded) {
                    eggs++
                    items.addItemOnField(your[i].id, your[i].x, your[i].y)
                    console.log(your[i].name, " has already made EGG!!!")
                    your[i].foodCollected = 0
                    your[i].timeFromLunch = 0
                    if (your[i].foodCollected > 0) {
                        chickens.itemAt(i).color = "yellow"
                    } else {
                        chickens.itemAt(i).color = "papayawhip"
                    }
                } else {
                    your[i].timeFromLunch++
                }
            }
        }
    }

    function getEggs() {
        return eggs
    }
    function setEggs(e) {
        eggs = e
    }

    function add(id) {
        /*adds animal to field by its ID and writes time,
                                            when player bought it*/
        console.log("added ", animals.basic[id].name, " to your farm")
        if (numb <= 100) {
            balance -= basic[id].price
            var anims = {
                name: basic[id].name,
                id: id,
                item: basic[id].item,
                eff: basic[id].eff,
                price: basic[id].price,
                x: Math.random() * 750,
                y: Math.random() * 500,
                dirx: Math.random() * 11 - 5,
                diry: Math.random() * 11 - 5,
                timeFromLunch: 0,
                foodCollected: 0,
                foodNeeded: basic[id].foodNeeded,
                sizeX: basic[id].sizeX,
                sizeY: basic[id].sizeY
            }
            your[numb] = anims
            numb++
        }
    }
    ///// functions for inside using
    function find(i) {
        //calc shortest way to obj and nmb of this obj
        //console.log("calc shortest way  ")
        var minI = 0
        var deltaX = 0
        var deltaY = 0
        var minD = 10000
        var finded = false
        for (var gg = 0; gg < grassNumb; gg++) {
            deltaX = your[i].x - grass[gg].x
            deltaY = your[i].y - grass[gg].y
            /*console.log("dest  ", gg,
                        ", ", (Math.sqrt(deltaX * deltaX + deltaY * deltaY)),
                        ", minD ", minD, ", grass food ", grass[gg].food,
                        ", gr nmb ", grassNumb)*/
            //checking if way to i grass is the best
            if (minD > Math.sqrt(deltaX * deltaX + deltaY * deltaY) && grass[gg].food
                    > 0 && (Math.sqrt(
                                deltaX * deltaX + deltaY * deltaY) < 550)) {
                minD = Math.sqrt(deltaX * deltaX + deltaY * deltaY)
                minI = gg
                finded = true
            }
        }
        if (finded) {
            return minI
        } else {
            return minI = -1
        }
    }
    function simpleLogic(i) {
        //prevents animal from escaping
        if (your[i].x <= 0) {
            your[i].dirx = 5
        } else if (your[i].x >= 750) {
            your[i].dirx = -5
        } else if (your[i].y <= 0) {
            your[i].diry = 5
        } else if (your[i].y >= 500) {
            your[i].diry = -5
        } ///////////////////////////////
    }
    function gotoFood(i, minI) {
        //move animal to food
        //go to grass
        var k = 1
        var deltaX = your[i].x - grass[minI].x
        var deltaY = your[i].y - grass[minI].y
        if (Math.abs(deltaX) > Math.abs(deltaY)) {
            k = Math.abs(deltaX / deltaY)
            your[i].dirx = 7 * -1 * (deltaX / Math.abs(deltaX))
            your[i].diry = 7 * -1 * (deltaY / Math.abs(deltaY)) / k
        } else {
            k = Math.abs(deltaY / deltaX)
            your[i].dirx = 7 * -1 * (deltaX / Math.abs(deltaX)) / k
            your[i].diry = 7 * -1 * (deltaY / Math.abs(deltaY))
        }
        if (your[i].x >= grass[minI].x - 250 / 2 && your[i].x <= grass[minI].x + 250
                / 2 && your[i].y >= grass[minI].y - 75 / 2 && your[i].y <= grass[minI].y + 75 / 2) {
            //eating
            if (grass[minI].food > 0) {
                your[i].foodCollected += 1
                grass[minI].food -= 1
                if (grass[minI].food > 3) {
                    grasses.itemAt(minI).color = "green"
                } else if (grass[minI].food > 0) {
                    grasses.itemAt(minI).color = "lightgreen"
                } else {
                    grasses.itemAt(minI).color = "sienna"
                }
                if (your[i].foodCollected > 0) {
                    chickens.itemAt(i).color = "yellow"
                    console.log("yellow!!!")
                } else {
                    chickens.itemAt(i).color = "papayawhip"
                    console.log("white!!!")
                }
                your[i].diry = getRandomInt(3) - 1
                your[i].dirx = getRandomInt(3) - 1
                your[i].timeFromLunch = 1
                //console.log("grassNumb ", grassNumb, " = minI ", minI)
                console.log(your[i].name, " nmb ", your[i].id,
                            " has already eated")
            }
        }
    }
    function getRandomInt(max) {
        //generates random int
        return Math.floor(Math.random() * Math.floor(max))
    }
    function repaint() {
        //redraws animals
        for (var k = 0; k < numb; k++) {
            chickens.itemAt(k).x = your[k].x - 50 / 2
            chickens.itemAt(k).y = your[k].y - 75 / 2
        }
    }
}
