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
        source: "./fonts/Material-Design-Iconic-Font.ttf"
    }

    property FontLoader awesome: FontLoader{
        source: "./fonts/FontAwesome6Free-Regular-400.otf"
    }

}
