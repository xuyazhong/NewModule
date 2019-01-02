import React, { Component } from 'react';
import { Platform,StyleSheet, TouchableOpacity } from 'react-native';
import { StackNavigator, addNavigationHelpers, TabNavigator, TabBarBottom } from 'react-navigation';

import root from './First';
import ESPVC from './ESPVC';
import BluetoothVC from './BTVC';
import CRCVC from "./CRCVC.js";

export const AppNavigator = StackNavigator({
    root: { screen: root },
    ESPVC: { screen: ESPVC },
    BluetoothVC: { screen: BluetoothVC },
    CRCVC: { screen: CRCVC }
});

export default class Router extends Component {
    render() {
      return <AppNavigator />
    }
}