#include "DoxyWizard.hpp"
#include "ui_DoxyWizard.h"

DoxyWizard::DoxyWizard(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::DoxyWizard)
{
    ui->setupUi(this);
}

DoxyWizard::~DoxyWizard()
{
    delete ui;
}
