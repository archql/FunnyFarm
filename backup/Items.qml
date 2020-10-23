import QtQuick 2.0

Item {
    var basic = [{
        name: "egg",
              id: 0,
              weight: 1,
              value: 0,
              price: 7,
              lifetime: 300,
              xsize: 15,
              ysize:25
    }, {
    name: "feather",
          id: 1,
          weight: 1,
          value: 0,
          price: 5,
          lifetime: 500
}, {
    name: "meat",
          id: 2,
          weight: 2,
          value: 0,
          price: 15,
          lifetime: 200
}, {
    name: "milk",
          id: 3,
          weight: 4,
          value: 0,
          price: 25,
          lifetime: 200
}]
var onField = []
var inStock = []
//===============================
function getItem() {}

function addItemOnField(id,X,Y) {
    var item = {
        id: id,
        x:X,
        y: Y,
        lived:0,
        lifetime:basic[id].lifetime,
        xsize:basic[id].xsize,
        ysize:basic[id].ysize,
        price:basic[id].price,
        weight:basic[id].weight
    }

}

}
