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

#ifndef TEMPIMAGEWRITER_H
#define TEMPIMAGEWRITER_H

#include <QObject>
#include <QImageWriter>

class TempPath: public QObject {
    Q_OBJECT

public:
    TempPath();
    ~TempPath() = default;

    Q_PROPERTY (QString path READ getPath WRITE setPath NOTIFY pathChanged)

    QString getPath();
    void setPath(const QString& p);

signals:
    void pathChanged(QString p);

protected:
    QString path;
};

#endif
