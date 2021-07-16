import QtQuick 2.0

Item {
    property int grass_FOOD: 10

    property int numb: 0
    property var basic: [{
            "name"//basic animals props
            : "chicken",
            "id": 0,
            "item": 0,
            "eff": 400,
            "price"//400
            : 20,
            "foodNeeded": 1,
            "sizeX": 50,
            "sizeY": 75,
            "color": "gold"
        }, {
            "name": "pig",
            "id": 1,
            "item": 1,
            "eff": 600,
            "price"//600
            : 100,
            "foodNeeded": 3,
            "sizeX": 120,
            "sizeY": 60,
            "color": "hotpink"
        }, {
            "name": "sheep",
            "id": 2,
            "item": 2,
            "eff": 500,
            "price"//500
            : 250,
            "foodNeeded": 2,
            "sizeX": 130,
            "sizeY": 90,
            "color": "snow"
        }, {
            "name": "cow",
            "id": 3,
            "item": 3,
            "eff": 600,
            "price"//600
            : 1000,
            "foodNeeded": 5,
            "sizeX": 160,
            "sizeY": 110,
            "color": "peru"
        }]
    property var grassElement: {
        "food": 10,
        "price": 10,
        "sizeX": 250,
        "sizeY": 75,
        "colorFull": "limegreen",
        "colorHalf": "palegreen"
    }
    property var grass: []
    property var your: []
    property var itemsOnScreen: []

    Repeater {
        id: grasses //drawes grass on field
        model: 50
        Rectangle {
            id: gras
            color: index < grass.length ? (grass[grass.length].food
                                            > 5 ? "green" : (grass[grass.length].food
                                                             > 0 ? "lime" : "sienna")) : "00000000"
        }
    }
    Repeater {
        id: chickens //drawes all on field
        model: 100
        Rectangle {
            id: chicken
            width: index < numb ? your[index].sizeX : 0
            height: index < numb ? your[index].sizeY : 0
            x: index < numb ? your[index].x : -500
            color: index < numb ? (your[index].color) : "00000000" /*your[index].foodCollected === your[index].foodNeeded ? "yellow" : */
            y: index < numb ? your[index].y : -250
        }
    }
    ///// functions for outside using

    //grass
    function addGrass(X, Y) {
        //adds new grass
        if (grass.length < 50) {
            //form new grass
            var gra = {
                "food": grassElement.food,
                "x": X - grassElement.sizeX / 2,
                "y": Y - grassElement.sizeY / 2
            }

            //pay for it
            balance -= grassElement.price

            //setup drawer data
            grasses.itemAt(grass.length).x = gra.x
            grasses.itemAt(grass.length).y = gra.y
            grasses.itemAt(grass.length).color = grassElement.colorFull
            grasses.itemAt(grass.length).width = grassElement.sizeX
            grasses.itemAt(grass.length).height = grassElement.sizeY

            //add new grass to array
            grass.push(gra)
        }
    }
    function updateGrass() {
        var oldLen = grass.length
        for (var i = 0; i < oldLen; i++) {
            //all outbounded grass is hided
            if (i >= grass.length) {
                grasses.itemAt(i).width = 0
                grasses.itemAt(i).height = 0
                break
            }

            //reset cords
            grasses.itemAt(i).x = grass[i].x
            grasses.itemAt(i).y = grass[i].y

            if (grass[i].food === 0) {
                grass.splice(i, 1)
                //go back and update element
                i--
            } else if (grass[i].food <= parseInt(grassElement.food / 2)) {
                grasses.itemAt(i).color = grassElement.colorHalf
            } else
                grasses.itemAt(i).color = grassElement.colorFull

            //console.log("i ", i, ",grassNumb ", grass.length)
        }
    }

    //animals
    function moveAnimals() {
        for (var i = 0; i < numb; i++) {
            //calculate x-speed and y-speed
            if (grass.length >= 0
                    && your[i].foodCollected < your[i].foodNeeded) {
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

    function ifItemReady() {
        for (var i = 0; i < numb; i++) {
            if (your[i].timeFromLunch !== 0) {
                if (your[i].timeFromLunch % your[i].eff == 0
                        && your[i].foodCollected === your[i].foodNeeded) {

                    items.addItemOnField(your[i].item, your[i].x, your[i].y)
                    //items.addItemOnField(your[i].id, your[i].x, your[i].y)


                    /*console.log(your[i].name,
                                " has already made item. Its it is ",
                                your[i].item, "!!!")*/
                    your[i].foodCollected = 0
                    your[i].timeFromLunch = 0
                    if (your[i].foodCollected === your[i].foodNeeded) {
                        chickens.itemAt(i).color = "yellow"
                    } else {
                        chickens.itemAt(i).color = your[i].color
                    }
                } else {
                    your[i].timeFromLunch++
                }
            }
        }
    }

    function add(id) {


        /*adds animal to field by its ID and writes time,
                                            when player bought it*/
        console.log("added ", animals.basic[id].name, " to your farm")
        if (numb <= 100) {
            balance -= basic[id].price
            var anims = {
                "name": basic[id].name,
                "id": id,
                "item": basic[id].item,
                "eff": basic[id].eff,
                "price": basic[id].price,
                "x": Math.random() * 750,
                "y": Math.random() * 500,
                "dirx": Math.random() * 11 - 5,
                "diry": Math.random() * 11 - 5,
                "timeFromLunch": 0,
                "foodCollected": 0,
                "foodNeeded": basic[id].foodNeeded,
                "sizeX": basic[id].sizeX,
                "sizeY": basic[id].sizeY,
                "color": basic[id].color
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
        for (var gg = 0; gg < grass.length; gg++) {
            deltaX = your[i].x - grass[gg].x
            deltaY = your[i].y - grass[gg].y


            /*console.log("dest  ", gg,
                        ", ", (Math.sqrt(deltaX * deltaX + deltaY * deltaY)),
                        ", minD ", minD, ", grass food ", grass[gg].food,
                        ", gr nmb ", grass.length)*/
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
        } else if (your[i].x >= width) {
            your[i].dirx = -5
        } else if (your[i].y <= 0) {
            your[i].diry = 5
        } else if (your[i].y >= height) {
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

                if (your[i].foodCollected === your[i].foodNeeded) {
                    chickens.itemAt(i).color = Qt.darker(
                                chickens.itemAt(i).color, 1.13) //!TIMED
                    console.log("enough food for produce item!!!")
                } else {
                    chickens.itemAt(i).color = your[i].color
                    console.log("not enough food!!!")
                }
                your[i].diry = getRandomInt(3) - 1
                your[i].dirx = getRandomInt(3) - 1
                your[i].timeFromLunch = 1
                //console.log("grassNumb ", grass.length, " = minI ", minI)
                console.log(your[i].name, " nmb ", your[i].id,
                            " has already eated")

                updateGrass()
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
            chickens.itemAt(k).x = your[k].x - your[k].sizeX / 2
            chickens.itemAt(k).y = your[k].y - your[k].sizeY / 2
        }
    }
}
