/*
 * Copyright (C) 2020  Benoît Rouits
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * ubuntu-calculator-app is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <QDebug>
#include <QStandardPaths>

#include "temppath.h"

TempPath::TempPath()
    : path(QStandardPaths::writableLocation(QStandardPaths::TempLocation))
{
}

QString TempPath::getPath() {
    return this->path;
}

void TempPath::setPath(const QString& p) {
    if (this->path == p)
        return;

    this->path = p;

    emit pathChanged(p);
}
