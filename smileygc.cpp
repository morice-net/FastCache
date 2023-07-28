#include "smileygc.h"

SmileyGc::SmileyGc(QObject *parent)
    : QObject(parent)
{
    m_mapSmileyGc.insert(":)","http://www.geocaching.com/images/icons/icon_smile.gif");
    m_mapSmileyGc.insert(":D","http://www.geocaching.com/images/icons/icon_smile_big.gif");
    m_mapSmileyGc.insert("8D","http://www.geocaching.com/images/icons/icon_smile_cool.gif");
    m_mapSmileyGc.insert(":I","http://www.geocaching.com/images/icons/icon_smile_blush.gif" );
    m_mapSmileyGc.insert(":P","http://www.geocaching.com/images/icons/icon_smile_tongue.gif");
    m_mapSmileyGc.insert("}:","http://www.geocaching.com/images/icons/icon_smile_evil.gif");
    m_mapSmileyGc.insert(";)","http://www.geocaching.com/images/icons/icon_smile_wink.gif" );
    m_mapSmileyGc.insert(":o","http://www.geocaching.com/images/icons/icon_smile_clown.gif");
    m_mapSmileyGc.insert("B","http://www.geocaching.com/images/icons/icon_smile_blackeye.gif");
    m_mapSmileyGc.insert("8","http://www.geocaching.com/images/icons/icon_smile_8ball.gif" );
    m_mapSmileyGc.insert(":(","http://www.geocaching.com/images/icons/icon_smile_sad.gif");
    m_mapSmileyGc.insert("8)","http://www.geocaching.com/images/icons/icon_smile_shy.gif");
    m_mapSmileyGc.insert(":O","http://www.geocaching.com/images/icons/icon_smile_shock.gif");
    m_mapSmileyGc.insert(":(!","http://www.geocaching.com/images/icons/icon_smile_angry.gif");
    m_mapSmileyGc.insert("xx(","http://www.geocaching.com/images/icons/icon_smile_dead.gif");
    m_mapSmileyGc.insert("|)","http://www.geocaching.com/images/icons/icon_smile_sleepy.gif");
    m_mapSmileyGc.insert(":X","http://www.geocaching.com/images/icons/icon_smile_kisses.gif");
    m_mapSmileyGc.insert("^","http://www.geocaching.com/images/icons/icon_smile_approve.gif");
    m_mapSmileyGc.insert("disapprove","http://www.geocaching.com/images/icons/icon_smile_dissapprove.gif");
    m_mapSmileyGc.insert("?","http://www.geocaching.com/images/icons/icon_smile_question.gif");
}

QString SmileyGc::replaceSmileyTextToImgSrc(const QString &text) const
{
    QString newString = text;
    for(const auto &e : m_mapSmileyGc.keys())    {

        newString.replace("[" + e + "]" , R"(<img src=)" + m_mapSmileyGc.value(e) + R"( width="25")" +  R"(/>)" );
    }
    return newString;
}
