import 'package:flutter/services.dart';

const platform = MethodChannel('handheld.method.connect');
const keyChannel = EventChannel('handheld.event.search');
const scanChannel = EventChannel('handheld.event.scan');
const gunChannel = EventChannel('handheld.event.key');
