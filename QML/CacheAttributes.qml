import QtQuick 2.6

import com.mycompany.connecting 1.0

Item {
    id: cacheAttributes
    property var attributes:[]

    CacheAttribute {
        id: geotour
        gcId: 67
        textYes: "Partie d\'un GéoTour"
        textNo: "Ne fait pas partie d\'un GéoTour"
        icon: "Attributes/attribute_geotour.png"
        Component.onCompleted: {
            attributes.push(geotour)
        }
    }

    CacheAttribute {
        id:teamwork
        gcId: 66
        textYes: "Travail d\'équipe nécessaire"
        textNo: "Pas de travail d\'équipe nécessaire"
        icon: "Attributes/attribute_teamwork.png"
        Component.onCompleted: {
            attributes.push(teamwork )
        }
    }

    CacheAttribute {
        id:frontyard
        gcId: 65
        textYes: "Résidence privée"
        textNo: "Pas une résidence privée"
        icon: "Attributes/attribute_frontyard.png"
        Component.onCompleted: {
            attributes.push(frontyard)
        }
    }

    CacheAttribute {
        id:treeclimbing
        gcId: 64
        textYes: "Escalade d\'arbre nécessaire"
        textNo: "Pas d\'escalade d\'arbre nécessaire"
        icon: "Attributes/attribute_treeclimbing.png"
        Component.onCompleted: {
            attributes.push(treeclimbing )
        }
    }

    CacheAttribute {
        id: touristok
        gcId: 63
        textYes: "Ami des touristes"
        textNo: "Pas ami avec les touristes"
        icon: "Attributes/attribute_touristok.png"
        Component.onCompleted: {
            attributes.push(touristok)
        }
    }

    CacheAttribute {
        id:seasonal
        gcId: 62
        textYes: "Accès saisonnier"
        textNo: "Pas d\'accès saisonnier"
        icon: "Attributes/attribute_seasonal.png"
        Component.onCompleted: {
            attributes.push(seasonal )
        }
    }

    CacheAttribute {
        id: partnership
        gcId: 61
        textYes: "Cache en partenariat"
        textNo: "Pas de cache en partenariat"
        icon: "Attributes/attribute_partnership.png"
        Component.onCompleted: {
            attributes.push(partnership)
        }
    }

    CacheAttribute {
        id:wirelessbeacon
        gcId: 60
        textYes: "Balise sans fil"
        textNo: "Pas de balise sans fil"
        icon: "Attributes/attribute_wirelessbeacon.png"
        Component.onCompleted: {
            attributes.push(wirelessbeacon )
        }
    }

    CacheAttribute {
        id: food
        gcId: 59
        textYes: "Nourriture proche"
        textNo: "Pas de nourriture proche"
        icon: "Attributes/attribute_food.png"
        Component.onCompleted: {
            attributes.push(food)
        }
    }

    CacheAttribute {
        id:fuel
        gcId: 58
        textYes: "Essence proche"
        textNo: "Pas d\'essence proche"
        icon: "Attributes/attribute_fuel.png"
        Component.onCompleted: {
            attributes.push(fuel )
        }
    }

    CacheAttribute {
        id: hike_long
        gcId: 57
        textYes: "Randonnée longue (plus de 10 km)"
        textNo: "Pas de randonnée longue"
        icon: "Attributes/attribute_hike_long.png"
        Component.onCompleted: {
            attributes.push(hike_long)
        }
    }

    CacheAttribute {
        id:hike_med
        gcId: 56
        textYes: "Randonnée moyenne (1 à 10 km)"
        textNo: "Pas de randonnée moyenne"
        icon: "Attributes/attribute_hike_med.png"
        Component.onCompleted: {
            attributes.push(hike_med )
        }
    }

    CacheAttribute {
        id: hike_short
        gcId: 55
        textYes: "Randonnée courte (moins d\'1 km)"
        textNo: "Pas de randonnée courte"
        icon: "Attributes/attribute_hike_short.png"
        Component.onCompleted: {
            attributes.push(hike_short)
        }
    }

    CacheAttribute {
        id:abandonedbuilding
        gcId: 54
        textYes: "Bâtiment abandonné"
        textNo: "Bâtiment non abandonné"
        icon: "Attributes/attribute_abandonedbuilding.png"
        Component.onCompleted: {
            attributes.push(abandonedbuilding )
        }
    }

    CacheAttribute {
        id: parkngrab
        gcId: 53
        textYes: "Drive-in"
        textNo: "Pas une drive-in"
        icon: "Attributes/attribute_parkngrab.png"
        Component.onCompleted: {
            attributes.push(parkngrab)
        }
    }

    CacheAttribute {
        id:nightcache
        gcId: 52
        textYes: "Cache de nuit"
        textNo: "Pas une cache de nuit"
        icon: "Attributes/attribute_nightcache.png"
        Component.onCompleted: {
            attributes.push(nightcache )
        }
    }

    CacheAttribute {
        id: s_tool
        gcId: 51
        textYes: "Outils spéciaux nécessaires"
        textNo: "Outils spéciaux pas nécessaires"
        icon: "Attributes/attribute_s_tool.png"
        Component.onCompleted: {
            attributes.push(s_tool)
        }
    }

    CacheAttribute {
        id: skiis
        gcId: 50
        textYes: "Skis de fond nécessaires"
        textNo: "Skis de fond pas nécessaires"
        icon: "Attributes/attribute_skiis.png"
        Component.onCompleted: {
            attributes.push(skiis )
        }
    }

    CacheAttribute {
        id: snowshoes
        gcId: 49
        textYes: "Chaussures de neige nécessaires"
        textNo: "Chaussures de neige pas nécessaires"
        icon: "Attributes/attribute_field_snowshoes.png"
        Component.onCompleted: {
            attributes.push(snowshoes)
        }
    }

    CacheAttribute {
        id: uv
        gcId: 48
        textYes: "Lumière UV nécessaire"
        textNo: "Lumière UV pas nécessaire"
        icon: "Attributes/attribute_uv.png"
        Component.onCompleted: {
            attributes.push( uv)
        }
    }

    CacheAttribute {
        id: puzzle
        gcId: 47
        textYes: "Puzzle de terrain"
        textNo: "Pas de puzzle de terrain"
        icon: "Attributes/attribute_field_puzzle.png"
        Component.onCompleted: {
            attributes.push(puzzle)
        }
    }

    CacheAttribute {
        id: rv
        gcId: 46
        textYes: "Camions/Camping-cars autorisés"
        textNo: "Camions/Camping-cars interdits"
        icon: "Attributes/attribute_rv.png"
        Component.onCompleted: {
            attributes.push(rv)
        }
    }

    CacheAttribute {
        id: landf
        gcId: 45
        textYes: "Circuit Perdu et trouvé"
        textNo: "Pas un circuit Perdu et trouvé"
        icon: "Attributes/attribute_landf.png"
        Component.onCompleted: {
            attributes.push(landf)
        }
    }

    CacheAttribute {
        id: flashlight
        gcId: 44
        textYes: "Torche nécessaire"
        textNo: "Torche pas nécessaire"
        icon: "Attributes/attribute_flashlight.png"
        Component.onCompleted: {
            attributes.push(flashlight)
        }
    }

    CacheAttribute {
        id: cow
        gcId: 43
        textYes: "Attention au bétail"
        textNo: "Pas de bétail"
        icon: "Attributes/attribute_cow.png"
        Component.onCompleted: {
            attributes.push(cow)
        }
    }

    CacheAttribute {
        id: firstaid
        gcId: 42
        textYes: "Nécessite une maintenance"
        textNo: "Ne nécessite pas de maintenance"
        icon: "Attributes/attribute_firstaid.png"
        Component.onCompleted: {
            attributes.push(firstaid)
        }
    }

    CacheAttribute {
        id: stroller
        gcId: 41
        textYes: "Accessible en poussette"
        textNo: "Pas accessible en poussette"
        icon: "Attributes/attribute_stroller.png"
        Component.onCompleted: {
            attributes.push(stroller)
        }
    }

    CacheAttribute {
        id: stealth
        gcId: 40
        textYes: "Discrétion nécessaire"
        textNo: "Discrétion pas nécessaire"
        icon: "Attributes/attribute_stealth.png"
        Component.onCompleted: {
            attributes.push(stealth)
        }
    }

    CacheAttribute {
        id: thorn
        gcId: 39
        textYes: "Épines"
        textNo: "Pas d\'épine"
        icon: "Attributes/attribute_.png"
        Component.onCompleted: {
            attributes.push(thorn)
        }
    }

    CacheAttribute {
        id: campfires
        gcId: 38
        textYes: "Feux de camp autorisés"
        textNo: "Feux de camp interdits"
        icon: "Attributes/attribute_campfires.png"
        Component.onCompleted: {
            attributes.push(campfires)
        }
    }

    CacheAttribute {
        id: horses
        gcId: 37
        textYes: "Chevaux autorisés"
        textNo: "Chevaux interdits"
        icon: "Attributes/attribute_horses.png"
        Component.onCompleted: {
            attributes.push(horses)
        }
    }

    CacheAttribute {
        id: snowmobiles
        gcId: 36
        textYes: "Motos-neige autorisées"
        textNo: "Motos-neige interdites"
        icon: "Attributes/attribute_snowmobiles.png"
        Component.onCompleted: {
            attributes.push(snowmobiles)
        }
    }

    CacheAttribute {
        id: jeeps
        gcId:35
        textYes: "Véhicules tout-terrain autorisés"
        textNo: "Véhicules tout-terrain interdits"
        icon: "Attributes/attribute_jeeps.png"
        Component.onCompleted: {
            attributes.push(jeeps)
        }
    }

    CacheAttribute {
        id: quads
        gcId: 34
        textYes: "Quads autorisés"
        textNo: "Quads interdits"
        icon: "Attributes/attribute_quads .png"
        Component.onCompleted: {
            attributes.push(quads )
        }
    }

    CacheAttribute {
        id: motorcycles
        gcId: 33
        textYes: "Motos autorisées"
        textNo: "Motos interdites"
        icon: "Attributes/attribute_motorcycles.png"
        Component.onCompleted: {
            attributes.push(motorcycles)
        }
    }

    CacheAttribute {
        id: bicycles
        gcId: 32
        textYes: "Vélos autorisés"
        textNo: "Vélos interdits"
        icon: "Attributes/attribute_bicycles.png"
        Component.onCompleted: {
            attributes.push(bicycles)
        }
    }

    CacheAttribute {
        id: camping
        gcId: 31
        textYes: "Camping possible"
        textNo: "Pas de camping possible"
        icon: "Attributes/attribute_camping.png"
        Component.onCompleted: {
            attributes.push(camping)
        }
    }

    CacheAttribute {
        id: picnic
        gcId: 30
        textYes: "Tables de pique-nique proches"
        textNo: "Pas de table de pique-nique proche"
        icon: "Attributes/attribute_picnic.png"
        Component.onCompleted: {
            attributes.push(picnic)
        }
    }
    CacheAttribute {
        id: phone
        gcId: 29
        textYes: "Téléphone proche"
        textNo: "Pas de téléphone proche"
        icon: "Attributes/attribute_phone.png"
        Component.onCompleted: {
            attributes.push(phone)
        }
    }

    CacheAttribute {
        id: restrooms
        gcId: 28
        textYes: "Toilettes publiques proches"
        textNo: "Pas de toilette publique proche"
        icon: "Attributes/attribute_restrooms.png"
        Component.onCompleted: {
            attributes.push(restrooms)
        }
    }

    CacheAttribute {
        id: water
        gcId: 27
        textYes: "Eau potable proche"
        textNo: "Pas d\'eau potable proche"
        icon: "Attributes/attribute_water.png"
        Component.onCompleted: {
            attributes.push(water)
        }
    }

    CacheAttribute {
        id: public1
        gcId: 26
        textYes: "Transport public"
        textNo: "Pas de transport public"
        icon: "Attributes/attribute_public.png"
        Component.onCompleted: {
            attributes.push(public1)
        }
    }

    CacheAttribute {
        id: parking
        gcId: 25
        textYes: "Parking possible"
        textNo: "Pas de parking possible"
        icon: "Attributes/attribute_parking.png"
        Component.onCompleted: {
            attributes.push(parking)
        }
    }

    CacheAttribute {
        id: wheelchair
        gcId: 24
        textYes: "Accessible en fauteuil roulant"
        textNo: "Pas accessible en fauteuil roulant"
        icon: "Attributes/attribute_wheelchair.png"
        Component.onCompleted: {
            attributes.push(wheelchair)
        }
    }

    CacheAttribute {
        id: danger
        gcId: 23
        textYes: "Zone dangereuse"
        textNo: "Pas de zone dangereuse"
        icon: "Attributes/attribute_danger.png"
        Component.onCompleted: {
            attributes.push(danger)
        }
    }

    CacheAttribute {
        id: hunting
        gcId: 22
        textYes: "Chasse"
        textNo: "Pas de chasse"
        icon: "Attributes/attribute_hunting.png"
        Component.onCompleted: {
            attributes.push(hunting)
        }
    }

    CacheAttribute {
        id: cliff
        gcId: 21
        textYes: "Chutes de pierres"
        textNo: "Pas de chute de pierres"
        icon: "Attributes/attribute_cliff.png"
        Component.onCompleted: {
            attributes.push(cliff)
        }
    }

    CacheAttribute {
        id: mine
        gcId: 20
        textYes: "Mines abandonnées"
        textNo: "Pas de mine abandonnée"
        icon: "Attributes/attribute_mine.png"
        Component.onCompleted: {
            attributes.push(mine)
        }
    }

    CacheAttribute {
        id: ticks
        gcId: 19
        textYes: "Tiques"
        textNo: "Pas de tique"
        icon: "Attributes/attribute_ticks.png"
        Component.onCompleted: {
            attributes.push(ticks)
        }
    }

    CacheAttribute {
        id: dangerousanimals
        gcId: 18
        textYes: "Animaux dangereux"
        textNo: "Pas d\'animaux dangereux"
        icon: "Attributes/attribute_dangerousanimals.png"
        Component.onCompleted: {
            attributes.push(dangerousanimals)
        }
    }

    CacheAttribute {
        id: poisonoak
        gcId: 17
        textYes: "Plantes toxiques"
        textNo: "Pas de plantes toxiques"
        icon: "Attributes/attribute_poisonoak.png"
        Component.onCompleted: {
            attributes.push(poisonoak)
        }
    }

    CacheAttribute {
        id:no
        gcId: 16
        textYes: ""
        textNo: ""
        icon:"Attributes/attribute_no.png"
        Component.onCompleted: {
            attributes.push(no)
        }
    }

    CacheAttribute {
        id: winter
        gcId: 15
        textYes: "Disponible durant l\'hiver"
        textNo: "Pas disponible durant l\'hiver"
        icon: "Attributes/attribute_winter.png"
        Component.onCompleted: {
            attributes.push(winter)
        }
    }

    CacheAttribute {
        id: night
        gcId: 14
        textYes: "Recommandé de nuit"
        textNo: "Non recommandé de nuit"
        icon: "Attributes/attribute_night.png"
        Component.onCompleted: {
            attributes.push(night)
        }
    }

    CacheAttribute {
        id: available
        gcId: 13
        textYes: "Disponible à toute heure"
        textNo: "Pas disponible à toute heure"
        icon: "Attributes/attribute_available.png"
        Component.onCompleted: {
            attributes.push(available)
        }
    }

    CacheAttribute {
        id: swimming
        gcId: 12
        textYes: "Peut demander à nager"
        textNo: "Ne demande pas à nager"
        icon: "Attributes/attribute_swimming.png"
        Component.onCompleted: {
            attributes.push(swimming)
        }
    }

    CacheAttribute {
        id: wading
        gcId: 11
        textYes: "Peut demander à barboter"
        textNo: "Ne demande pas à barboter"
        icon: "Attributes/attribute_wading.png"
        Component.onCompleted: {
            attributes.push(wading)
        }
    }

    CacheAttribute {
        id:climbing
        gcId: 10
        textYes: "Escalade difficile"
        textNo: "Pas d\'escalade difficile"
        icon: "Attributes/attribute_climbing.png"
        Component.onCompleted: {
            attributes.push(climbing)
        }
    }

    CacheAttribute {
        id: hiking
        gcId: 9
        textYes: "Randonnée importante"
        textNo: "Randonnée peu importante"
        icon: "Attributes/attribute_hiking.png"
        Component.onCompleted: {
            attributes.push(hiking)
        }
    }


    CacheAttribute {
        id: scenic
        gcId: 8
        textYes: "Point de vue"
        textNo: "Pas de point de vue"
        icon: "Attributes/attribute_scenic.png"
        Component.onCompleted: {
            attributes.push(scenic)
        }
    }

    CacheAttribute {
        id: onehour
        gcId: 7
        textYes: "Prend moins d\'une heure"
        textNo: "Prend plus d\'une heure"
        icon: "Attributes/attribute_onehour.png"
        Component.onCompleted: {
            attributes.push(onehour)
        }
    }

    CacheAttribute {
        id: kids
        gcId: 6
        textYes: "Recommandé pour les enfants"
        textNo: "Non recommandé pour les enfants"
        icon: "Attributes/attribute_kids.png"
        Component.onCompleted: {
            attributes.push(kids)
        }
    }

    CacheAttribute {
        id: scuba
        gcId: 5
        textYes: "Matériel de plongée nécessaire"
        textNo: "Matériel de plongée pas nécessaire"
        icon: "Attributes/attribute_scuba.png"
        Component.onCompleted: {
            attributes.push(scuba)
        }
    }

    CacheAttribute {
        id: boat
        gcId: 4
        textYes: "Bateau nécessaire"
        textNo: "Pas de bateau nécessaire"
        icon: "Attributes/attribute_boat.png"
        Component.onCompleted: {
            attributes.push(boat)
        }
    }

    CacheAttribute {
        id: rappelling
        gcId: 3
        textYes: "Matériel d\'escalade nécessaire"
        textNo: "Matériel d\'escalade pas nécessaire"
        icon: "Attributes/attribute_rappelling.png"
        Component.onCompleted: {
            attributes.push(rappelling)
        }
    }

    CacheAttribute {
        id: fee
        gcId: 2
        textYes: "Parking payant"
        textNo: "Pas de parking payant"
        icon: "Attributes/attribute_fee.png"
        Component.onCompleted: {
            attributes.push(fee)
        }
    }

    CacheAttribute {
        id: dogs
        gcId: 1
        textYes: "Chiens autorisés"
        textNo: "Chiens interdits"
        icon: "Attributes/attribute_dogs.png"
        Component.onCompleted: {
            attributes.push(dogs)
        }
    }
}
