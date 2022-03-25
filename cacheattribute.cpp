#include "cacheattribute.h"

#include <QDebug>

CacheAttribute::CacheAttribute(QObject *parent)
    :QObject(parent)
{
    QList<QString> list = CacheAttribute::createListAttributes();

    m_listTextYes =  CacheAttribute::listAttributesYes(list);
    m_listTextNo =  CacheAttribute::listAttributesNo(list);
    m_listIcon =  CacheAttribute::listAttributesIcon(list);
    m_listGroup =  CacheAttribute::listAttributesGroup(list);
    m_numberAttributesByGroup = QList<int>();
    m_sortedAttributesByGroup = QList<int>();
    m_sortedBoolByGroup = QList<bool>();
}

CacheAttribute::~CacheAttribute()
{
}

QList<QString> CacheAttribute::createListAttributes()
{
    QList<QString> listAttributes;
    listAttributes.clear();

    listAttributes.append("Chiens autorisés,Chiens interdits,Attributes/attribute_dogs.png,10");  // 1
    listAttributes.append("Parking payant,Pas de parking payant,Attributes/attribute_fee.png,20"); // 2
    listAttributes.append("Matériel d\'escalade nécessaire,Matériel d\'escalade pas nécessaire,Attributes/attribute_rappelling.png,20"); // 3
    listAttributes.append("Bateau nécessaire,Pas de bateau nécessaire,Attributes/attribute_boat.png,20"); // 4
    listAttributes.append("Matériel de plongée nécessaire,Matériel de plongée pas nécessaire,Attributes/attribute_scuba.png,20"); // 5
    listAttributes.append("Recommandé pour les enfants,Non recommandé pour les enfants,Attributes/attribute_kids.png,30");// 6
    listAttributes.append("Prend moins d\'une heure,Prend plus d\'une heure,Attributes/attribute_onehour.png,30");  // 7
    listAttributes.append("Point de vue,Pas de point de vue,Attributes/attribute_scenic.png,30"); //8
    listAttributes.append("Randonnée importante,Randonnée peu importante,Attributes/attribute_hiking.png,30");  // 9
    listAttributes.append("Escalade difficile,Pas d\'escalade difficile,Attributes/attribute_climbing.png,30"); // 10
    listAttributes.append("Peut demander à barboter,Ne demande pas à barboter,Attributes/attribute_wading.png,30"); // 11
    listAttributes.append("Peut demander à nager,Ne demande pas à nager,Attributes/attribute_swimming.png,30"); // 12
    listAttributes.append("Disponible à toute heure,Pas disponible à toute heure,Attributes/attribute_available.png,30");  //13
    listAttributes.append("Recommandé de nuit,Non recommandé de nuit,Attributes/attribute_night.png,30");  // 14
    listAttributes.append("Disponible durant l\'hiver,Pas disponible durant l\'hiver,Attributes/attribute_winter.png,30");  //15
    listAttributes.append(",,,");  //16
    listAttributes.append("Plantes toxiques,Pas de plantes toxiques,Attributes/attribute_poisonoak.png,40"); //17
    listAttributes.append("Animaux dangereux,Pas d\'animaux dangereux,Attributes/attribute_dangerousanimals.png,40"); //18
    listAttributes.append("Tiques,Pas de tique,Attributes/attribute_ticks.png,40"); //19
    listAttributes.append("Mines abandonnées,Pas de mine abandonnée,Attributes/attribute_mine.png,40");  // 20
    listAttributes.append("Chutes de pierres,Pas de chute de pierres,Attributes/attribute_cliff.png,40"); // 21
    listAttributes.append("Chasse,Pas de chasse,Attributes/attribute_hunting.png,40");  //22
    listAttributes.append("Zone dangereuse,Pas de zone dangereuse,Attributes/attribute_danger.png,40"); // 23
    listAttributes.append("Accessible en fauteuil roulant,Pas accessible en fauteuil roulant,Attributes/attribute_wheelchair.png,50"); //24
    listAttributes.append("Parking possible,Pas de parking possible,Attributes/attribute_parking.png,50");  //25
    listAttributes.append("Transport public,Pas de transport public,Attributes/attribute_public.png,50"); // 26
    listAttributes.append("Eau potable proche,Pas d\'eau potable proche,Attributes/attribute_water.png,50"); // 27
    listAttributes.append("Toilettes publiques proches,Pas de toilette publique proche,Attributes/attribute_restrooms.png,50");  //28
    listAttributes.append("Téléphone proche,Pas de téléphone proche,Attributes/attribute_phone.png,50");  //29
    listAttributes.append("Tables de pique-nique proches,Pas de table de pique-nique proche,Attributes/attribute_picnic.png,50");  //30
    listAttributes.append("Camping possible,Pas de camping possible,Attributes/attribute_camping.png,50"); // 31
    listAttributes.append("Vélos autorisés,Vélos interdits,Attributes/attribute_bicycles.png,10"); // 32
    listAttributes.append("Motos autorisées,Motos interdites,Attributes/attribute_motorcycles.png,10"); // 33
    listAttributes.append("Quads autorisés,Quads interdits,Attributes/attribute_quads .png,10");  // 34
    listAttributes.append("Véhicules tout-terrain autorisés,Véhicules tout-terrain interdits,Attributes/attribute_jeeps.png,10");  //35
    listAttributes.append("Motos-neige autorisées,Motos-neige interdites,Attributes/attribute_snowmobiles.png,10");  // 36
    listAttributes.append("Chevaux autorisés,Chevaux interdits,Attributes/attribute_horses.png,10");  //37
    listAttributes.append("Feux de camp autorisés,Feux de camp interdits,Attributes/attribute_campfires.png,10");  //38
    listAttributes.append("Épines,Pas d\'épine,Attributes/attribute_thorn.png,40"); // 39
    listAttributes.append("Discrétion nécessaire,Discrétion pas nécessaire,Attributes/attribute_stealth.png,30"); // 40
    listAttributes.append("Accessible en poussette,Pas accessible en poussette,Attributes/attribute_stroller.png,50"); //41
    listAttributes.append("Nécessite une maintenance,Ne nécessite pas de maintenance,Attributes/attribute_firstaid.png,30");  // 42
    listAttributes.append("Attention au bétail,Pas de bétail,Attributes/attribute_cow.png,30");   // 43
    listAttributes.append("Torche nécessaire,Torche pas nécessaire,Attributes/attribute_flashlight.png,20"); // 44
    listAttributes.append("Circuit Perdu et trouvé,Pas un circuit Perdu et trouvé,Attributes/attribute_landf.png,60"); // 45
    listAttributes.append("Camions/Camping-cars autorisés,Camions/Camping-cars interdits,Attributes/attribute_rv.png,10"); // 46
    listAttributes.append("Puzzle de terrain,Pas de puzzle de terrain,Attributes/attribute_field_puzzle.png,30"); // 47
    listAttributes.append("Lumière UV nécessaire,Lumière UV pas nécessaire,Attributes/attribute_uv.png,20"); // 48
    listAttributes.append("Chaussures de neige nécessaires,Chaussures de neige pas nécessaires,Attributes/attribute_field_snowshoes.png,20");  // 49
    listAttributes.append("Skis de fond nécessaires,Skis de fond pas nécessaires,Attributes/attribute_skiis.png,20");  // 50
    listAttributes.append("Outils spéciaux nécessaires,Outils spéciaux pas nécessaires,Attributes/attribute_s_tool.png,20");  // 51
    listAttributes.append("Cache de nuit,Pas une cache de nuit,Attributes/attribute_nightcache.png,30");  // 52
    listAttributes.append("Drive-in,Pas une drive-in,Attributes/attribute_parkngrab.png,30"); //53
    listAttributes.append("Bâtiment abandonné,Bâtiment non abandonné,Attributes/attribute_abandonedbuilding.png,30"); // 54
    listAttributes.append("Randonnée courte (moins d\'1 km),Pas de randonnée courte,Attributes/attribute_hike_short.png,30");  // 55
    listAttributes.append("Randonnée moyenne (1 à 10 km),Pas de randonnée moyenne,Attributes/attribute_hike_med.png,30"); // 56
    listAttributes.append("Randonnée longue (plus de 10 km),Pas de randonnée longue,Attributes/attribute_hike_long.png,30"); // 57
    listAttributes.append("Essence proche,Pas d\'essence proche,Attributes/attribute_fuel.png,50"); // 58
    listAttributes.append("Nourriture proche,Pas de nourriture proche,Attributes/attribute_food.png,50"); // 59
    listAttributes.append("Balise sans fil,Pas de balise sans fil,Attributes/attribute_wirelessbeacon.png,20"); // 60
    listAttributes.append("Cache en partenariat,Pas de cache en partenariat,Attributes/attribute_partnership.png,60"); // 61
    listAttributes.append("Accès saisonnier,Pas d\'accès saisonnier,Attributes/attribute_seasonal.png,30"); // 62
    listAttributes.append("Ami des touristes,Pas ami avec les touristes,Attributes/attribute_touristok.png,30");  // 63
    listAttributes.append("Escalade d\'arbre nécessaire,Pas d\'escalade d\'arbre nécessaire,Attributes/attribute_treeclimbing.png,20"); // 64
    listAttributes.append("Résidence privée,Pas une résidence privée,Attributes/attribute_frontyard.png,30");  // 65
    listAttributes.append("Travail d\'équipe nécessaire,Pas de travail d\'équipe nécessaire,Attributes/attribute_teamwork.png,30");  // 66
    listAttributes.append("Partie d\'un GéoTour,Ne fait pas partie d\'un GéoTour,Attributes/attribute_geotour.png,60");  // 67
    listAttributes.append(",,,");  // 68
    listAttributes.append("Cache bonus,N\'est pas une cache bonus,Attributes/attribute_bonuscache.png,30");  // 69
    listAttributes.append("Fait partie d\'un power trail,Ne fait pas partie d\'un power trail,Attributes/attribute_powertrail.png,30");  // 70
    listAttributes.append("Cache Challenge,N\'est pas une cache challenge,Attributes/attribute_challengecache.png,30");  // 71
    listAttributes.append("Checker Geocaching.com activé,Checker Geocaching.com désactivé,Attributes/attribute_hqsolutionchecker.png,60");  // 72

    return listAttributes;
}

