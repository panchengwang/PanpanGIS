#include "PanJsonModel.h"

PanJsonModel::PanJsonModel(QObject *parent)
    : QAbstractItemModel{parent}
{
    _root = nullptr;
}

PanJsonModel::~PanJsonModel()
{
    if(_root){
        delete _root;
    }
}


QModelIndex PanJsonModel::index(int row, int column, const QModelIndex &parent ) const{
    if (!hasIndex(row, column, parent))
        return {};
    PanCatalogNode* node = (PanCatalogNode*) parent.internalPointer();
    if (!node){
        node = _root;
    }
    node = node->child(row);
    if(node){
        return createIndex(row,column,node);
    }
    return {};
}


QModelIndex PanJsonModel::parent(const QModelIndex &index) const{
    if (!index.isValid())
        return {};
    PanCatalogNode* node = (PanCatalogNode*) index.internalPointer();
    PanCatalogNode* parentNode = node->parent();
    if(parentNode != _root){
        return createIndex(parentNode->row(),0,parentNode);
    }
    return QModelIndex{};
}


int PanJsonModel::rowCount(const QModelIndex &parent ) const{
    PanCatalogNode* node = nullptr;
    if(parent.isValid()){
        node = (PanCatalogNode*) parent.internalPointer();
    }else{
        node = _root;
    }

    if(!node){
        return 0;
    }
    return node->childCount();
}


int PanJsonModel::columnCount(const QModelIndex &parent ) const{
    return 1;
}

void PanJsonModel::setData(const QJsonObject &obj)
{
    if(_root){
        delete _root;
        _root = nullptr;
    }

    beginResetModel();

    setupJsonObject(obj,nullptr);

    endResetModel();

    // emit dataChanged();
}

QString PanJsonModel::displayRole() const
{
    return _displayRole;
}

void PanJsonModel::setDisplayRole(const QString &key)
{
    _displayRole = key;
    beginResetModel();
    endResetModel();
}

void PanJsonModel::setupJsonObject(const QJsonObject &obj, PanCatalogNode *parent)
{
    QVariantMap nodedata;

    QStringList keys = obj.keys();
    QJsonArray children;
    foreach (QString key, keys) {
        if(key != "children"){
            nodedata[key] = obj.value(key).toVariant();
        }else{
            children = obj.value("children").toArray();
        }
    }
    PanCatalogNode *node;
    if(!parent ){
        node = new PanCatalogNode(nodedata,nullptr);
        _root = node;
    }else{
        node = new PanCatalogNode(nodedata,parent);
        parent->appendChild(node);
    }
    for(int i=0; i<children.size(); i++){
        setupJsonObject(children[i].toObject(),node);
    }
}


QVariant PanJsonModel::data(const QModelIndex &index, int role ) const{
    if(!index.isValid()){
        return QVariant();
    }
    PanCatalogNode* node = (PanCatalogNode*) index.internalPointer();
    if(!node){
        return QVariant();
    }
    if (role == Qt::DisplayRole){
        return node->data(_displayRole);
    }


    return QVariant();
}

Qt::ItemFlags PanJsonModel::flags(const QModelIndex &index) const
{
    return index.isValid()
               ? QAbstractItemModel::flags(index) : Qt::ItemFlags(Qt::NoItemFlags);
}

QVariant PanJsonModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    return QVariant{};
}

