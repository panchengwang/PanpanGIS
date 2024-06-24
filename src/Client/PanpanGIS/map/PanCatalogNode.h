#ifndef PanCatalogNode_H
#define PanCatalogNode_H

#include <QtCore>


class PanCatalogNode
{
public:
    explicit PanCatalogNode(QVariantMap data, PanCatalogNode *parentItem = nullptr);

    virtual ~PanCatalogNode();

    void appendChild(PanCatalogNode *child);

    PanCatalogNode *child(int row);
    int childCount() const;
    int columnCount() const;
    QVariant data(const QString& key) const;
    int row() const;
    PanCatalogNode *parent();

private:
    std::vector<PanCatalogNode*> _children;
    QVariantMap _data;
    PanCatalogNode *_parent;
};


#endif // PanCatalogNode_H
