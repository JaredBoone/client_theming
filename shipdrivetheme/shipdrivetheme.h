/*
 * Copyright (C) by Roeland Jago Douma <roeland@famdouma.nl>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
 * for more details.
 */

#ifndef SHIPDRIVE_THEME_H
#define SHIPDRIVE_THEME_H

#include "theme.h"

#include <QString>
#include <QPixmap>
#include <QIcon>
#include <QApplication>

#include <QStandardPaths>

#include "version.h"
#include "config.h"


namespace OCC {

/**
 * @brief The ShipdriveTheme class
 * @ingroup libsync
 */
class ShipdriveTheme : public Theme
{

public:
    ShipdriveTheme() {};
    
    QString overrideServerUrl() const  {
        return QString("https://drive.ship.scea.com");
    }
    
    QString defaultServerFolder() const  {
        return QString("/");
    }
    
    QString defaultClientFolder() const {
        return QString(QStandardPaths::writableLocation(QStandardPaths::DesktopLocation) + QDir::separator() + appName());
    }
    
    bool multiAccount() const  {
        return false;
    }
    
    QString configFileName() const  {
        return QLatin1String("shipdrive.cfg");
    }

    QIcon trayFolderIcon( const QString& ) const  {
        return themeIcon( QLatin1String("SHIPdrive-icon") );
    }
    QIcon applicationIcon() const  {
        return themeIcon( QLatin1String("SHIPdrive-icon") );
    }

    QString updateCheckUrl() const {
        return QLatin1String("https://drive.ship.scea.com/client/");
    }

    QString helpUrl() const {
        return QString::fromLatin1("https://c5.ship.scea.com/confluence/display/HELP/SHIPdrive/").arg(MIRALL_VERSION_MAJOR).arg(MIRALL_VERSION_MINOR);
    }

#ifndef TOKEN_AUTH_ONLY
    QColor wizardHeaderBackgroundColor() const {
        return QColor("#0082c9");
    }

    QColor wizardHeaderTitleColor() const {
        return QColor("#ffffff");
    }

    QPixmap wizardHeaderLogo() const {
        return QPixmap(hidpiFileName(":/client/theme/colored/wizard_logo.png"));
    }
#endif

    QString about() const {
        QString re;
        re = tr("<p>Version %1. For more information please visit <a href='%2'>%3</a>.</p>")
                .arg(MIRALL_VERSION_STRING).arg("http://" MIRALL_STRINGIFY(APPLICATION_DOMAIN))
                .arg(MIRALL_STRINGIFY(APPLICATION_DOMAIN));

        re += trUtf8("<p><small>By SHIP</small></p>");

        re += tr("<p>Licensed under the GNU General Public License (GPL) Version 2.0.<br/>"
             "%2 and the %2 Logo are registered trademarks of %1 in the "
             "European Union, other countries, or both.</p>")
            .arg(APPLICATION_VENDOR).arg(APPLICATION_NAME);

        re += gitSHA1();
        return re;
}

};

}
#endif // SHIPDRIVE_THEME_H