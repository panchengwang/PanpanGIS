#ifndef PANJSONMODEL_H
#define PANJSONMODEL_H

#include <QAbstractItemModel>
#include <QObject>
#include <QQmlEngine>
#include <QVector>
#include "PanCatalogNode.h"

class PanJsonModel : public QAbstractItemModel
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QJsonObject data WRITE setData NOTIFY dataChanged FINAL)
    Q_PROPERTY(QString displayRole READ displayRole WRITE setDisplayRole NOTIFY displayRoleChanged FINAL)


public:
    Q_DISABLE_COPY_MOVE(PanJsonModel)

    explicit PanJsonModel(QObject *parent = nullptr);
    ~PanJsonModel() override;

    QVariant data(const QModelIndex &index, int role) const override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;
    QVariant headerData(int section, Qt::Orientation orientation,
                        int role = Qt::DisplayRole) const override;
    QModelIndex index(int row, int column,
                      const QModelIndex &parent = {}) const override;
    QModelIndex parent(const QModelIndex &index) const override;
    int rowCount(const QModelIndex &parent = {}) const override;
    int columnCount(const QModelIndex &parent = {}) const override;

    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void setData(const QJsonObject& obj);

    QString displayRole() const;
    void setDisplayRole(const QString& key);

    Q_INVOKABLE QJsonObject attributes(const QModelIndex& index);
    Q_INVOKABLE void insertChild(const QModelIndex& parent, const QJsonObject& attributes, int row = 0 );

signals:
    void dataChanged();
    void displayRoleChanged();

private:
    void setupJsonObject(const QJsonObject& obj, PanCatalogNode *parent);

    PanCatalogNode* _root;

    QString _displayRole="[name]";

};


#endif // PANJSONMODEL_H
