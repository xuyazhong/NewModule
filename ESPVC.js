'use strict';
import React, { Component, } from 'react';
import {View, Text, TouchableOpacity, StyleSheet, NativeModules, Alert, Platform, NetInfo} from 'react-native';
var ESP = NativeModules.ESP;
let _this,_navigator,_state;
class ESPVC extends Component {
    constructor(props) {
        super(props);
        this.state={
            ssid:"正在获取...",
            passWord: "byzy20140730",
            wifiStatus: "",
        }
    }
    
    componentDidMount(){
        if(Platform.OS=="android"){
            this.getSSID({type:"wifi"})
        }else{
            NetInfo.addEventListener('connectionChange',_this.getSSID)
        }
    }

    getSSID(networkInfo){
        if (networkInfo.type === 'wifi') {
                ESP.getSSID((err, result) => {
                    console.log(err, result)
                    if(err){
                        Alert.alert("请您先连接您的wifi")
                    }
                    _this.setState({
                        ssid:err? '获取失败':result?result:"获取失败"
                    })
                })
            } else {
                Alert.alert("温馨提示","请您先连接您的wifi")
            }
    }
    
    componentWillUnmount(){
        NetInfo.removeEventListener('connectionChange');
    }
    render() {
        _this = this;
        return (
            <View style={styles.container}>
                <View>
                    <Text>ssid:{_this.state.ssid}</Text>
                </View>
                <Text>{this.state.passWord}</Text>
                <TouchableOpacity onPress={()=>this.connectWifi()} >
                    <Text style={{width: 200, height: 40, backgroundColor: 'red'}}>开始配网</Text>
                </TouchableOpacity>
            </View>
        );
    }
    
   connectWifi(){
       //检测网络连接信息
       NetInfo.getConnectionInfo().done((connectionInfo) => {
           if (connectionInfo.type === 'wifi') {
               console.log('continue')
           } else {
               Alert.alert("请先连接wifi")
               return
           }
       });
       //连接wifi
        if(ESP){
            ESP.Connect(_this.state.passWord, (err, result) => {
                console.log("result =>", err, result)
            })
        }
    }
};

export default ESPVC

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