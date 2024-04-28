#ifndef PANINPUTMANAGER_H
#define PANINPUTMANAGER_H

#include <QObject>
#include <QQmlEngine>

class PanInputManager : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString inputText READ inputText NOTIFY inputTextChanged FINAL)

public:
    explicit PanInputManager(QObject *parent = nullptr);

    Q_INVOKABLE void setPosition(int x, int y, int width, int height, int leftPadding, int rightPadding, int topPadding, int bottomPadding);
    Q_INVOKABLE void setDefaultText(const QString& text);
    Q_INVOKABLE void setStyle(const QString &key, const QString &value);
    Q_INVOKABLE QString inputText() const;
    Q_INVOKABLE void setInputText(const QString& inputText);
    Q_INVOKABLE void setAttribute(const QString& key, const QString& value);

    QString inputId() const;
    Q_INVOKABLE void acivate();
    Q_INVOKABLE void deactivate();

    void setNeedDestroyHTMLInput(bool newNeedDestroyHTMLInput);
    void tabPressed();
signals:
    void inputTextChanged();
    void tab();

protected:
    QString _inputText;
    QString _inputId;
    bool _isActivated;
    bool _needDestroyHTMLInput;
};



#endif // PANINPUTMANAGER_H
