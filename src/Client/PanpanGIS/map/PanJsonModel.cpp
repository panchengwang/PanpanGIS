#include "PanJsonModel.h"
#include <QtCore>


#define  DATAROLE  (Qt::UserRole + 1)


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

QHash<int, QByteArray> PanJsonModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Qt::DisplayRole] = "display";
    roles[DATAROLE] = "data";
    return roles;
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

bool PanJsonModel::removeRow(int row, const QModelIndex& parent)
{
    PanCatalogNode *parentnode = NULL;
    if(!parent.isValid()){
        parentnode = _root;
    }else{
        parentnode = (PanCatalogNode*) parent.internalPointer();
    }
    PanCatalogNode *node = parentnode->child(row);
    beginRemoveRows(parent,row,row);
    parentnode->removeChild(node);
    endRemoveRows();
    return true;

}

bool PanJsonModel::removeAllRows(const QModelIndex& parent)
{
    PanCatalogNode *parentnode = NULL;
    if(!parent.isValid()){
        parentnode = _root;
    }else{
        parentnode = (PanCatalogNode*) parent.internalPointer();
    }

    beginRemoveRows(parent,0,rowCount(parent)-1);
    parentnode->removeAllChildren();
    endRemoveRows();
    return true;
}

void PanJsonModel::setChildren(const QJsonArray& children, const QModelIndex& parent)
{
    removeAllRows(parent);
    PanCatalogNode *parentnode = NULL;
    if(!parent.isValid()){
        parentnode = _root;
    }else{
        parentnode = (PanCatalogNode*) parent.internalPointer();
    }
    beginInsertRows(parent,0,children.size()-1);
    for(int i=0; i<children.size(); i++){
        setupJsonObject(children.at(i).toObject(), parentnode);
    }
    endInsertRows();
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
    QString str ;
    if (role == Qt::DisplayRole ){
        str = _displayRole;
        QRegularExpression re("\\[([a-zA-z0-9]*)\\]");
        QRegularExpressionMatchIterator it = re.globalMatch(str);
        while(it.hasNext()){
            QRegularExpressionMatch match = it.next();
            QString key = match.captured(1);
            str.replace("["+ key + "]", node->data(key).toString());
        }
        return str;
    }else if( role == DATAROLE){
        return node->data();
    }


    return QVariant();
}


QJsonObject PanJsonModel::attributes(const QModelIndex &index)
{
    if(!index.isValid()){
        return QJsonDocument::fromJson("{}").object();
    }
    PanCatalogNode* node = (PanCatalogNode*) index.internalPointer();
    if(!node){
        return QJsonDocument::fromJson("{}").object();
    }

    return QJsonObject::fromVariantMap(node->data());

}

void PanJsonModel::insertChild(const QModelIndex &parent, const QJsonObject &attributes, int row)
{
    beginInsertRows(parent,row,row);
    PanCatalogNode* node=nullptr;
    if(parent.row() < 0){
        node = _root;
    }else{
        node = (PanCatalogNode*) parent.internalPointer();
        if(!node){
            return;
        }
    }

    PanCatalogNode *child = new PanCatalogNode(attributes.toVariantMap(),node);
    node->appendChild(child,row);

    endInsertRows();
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

