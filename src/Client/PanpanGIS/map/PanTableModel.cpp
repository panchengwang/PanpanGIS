#include "PanTableModel.h"

PanTableModel::PanTableModel(QObject* parent)
    : QAbstractTableModel(parent)
{

}

PanTableModel::~PanTableModel()
{

}

QJsonArray PanTableModel::rows() const
{
    return _rows;
}

QJsonArray PanTableModel::columns() const
{
    return _columns;
}

void PanTableModel::setRows(const QJsonArray& rows)
{
    beginResetModel();
    _rows = rows;
    endResetModel();
}

void PanTableModel::setColumns(const QJsonArray& columns)
{
    beginResetModel();
    _columns = columns;
    endResetModel();
}


QHash<int, QByteArray> PanTableModel::roleNames() const
{
    return { {Qt::DisplayRole, "display"} };
}

int PanTableModel::rowCount(const QModelIndex& parent) const
{
    return _rows.size();
}

int PanTableModel::columnCount(const QModelIndex& parent) const
{
    return _columns.size();
}

QVariant PanTableModel::data(const QModelIndex& index, int role) const
{
    QJsonObject obj = _rows.at(index.row()).toObject();
    QString key = _columns.at(index.column()).toObject().value("id").toString();

    return QVariant(obj.value(key).toString());
}

Qt::ItemFlags PanTableModel::flags(const QModelIndex& index) const
{
    return Qt::ItemIsEditable | Qt::ItemIsSelectable | Qt::ItemIsEnabled;
}

QVariant PanTableModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    if(orientation == Qt::Horizontal){
        if(_columns.at(section).toObject().contains("label")){
            return _columns.at(section).toObject().value("label").toString();
        }
        return _columns.at(section).toObject().value("id").toString();
    }

    return QVariant();
}
