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
  TextInput,
  Button,
  View,
} from 'react-native';
import { Buffer } from 'buffer'
import { stringToBytes, bytesToString } from 'convert-string'
import crcLib from './crcLib';
/*
 * This one works, from http://automationwiki.com/index.php?title=CRC-16-CCITT
 */
export default class CRCVC extends Component {
  constructor(props) {
    super(props);
    this.state = {
        crcText: '',
        crcResult: ''
    }
  }

  componentDidMount() {

  }

  actionCalc() {
      let text = this.state.crcText;
      var crcResult = crcLib.calc(text);
      console.log('crcResult =>', crcResult, "typeof =>", typeof(crcResult));
      this.setState({
          crcResult: crcResult
      })
  }

  render() {
    return (
      <View style={{flex: 1, alignItems: 'center'}}>
        <View style={{flexDirection: 'row'}}>
            <Text>0x</Text>
            <TextInput style={{height: 40, width: 200, borderColor: 'gray', borderWidth: 1}}
                onChangeText={(text) => {
                    this.setState({
                        crcText: text
                    })
                }}
            value={this.state.crcText}></TextInput>
        </View>
        <Button onPress={() => {
            this.actionCalc()
        }} title="CRC" />
        <Text> result => {this.state.crcResult.toUpperCase()} </Text>
      </View>
    );
  }
}
