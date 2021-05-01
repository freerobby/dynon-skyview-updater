# Dynon Skyview Chart Updater

Currently supports MacOS

1. Visit the [Dynon SkyView ChartData page](https://www.seattleavionics.com/ChartData/Default.aspx?TargetDevice=Dynon).
1. Login with your Seattle Avionics Credentials.
1. Visit the [Manual Download](https://www.seattleavionics.com/ChartData/Installation.aspx).
1. Note the password in the table.
1. Hover your mouse over one of the download links. It will start with "http://data.seattleavionics.com/OEM/Generic/", followed by a four-digit directory name. Note this four-digit prefix.
1. Run ./update-charts.sh. Enter the password and prefix when prompted. The updater will download all data and generate a USB drive image.
1. Download [Etcher](https://www.balena.io/etcher/) and use it to write the image to your USB drive.

