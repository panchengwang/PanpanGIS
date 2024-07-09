

function post(url,params,context,showBusyIndicator, success, failure) {
    var ajax = Qt.createQmlObject(
                `
                import QtQuick
                import cn.pc.gis.map
                PanAjax {
                }
                `,
                context);
    ajax.response.connect((data)=>{
                              console.log(data);
                              let ret = JSON.parse(data);
                              if(ret.success){
                                  if(success){
                                      success(ret.data,ret.message)
                                  }else{
                                      PanApplication.notify.show(ret.message)
                                  }
                              }else{
                                  if(failure){
                                      failure(ret.data)
                                  }else{
                                      PanApplication.notify.show(ret.message)
                                  }
                              }

                              ajax.destroy()
                          })
    ajax.error.connect((msg)=>{
                           if(failure){
                               failure(msg);
                           }else{
                               PanApplication.notify.show(ret.message)
                           }

                           ajax.destroy();
                       })
    ajax.runningChanged.connect(()=>{
                                    if(!showBusyIndicator)   return
                                    if(ajax.running){
                                        PanApplication.busyIndicator.open()
                                    }else{
                                        PanApplication.busyIndicator.close()
                                    }
                                })

    ajax.post(url,"request",JSON.stringify(params))
}
