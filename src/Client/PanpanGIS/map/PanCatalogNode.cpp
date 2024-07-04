
#include "PanCatalogNode.h"


PanCatalogNode::PanCatalogNode(QVariantMap data, PanCatalogNode *parent)
    :  _parent(parent)
{
    _data = data;
}

PanCatalogNode::~PanCatalogNode()
{
    for(int i=0; i<_children.size(); i++){
        delete _children[i];
    }
}



void PanCatalogNode::appendChild(PanCatalogNode* child, int row)
{
    if(row<0 || row > _children.size()-1){
        _children.push_back(child);
    }else{

        _children.insert(row,child);
    }
}



PanCatalogNode *PanCatalogNode::child(int row)
{
    return row >= 0 && row < childCount() ? _children[row] : nullptr;
}



int PanCatalogNode::childCount() const
{
    return _children.size();
}



int PanCatalogNode::columnCount() const
{
    return _data.keys().size();
}


QVariant PanCatalogNode::data(const QString& key) const
{
    return _data[key];
}

QVariantMap PanCatalogNode::data() const
{
    return _data;
}



PanCatalogNode *PanCatalogNode::parent()
{
    return _parent;
}



int PanCatalogNode::row() const
{
    if (_parent == nullptr)
        return 0;
    for(int i=0; i<_parent->_children.size(); i++){
        if(this == _parent->_children[i]){
            return i;
        }
    }
    return -1;
}

