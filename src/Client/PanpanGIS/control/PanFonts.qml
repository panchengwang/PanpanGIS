pragma Singleton

import QtQuick

QtObject {
    // property FontLoader notoSansSimpleChineseLight : FontLoader{
    //     source : "./fonts/NotoSansSC-Light.ttf"
    // }

    property FontLoader notoSansSimpleChineseRegular : FontLoader{
        source : "./fonts/NotoSansSC-Regular.ttf"
    }

    property FontLoader gis : FontLoader{
        source : "./fonts/font-gis.ttf"
    }

    property FontLoader material: FontLoader{
        source: "./fonts/MaterialIcons-Regular.ttf"
    }

    property FontLoader awesomeSolid: FontLoader{
        source: "./fonts/fa-solid-900.ttf"
    }

    property FontLoader awesomeRegular: FontLoader{
        source: "./fonts/fa-regular-400.ttf"
    }

    property FontLoader awesomeBrands: FontLoader{
        source: "./fonts/fa-brands-400.ttf"
    }
}
