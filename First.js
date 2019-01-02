/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  Platform,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
  NativeModules,
  NetInfo
} from 'react-native';

type Props = {};
export default class App extends Component<Props> {
  constructor(props) {
    super(props);
    this.state = {
        netStatus: '网络状态',
        appLoad: 'none'
    }
  
  }

  componentDidMount() {
    this.setState({
      appLoad: 'ok'
    })
    NetInfo.addEventListener('connectionChange', (networkType) => {
      let net = '当前网络: [' + networkType.type + ']';
      this.setState({
        netStatus: net
      })
    })
  }

  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          {this.state.appLoad}
        </Text>
        <TouchableOpacity onPress={() => {
          // var esp = NativeModules.ESP;
          // esp.Connect();
          this.props.navigation.navigate('ESPVC');
        }} >
        <Text style={{height: 50, width: 150, backgroundColor: 'red'}}>esp</Text>
        </TouchableOpacity>
        <TouchableOpacity onPress={() => {
          this.props.navigation.navigate('BluetoothVC');
        }} >
        <Text style={{height: 50, width: 150, backgroundColor: 'red'}}>蓝牙</Text>
        </TouchableOpacity>
        <Text style={styles.instructions}>
         当前网络: {this.state.netStatus}
        </Text>
        <TouchableOpacity onPress={() => {
          this.props.navigation.navigate('CRCVC');
        }} >
        <Text style={{height: 50, width: 150, backgroundColor: 'red'}}>CRC</Text>
        </TouchableOpacity>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
