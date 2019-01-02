'use strict';
import React, { Component, } from 'react';
import {View, Text, TouchableOpacity, StyleSheet, NativeModules, Alert, Platform, NetInfo} from 'react-native';
var Bluetooth = NativeModules.Bluetooth;
let _this,_navigator,_state;
class BluetoothVC extends Component {
    constructor(props) {
        super(props);
        this.state={
            btStatus:"正在获取...",
            passWord: "byzy20140730",
            wifiStatus: "",
        }
    }
    
    componentDidMount(){
        
    }
    
    componentWillUnmount(){

    }

    render() {
        _this = this;
        return (
            <View style={styles.container}>
                <View>
                    <Text>蓝牙状态:{_this.state.btStatus}</Text>
                </View>
                <TouchableOpacity onPress={()=>this.searchBluetooth()} >
                    <Text style={{width: 200, height: 40, backgroundColor: 'red'}}>搜索蓝牙</Text>
                </TouchableOpacity>
            </View>
        );
    }
    
    searchBluetooth() {

    }
   
};

export default BluetoothVC

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