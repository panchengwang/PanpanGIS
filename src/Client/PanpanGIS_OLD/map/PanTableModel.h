#ifndef PANTABLEMODEL_H
#define PANTABLEMODEL_H

#include <QObject>
#include <QQmlEngine>
#include <QAbstractTableModel>
#include <QtCore>

class PanTableModel : public QAbstractTableModel
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QJsonArray rows READ rows WRITE setRows NOTIFY rowsChanged FINAL)
    Q_PROPERTY(QJsonArray columns READ columns WRITE setColumns NOTIFY columnsChanged FINAL)

public:
    explicit PanTableModel(QObject *parent = nullptr);
    virtual ~PanTableModel() override;

    QJsonArray rows() const;
    QJsonArray columns() const;
    void setRows(const QJsonArray& rows);
    void setColumns(const QJsonArray& columns);

     QHash<int, QByteArray> roleNames() const override;
    Q_INVOKABLE int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    Q_INVOKABLE int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    Q_INVOKABLE QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    Q_INVOKABLE Qt::ItemFlags flags(const QModelIndex &index) const override;
    Q_INVOKABLE QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;
signals:
    void rowsChanged();
    void columnsChanged();

protected:
    QJsonArray _columns;
    QJsonArray _rows;
};

#endif // PANTABLEMODEL_H
