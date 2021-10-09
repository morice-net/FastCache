
function createFilterDifficultyTerrainGs(){
    var  list = []
    list.push(settings.difficultyMin)
    list.push(settings.difficultyMax)
    list.push(settings.terrainMin)
    list.push(settings.terrainMax)
    return list
}

function createFilterKeywordDiscoverOwner(){
    var  list = []
    list.push(listKeywordDiscoverOwner[0])
    list.push(listKeywordDiscoverOwner[1])
    list.push(listKeywordDiscoverOwner[2])
    return list
}

function disconnectAccount() {
    connector.tokenKey = ""
    connector.expiresAt = 0
    userInfo.name = ""
    userInfo.finds = 0
    userInfo.avatarUrl = ""
    userInfo.premium = ""
}

function reconnectAccount() {
    connector.expiresAt = 0
    connector.connect()
}
