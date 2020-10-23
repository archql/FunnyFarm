import QtQuick 2.0

Item {
    Repeater {
        id: progressBlocks
        model: 50
        Rectangle {
            id: gras
            width: 250
            height: 75
            x: -600
            color: "red"
            y: -300
        }
    }
}
