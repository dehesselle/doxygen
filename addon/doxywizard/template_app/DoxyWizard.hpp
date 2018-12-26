#ifndef DOXYWIZARD_HPP
#define DOXYWIZARD_HPP

#include <QMainWindow>

namespace Ui {
class DoxyWizard;
}

class DoxyWizard : public QMainWindow
{
    Q_OBJECT

public:
    explicit DoxyWizard(QWidget *parent = nullptr);
    ~DoxyWizard();

private:
    Ui::DoxyWizard *ui;
};

#endif // DOXYWIZARD_HPP