// all attributes
QList<QString>  CacheAttribute::listAttributesYes(QList<QString> list)
{
    QList<QString> createList;
    createList.clear();

    for(int i = 0; i < list.length(); ++i)
    {
        createList.append(list[i].split(',')[0]);

    }
    return createList;
}

QList<QString>  CacheAttribute::listAttributesNo(QList<QString> list)
{
    QList<QString> createList;
    createList.clear();

    for(int i = 0; i < list.length(); ++i)
    {
        createList.append(list[i].split(',')[1]);

    }
    return createList;
}

QList<QString>  CacheAttribute::listAttributesIcon(QList<QString> list)
{
    QList<QString> createList;
    createList.clear();

    for(int i = 0; i < list.length(); ++i)
    {
        createList.append(list[i].split(',')[2]);

    }
    return createList;
}

QList<int>  CacheAttribute::listAttributesGroup(QList<QString> list)
{
    QList<int> createList;
    createList.clear();

    for(int i = 0; i < list.length(); ++i)
    {
        createList.append(list[i].split(',')[3].toInt());

    }
    return createList;
}

// attributes of cache
QList<QString> CacheAttribute::sortAttributes(QList<bool> listBool , QList<int> listAtt)
{
    QList<QString> list;  // text with header and attributes
    list.clear();
    if(listBool.isEmpty() || listAtt.isEmpty() || listBool.size() != listAtt.size())
        return list;

    QList<QString> list1;
    QList<QString> list2;
    QList<QString> list3;
    QList<QString> list4;
    QList<QString> list5;
    QList<QString> list6;

    for(int i = 0; i < listAtt.size(); ++i)
    {
        switch(m_listGroup[listAtt[i]-1]){
        case 10:  // permissions
            list1.append(QString::number(listAtt[i]) + "," + QVariant(listBool[i]).toString());
            break;
        case 20:  // equipment
            list2.append(QString::number(listAtt[i]) + "," + QVariant(listBool[i]).toString());
            break;
        case 30:  // Conditions
            list3.append(QString::number(listAtt[i]) + "," + QVariant(listBool[i]).toString());
            break;
        case 40:  // hazards
            list4.append(QString::number(listAtt[i]) + "," + QVariant(listBool[i]).toString());
            break;
        case 50:  // facilities
            list5.append(QString::number(listAtt[i]) + "," + QVariant(listBool[i]).toString());
            break;
        case 60:  // specials
            list6.append(QString::number(listAtt[i]) + "," + QVariant(listBool[i]).toString());
            break;
        default:
            break;
        }
    }
    m_numberAttributesByGroup.clear();
    m_sortedAttributesByGroup.clear();
    m_sortedBoolByGroup.clear();

    if(list1.size() != 0) {
        m_numberAttributesByGroup.append(list1.size());
        list.append(headerText(10));
    }
    for(int i = 0; i < list1.size(); ++i) {
        m_sortedAttributesByGroup.append(list1[i].split(',')[0].toInt());
        m_sortedBoolByGroup.append(QVariant(list1[i].split(',')[1]).toBool());
        if(QVariant(list1[i].split(',')[1]).toBool()) {
            list.append(m_listTextYes[list1[i].split(',')[0].toInt() - 1]);
        } else {
            list.append(m_listTextNo[list1[i].split(',')[0].toInt() - 1]);
        }

    }

    if(list2.size() != 0) {
        m_numberAttributesByGroup.append(list2.size());
        list.append(headerText(20));
    }
    for(int i = 0; i < list2.size(); ++i) {
        m_sortedAttributesByGroup.append(list2[i].split(',')[0].toInt());
        m_sortedBoolByGroup.append(QVariant(list2[i].split(',')[1]).toBool());
        if(QVariant(list2[i].split(',')[1]).toBool()) {
            list.append(m_listTextYes[list2[i].split(',')[0].toInt() - 1]);
        } else {
            list.append(m_listTextNo[list2[i].split(',')[0].toInt() - 1]);
        }
    }

    if(list3.size() != 0) {
        m_numberAttributesByGroup.append(list3.size());
        list.append(headerText(30));
    }
    for(int i = 0; i < list3.size(); ++i) {
        m_sortedAttributesByGroup.append(list3[i].split(',')[0].toInt());
        m_sortedBoolByGroup.append(QVariant(list3[i].split(',')[1]).toBool());
        if(QVariant(list3[i].split(',')[1]).toBool()) {
            list.append(m_listTextYes[list3[i].split(',')[0].toInt() - 1]);
        } else {
            list.append(m_listTextNo[list3[i].split(',')[0].toInt() - 1]);
        }
    }
    if(list4.size() != 0) {
        m_numberAttributesByGroup.append(list4.size());
        list.append(headerText(40));
    }
    for(int i = 0; i < list4.size(); ++i) {
        m_sortedAttributesByGroup.append(list4[i].split(',')[0].toInt());
        m_sortedBoolByGroup.append(QVariant(list4[i].split(',')[1]).toBool());
        if(QVariant(list4[i].split(',')[1]).toBool()) {
            list.append(m_listTextYes[list4[i].split(',')[0].toInt() - 1]);
        } else {
            list.append(m_listTextNo[list4[i].split(',')[0].toInt() - 1]);
        }
    }

    if(list5.size() != 0) {
        m_numberAttributesByGroup.append(list5.size());
        list.append(headerText(50));
    }
    for(int i = 0; i < list5.size(); ++i) {
        m_sortedAttributesByGroup.append(list5[i].split(',')[0].toInt());
        m_sortedBoolByGroup.append(QVariant(list5[i].split(',')[1]).toBool());
        if(QVariant(list5[i].split(',')[1]).toBool()) {
            list.append(m_listTextYes[list5[i].split(',')[0].toInt() - 1]);
        } else {
            list.append(m_listTextNo[list5[i].split(',')[0].toInt() - 1]);
        }
    }

    if(list6.size() != 0) {
        m_numberAttributesByGroup.append(list6.size());
        list.append(headerText(60));
    }
    for(int i = 0; i < list6.size(); ++i) {
        m_sortedAttributesByGroup.append(list6[i].split(',')[0].toInt());
        m_sortedBoolByGroup.append(QVariant(list6[i].split(',')[1]).toBool());
        if(QVariant(list6[i].split(',')[1]).toBool()) {
            list.append(m_listTextYes[list6[i].split(',')[0].toInt() - 1]);
        } else {
            list.append(m_listTextNo[list6[i].split(',')[0].toInt() - 1]);
        }
    }
    emit sortedAttributesByGroupChanged();
    emit sortedBoolByGroupChanged();
    emit numberAttributesByGroupChanged();
    return list;
}

