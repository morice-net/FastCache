#include "cacheattribute.h"

CacheAttribute::CacheAttribute(QObject *parent)
    :QObject(parent)
{
    QList<QString> list = CacheAttribute::createListAttributes();

    m_listTextYes =  CacheAttribute::listAttributesYes(list);
    m_listTextNo =  CacheAttribute::listAttributesNo(list);
    m_listIcon =  CacheAttribute::listAttributesIcon(list);
}

CacheAttribute::~CacheAttribute()
{
}

QList<QString> CacheAttribute::createListAttributes()
{
    QList<QString> listAttributes;
    listAttributes.clear();

    listAttributes.append("Chiens autorisés,Chiens interdits,Attributes/attribute_dogs.png");  // 1
    listAttributes.append("Parking payant,Pas de parking payant,Attributes/attribute_fee.png"); // 2
    listAttributes.append("Matériel d\'escalade nécessaire,Matériel d\'escalade pas nécessaire,Attributes/attribute_rappelling.png"); // 3
    listAttributes.append("Bateau nécessaire,Pas de bateau nécessaire,Attributes/attribute_boat.png"); // 4
    listAttributes.append("Matériel de plongée nécessaire,Matériel de plongée pas nécessaire,Attributes/attribute_scuba.png"); // 5
    listAttributes.append("Recommandé pour les enfants,Non recommandé pour les enfants,Attributes/attribute_kids.png");// 6
    listAttributes.append("Prend moins d\'une heure,Prend plus d\'une heure,Attributes/attribute_onehour.png");  // 7
    listAttributes.append("Point de vue,Pas de point de vue,Attributes/attribute_scenic.png"); //8
    listAttributes.append("Randonnée importante,Randonnée peu importante,Attributes/attribute_hiking.png");  // 9
    listAttributes.append("Escalade difficile,Pas d\'escalade difficile,Attributes/attribute_climbing.png"); // 10
    listAttributes.append("Peut demander à barboter,Ne demande pas à barboter,Attributes/attribute_wading.png"); // 11
    listAttributes.append("Peut demander à nager,Ne demande pas à nager,Attributes/attribute_swimming.png"); // 12
    listAttributes.append("Disponible à toute heure,Pas disponible à toute heure,Attributes/attribute_available.png");  //13
    listAttributes.append("Recommandé de nuit,Non recommandé de nuit,Attributes/attribute_night.png");  // 14
    listAttributes.append("Disponible durant l\'hiver,Pas disponible durant l\'hiver,Attributes/attribute_winter.png");  //15
    listAttributes.append(",,");  //16
    listAttributes.append("Plantes toxiques,Pas de plantes toxiques,Attributes/attribute_poisonoak.png"); //17
    listAttributes.append("Animaux dangereux,Pas d\'animaux dangereux,Attributes/attribute_dangerousanimals.png"); //18
    listAttributes.append("Tiques,Pas de tique,Attributes/attribute_ticks.png"); //19
    listAttributes.append("Mines abandonnées,Pas de mine abandonnée,Attributes/attribute_mine.png");  // 20
    listAttributes.append("Chutes de pierres,Pas de chute de pierres,Attributes/attribute_cliff.png"); // 21
    listAttributes.append("Chasse,Pas de chasse,Attributes/attribute_hunting.png");  //22
    listAttributes.append("Zone dangereuse,Pas de zone dangereuse,Attributes/attribute_danger.png"); // 23
    listAttributes.append("Accessible en fauteuil roulant,Pas accessible en fauteuil roulant,Attributes/attribute_wheelchair.png"); //24
    listAttributes.append("Parking possible,Pas de parking possible,Attributes/attribute_parking.png");  //25
    listAttributes.append("Transport public,Pas de transport public,Attributes/attribute_public.png"); // 26
    listAttributes.append("Eau potable proche,Pas d\'eau potable proche,Attributes/attribute_water.png"); // 27
    listAttributes.append("Toilettes publiques proches,Pas de toilette publique proche,Attributes/attribute_restrooms.png");  //28
    listAttributes.append("Téléphone proche,Pas de téléphone proche,Attributes/attribute_phone.png");  //29
    listAttributes.append("Tables de pique-nique proches,Pas de table de pique-nique proche,Attributes/attribute_picnic.png");  //30
    listAttributes.append("Camping possible,Pas de camping possible,Attributes/attribute_camping.png"); // 31
    listAttributes.append("Vélos autorisés,Vélos interdits,Attributes/attribute_bicycles.png"); // 32
    listAttributes.append("Motos autorisées,Motos interdites,Attributes/attribute_motorcycles.png"); // 33
    listAttributes.append("Quads autorisés,Quads interdits,Attributes/attribute_quads .png");  // 34
    listAttributes.append("Véhicules tout-terrain autorisés,Véhicules tout-terrain interdits,Attributes/attribute_jeeps.png");  //35
    listAttributes.append("Motos-neige autorisées,Motos-neige interdites,Attributes/attribute_snowmobiles.png");  // 36
    listAttributes.append("Chevaux autorisés,Chevaux interdits,Attributes/attribute_horses.png");  //37
    listAttributes.append("Feux de camp autorisés,Feux de camp interdits,Attributes/attribute_campfires.png");  //38
    listAttributes.append("Épines,Pas d\'épine,Attributes/attribute_thorn.png"); // 39
    listAttributes.append("Discrétion nécessaire,Discrétion pas nécessaire,Attributes/attribute_stealth.png"); // 40
    listAttributes.append("Accessible en poussette,Pas accessible en poussette,Attributes/attribute_stroller.png"); //41
    listAttributes.append("Nécessite une maintenance,Ne nécessite pas de maintenance,Attributes/attribute_firstaid.png");  // 42
    listAttributes.append("Attention au bétail,Pas de bétail,Attributes/attribute_cow.png");   // 43
    listAttributes.append("Torche nécessaire,Torche pas nécessaire,Attributes/attribute_flashlight.png"); // 44
    listAttributes.append("Circuit Perdu et trouvé,Pas un circuit Perdu et trouvé,Attributes/attribute_landf.png"); // 45
    listAttributes.append("Camions/Camping-cars autorisés,Camions/Camping-cars interdits,Attributes/attribute_rv.png"); // 46
    listAttributes.append("Puzzle de terrain,Pas de puzzle de terrain,Attributes/attribute_field_puzzle.png"); // 47
    listAttributes.append("Lumière UV nécessaire,Lumière UV pas nécessaire,Attributes/attribute_uv.png"); // 48
    listAttributes.append("Chaussures de neige nécessaires,Chaussures de neige pas nécessaires,Attributes/attribute_field_snowshoes.png");  // 49
    listAttributes.append("Skis de fond nécessaires,Skis de fond pas nécessaires,Attributes/attribute_skiis.png");  // 50
    listAttributes.append("Outils spéciaux nécessaires,Outils spéciaux pas nécessaires,Attributes/attribute_s_tool.png");  // 51
    listAttributes.append("Cache de nuit,Pas une cache de nuit,Attributes/attribute_nightcache.png");  // 52
    listAttributes.append("Drive-in,Pas une drive-in,Attributes/attribute_parkngrab.png"); //53
    listAttributes.append("Bâtiment abandonné,Bâtiment non abandonné,Attributes/attribute_abandonedbuilding.png"); // 54
    listAttributes.append("Randonnée courte (moins d\'1 km),Pas de randonnée courte,Attributes/attribute_hike_short.png");  // 55
    listAttributes.append("Randonnée moyenne (1 à 10 km),Pas de randonnée moyenne,Attributes/attribute_hike_med.png"); // 56
    listAttributes.append("Randonnée longue (plus de 10 km),Pas de randonnée longue,Attributes/attribute_hike_long.png"); // 57
    listAttributes.append("Essence proche,Pas d\'essence proche,Attributes/attribute_fuel.png"); // 58
    listAttributes.append("Nourriture proche,Pas de nourriture proche,Attributes/attribute_food.png"); // 59
    listAttributes.append("Balise sans fil,Pas de balise sans fil,Attributes/attribute_wirelessbeacon.png"); // 60
    listAttributes.append("Cache en partenariat,Pas de cache en partenariat,Attributes/attribute_partnership.png"); // 61
    listAttributes.append("Accès saisonnier,Pas d\'accès saisonnier,Attributes/attribute_seasonal.png"); // 62
    listAttributes.append("Ami des touristes,Pas ami avec les touristes,Attributes/attribute_touristok.png");  // 63
    listAttributes.append("Escalade d\'arbre nécessaire,Pas d\'escalade d\'arbre nécessaire,Attributes/attribute_treeclimbing.png"); // 64
    listAttributes.append("Résidence privée,Pas une résidence privée,Attributes/attribute_frontyard.png");  // 65
    listAttributes.append("Travail d\'équipe nécessaire,Pas de travail d\'équipe nécessaire,Attributes/attribute_teamwork.png");  // 66
    listAttributes.append("Partie d\'un GéoTour,Ne fait pas partie d\'un GéoTour,Attributes/attribute_geotour.png");  // 67
    listAttributes.append(",,");  // 68
    listAttributes.append("Cache bonus,N\'est pas une cache bonus,Attributes/attribute_bonuscache.png");  // 69
    listAttributes.append("Fait partie d\'un power trail,Ne fait pas partie d\'un power trail,Attributes/attribute_powertrail.png");  // 70
    listAttributes.append("Cache Challenge,N\'est pas une cache challenge,Attributes/attribute_challengecache.png");  // 71
    listAttributes.append("Checker Geocaching.com activé,Checker Geocaching.com désactivé,Attributes/attribute_hqsolutionchecker.png");  // 72

    return listAttributes;
}

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

