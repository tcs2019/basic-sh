#!/bin/sh
#
# build a gateway image using alpine:latest image
#
cp -R ../../SimulatedIoTDevices/devices/bin .src
cp -R ../../SimulatedIoTDevices/devices/contracts .src
cp -R ../../SimulatedIoTDevices/devices/node_modules .src
cp -R ../../SimulatedIoTDevices/devices/public .src
cp -R ../../SimulatedIoTDevices/devices/routes .src
cp -R ../../SimulatedIoTDevices/devices/views .src
cp ../../SimulatedIoTDevices/devices/app.js .src
cp ../../SimulatedIoTDevices/devices/compile.js .src
cp ../../SimulatedIoTDevices/devices/deploy.js .src
cp ../../SimulatedIoTDevices/devices/gateway.js .src
cp ../../SimulatedIoTDevices/devices/package.json .src
docker build -t alpine_ethereum_gateway:latest .