QString  CacheAttribute::headerText(int index)
{
    if(index == 10) //permissions
        return "Autorisations";
    if(index == 20) //equipment
        return "Equipement";
    if(index == 30) // conditions
        return "Conditions";
    if(index == 40) //hazards
        return "Dangers";
    if(index == 50) //facilities
        return "Installations";
    if(index == 60) //specials
        return "Promotions";
    return "";
}

/** Getters and setters**/

QList<QString> CacheAttribute::listTextYes() const
{
    return m_listTextYes;
}

QList<QString> CacheAttribute::listTextNo() const
{
    return m_listTextNo;
}

QList<QString> CacheAttribute::listIcon() const
{
    return m_listIcon;
}

QList<int> CacheAttribute::listGroup() const
{
    return m_listGroup;
}

QList<int> CacheAttribute::numberAttributesByGroup() const
{
    return m_numberAttributesByGroup;
}

void CacheAttribute::setNumberAttributesByGroup(QList<int> list)
{
    m_numberAttributesByGroup = list;
    emit numberAttributesByGroupChanged();
}

QList<int> CacheAttribute::sortedAttributesByGroup() const
{
    return m_sortedAttributesByGroup;
}

void CacheAttribute::setSortedAttributesByGroup(QList<int> list)
{
    m_sortedAttributesByGroup = list;
    emit sortedAttributesByGroupChanged();
}

QList<bool> CacheAttribute::sortedBoolByGroup() const
{
    return m_sortedBoolByGroup;
}

void CacheAttribute::setSortedBoolByGroup(QList<bool> list)
{
    m_sortedBoolByGroup = list;
    emit sortedBoolByGroupChanged();
}



