import QtQuick

PanAjax {
    id: ajax

    signal success()
    signal failure()

    property string message: ""
    property var data:JSON.parse("{}")

    onResponse: (data)=>{
                    console.log(data)
                    let res = JSON.parse(data)
                    message = res.message
                    data = res.data
                    if(res.success){
                        ajax.success()
                    }else{
                        ajax.failure()
                    }
                }
}