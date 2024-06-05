import QtQuick

PanAjax {
    id: ajax

    signal success(data: var)
    signal failure()

    property string message: ""
    property var data:JSON.parse("{}")
    property bool showBusyIndicator: false

    onResponse: (data)=>{
                    let res = JSON.parse(data)
                    message = res.message
                    if(res.success){
                        ajax.success(res.data)
                    }else{
                        ajax.failure()
                    }

                }
    onError: (msg)=>{
                 message = msg;
                 ajax.failure()

             }

    onRunningChanged: {
        if(!showBusyIndicator)   return
        if(running){
            PanApplication.busyIndicator.open()
        }else{
            PanApplication.busyIndicator.close()
        }
    }

}
