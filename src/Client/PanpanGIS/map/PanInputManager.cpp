#include "PanInputManager.h"

#include <QtCore>

#ifdef Q_OS_WASM

#include <emscripten.h>
#include <emscripten/html5.h>


EM_JS(void, initInputBridge,(const char* uuid),{

    var inputId = UTF8ToString(uuid);
    var input = window.document.createElement("input");
    input.setAttribute("id",inputId);
    var styles = "position: absolute; z-index: 1000; top: 0px; left: 0px;margin:0;padding:0; opacity: 1.0; border-width: 0px; display:none;";
    input.setAttribute("style",styles);
    var screen = window.document.getElementById("screen");
    screen.style["position"] = "absolute";
    window.document.body.appendChild(input);
    //    input.onblur=()=>{
    ////        input.style["display"] = "none";
    //        console.log("blur: " , input.value)
    //    }
})

EM_JS(void, setInputBridgePosition, (const char* uuid, int x, int y, int width, int height, int leftPadding, int rightPadding, int topPadding, int bottomPadding),{
    var inputId = UTF8ToString(uuid);
    var input = window.document.getElementById(inputId);
    input.style["left"] = "" + x + "px";
    input.style["top"] = "" + y + "px";
    input.style["width"] = "" + (width-leftPadding-rightPadding-2) + "px";
    input.style["height"] = "" + (height-topPadding-bottomPadding-2) + "px";
    input.style["padding-left"] = "" + leftPadding + "px";
    input.style["padding-right"] = "" + rightPadding + "px";
    input.style["padding-top"] = "" + topPadding + "px";
    input.style["padding-bottom"] = "" + bottomPadding +"px";
    input.style["display"] = "block";
    input.style["border-width"] = "0px";
    input.focus();
    input.value = "";
})

EM_JS(void, setInputBridgeStyle, (const char* uuid, const char* key, const char* value),{
    var inputId = UTF8ToString(uuid);
    var input = window.document.getElementById(inputId);
    var k = UTF8ToString(key);
    var v = UTF8ToString(value);
    input.style[k] = v;
})

EM_JS(void, setInputBridgeAttribute, (const char* uuid, const char* key, const char* value),{
    var inputId = UTF8ToString(uuid);
    var input = window.document.getElementById(inputId);
    var k = UTF8ToString(key);
    var v = UTF8ToString(value);
    input.setAttribute(k,v);
})

EM_JS(void, setInputBridgeText, (const char* uuid, const char* text),{
    var inputId = UTF8ToString(uuid);
    var input = window.document.getElementById(inputId);
    var value = UTF8ToString(text);
    input.value = value;
})

EM_JS(const char*, getInput, (const char* uuid),{
    var inputId = UTF8ToString(uuid);
    var input = window.document.getElementById(inputId);
    var text = input.value;
    var len = lengthBytesUTF8(text)+1;
    var ret = _malloc(len);
    stringToUTF8(text,ret,len);
    return ret;
})

EM_JS(void, removeInput, (const char* uuid),{
    var inputId = UTF8ToString(uuid);
    var input = window.document.getElementById(inputId);
    if(input){
        input.remove();
    }
})

EM_BOOL focusevent_callback(int eventType, const EmscriptenFocusEvent* e, void *userData){
    QString id = QString(e->id);
    PanInputManager *manager = (PanInputManager*)userData;
    manager->setNeedDestroyHTMLInput(true);
    return 0;
}

EM_BOOL blurevent_callback(int eventType, const EmscriptenFocusEvent* e, void *userData){
    QString id = QString(e->id);
    PanInputManager *manager = (PanInputManager*)userData;
    if(id == manager->inputId()){
        QString text = getInput(id.toUtf8().toStdString().c_str());
        manager->setInputText(text);
    }
    return 0;
}

EM_BOOL keydownevent_callback(int eventType, const EmscriptenKeyboardEvent* e, void *userData){
    PanInputManager *manager = (PanInputManager*)userData;
    QString keyString = QString(e->key);

    if(keyString == "Control"){
        manager->setNeedDestroyHTMLInput(false);
    }else if(keyString == "Tab"){
        manager->tabPressed();
    }

    return 0;
}

#else

void initInputBridge(const char* uuid){
}

#endif



PanInputManager::PanInputManager(QObject *parent)
    : QObject{parent}
{
    _isActivated = false;
    _inputId = QUuid::createUuid().toString().replace("-","").replace("{","").replace("}","");
}

void PanInputManager::setPosition(int x, int y, int width, int height, int leftPadding, int rightPadding, int topPadding, int bottomPadding)
{
#ifdef Q_OS_WASM
    setInputBridgePosition(_inputId.toLocal8Bit().data(), x,y,width,height,leftPadding,rightPadding,topPadding,bottomPadding);
#endif
}

void PanInputManager::setDefaultText(const QString& text)
{
#ifdef Q_OS_WASM
    setInputBridgeText(_inputId.toLocal8Bit().data(),text.toLocal8Bit().data());
#endif
}


void PanInputManager::setStyle(const QString& key, const QString& value)
{
#ifdef Q_OS_WASM
    setInputBridgeStyle(_inputId.toLocal8Bit().data(),key.toLocal8Bit().data(),value.toLocal8Bit().data());
#endif
}

void PanInputManager::setInputText(const QString &inputText)
{
    _inputText = inputText;
    emit inputTextChanged();
    deactivate();
}

void PanInputManager::setAttribute(const QString &key, const QString &value)
{
#ifdef Q_OS_WASM
    setInputBridgeAttribute(_inputId.toLocal8Bit().data(),key.toLocal8Bit().data(),value.toLocal8Bit().data());
#endif
}

QString PanInputManager::inputText() const
{
    return _inputText;
}


QString PanInputManager::inputId() const
{
    return _inputId;
}

void PanInputManager::acivate()
{
#ifdef Q_OS_WASM
    if(!_isActivated){
        const char* id = (const char*)_inputId.toLocal8Bit().data();
        initInputBridge(id);
        emscripten_set_blur_callback(EMSCRIPTEN_EVENT_TARGET_WINDOW, this, 1, blurevent_callback);
        emscripten_set_keydown_callback(EMSCRIPTEN_EVENT_TARGET_WINDOW,this,1,keydownevent_callback);
        emscripten_set_focus_callback(EMSCRIPTEN_EVENT_TARGET_WINDOW,this,1,focusevent_callback);
        _needDestroyHTMLInput = true;
        _isActivated = true;
    }
#endif

}

void PanInputManager::deactivate()
{
    _isActivated = false;
#ifdef Q_OS_WASM
    //    emscripten_set_blur_callback(EMSCRIPTEN_EVENT_TARGET_WINDOW, this, 1, NULL);
    if(_needDestroyHTMLInput){
        removeInput(_inputId.toLocal8Bit().data());
        _needDestroyHTMLInput = false;
        emscripten_set_blur_callback(EMSCRIPTEN_EVENT_TARGET_WINDOW, this, 1, NULL);
        emscripten_set_keydown_callback(EMSCRIPTEN_EVENT_TARGET_WINDOW,this,1,NULL);
        emscripten_set_focus_callback(EMSCRIPTEN_EVENT_TARGET_WINDOW,this,1,NULL);
    }
#endif
}

void PanInputManager::setNeedDestroyHTMLInput(bool newNeedDestroyHTMLInput)
{
    _needDestroyHTMLInput = newNeedDestroyHTMLInput;
}

void PanInputManager::tabPressed()
{
#ifdef Q_OS_WASM
    emit tab();
#endif
}
