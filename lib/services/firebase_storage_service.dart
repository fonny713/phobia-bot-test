import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseStorageService {
  static bool _initialized = false;
  static bool _networkAvailable = true;
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static const String _basePath = 'images/';  // Base path for all images
  static final Map<String, File> _imageCache = {};  // Memory cache for loaded images
  
  static Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      // Test connection by listing files
      await _storage.ref(_basePath).listAll();
      print('Firebase Storage initialized successfully');
      _initialized = true;
      _networkAvailable = true;
    } catch (e) {
      print('Error initializing Firebase Storage: $e');
      _networkAvailable = false;
      rethrow;
    }
  }

  static Future<void> preloadImages(List<String> imageNames) async {
    if (!_networkAvailable) return;

    for (final imageName in imageNames) {
      if (!_imageCache.containsKey(imageName)) {
        try {
          final file = await downloadImage(imageName);
          if (file != null) {
            _imageCache[imageName] = file;
          }
        } catch (e) {
          print('Error preloading image $imageName: $e');
        }
      }
    }
  }

  static Future<String> getImageUrl(String imageName) async {
    if (!_networkAvailable) {
      print('Network unavailable, cannot get image URL');
      return '';
    }

    try {
      final ref = _storage.ref().child('$_basePath$imageName');
      print('Attempting to get URL for: ${ref.fullPath}');
      
      final url = await ref.getDownloadURL();
      print('Successfully got URL for: $imageName');
      return url;
    } catch (e) {
      print('Error getting URL for $imageName: $e');
      if (e is FirebaseException) {
        print('Firebase error code: ${e.code}');
        print('Firebase error message: ${e.message}');
      }
      return '';
    }
  }

  static Future<File?> downloadImage(String imageName) async {
    if (!_networkAvailable) {
      print('Network unavailable, cannot download image');
      return null;
    }

    // Check memory cache first
    if (_imageCache.containsKey(imageName)) {
      print('Using memory cached image: $imageName');
      return _imageCache[imageName];
    }

    try {
      final ref = _storage.ref().child('$_basePath$imageName');
      print('Attempting to download: ${ref.fullPath}');
      
      // Get metadata to verify file exists
      await ref.getMetadata();
      
      // Create directories if they don't exist
      final tempDir = await getTemporaryDirectory();
      final imagesDir = Directory('${tempDir.path}/phobia_images');
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }
      
      // Create a file with a unique name
      final file = File('${imagesDir.path}/${imageName.replaceAll('/', '_')}');
      if (await file.exists()) {
        print('Using disk cached file: ${file.path}');
        _imageCache[imageName] = file;  // Add to memory cache
        return file;
      }
      
      // Ensure parent directory exists
      await file.parent.create(recursive: true);
      
      // Download to file
      await ref.writeToFile(file);
      print('Successfully downloaded: $imageName');
      
      _imageCache[imageName] = file;  // Add to memory cache
      return file;
    } catch (e) {
      print('Error downloading $imageName: $e');
      if (e is FirebaseException) {
        print('Firebase error code: ${e.code}');
        print('Firebase error message: ${e.message}');
      }
      return null;
    }
  }

  static Future<List<String>> listImages() async {
    if (!_networkAvailable) {
      print('Network unavailable, cannot list images');
      return [];
    }

    try {
      print('Listing images in: $_basePath');
      final result = await _storage.ref(_basePath).listAll();
      final images = result.items.map((ref) => ref.name).toList();
      print('Found ${images.length} images: $images');
      return images;
    } catch (e) {
      print('Error listing images: $e');
      if (e is FirebaseException) {
        print('Firebase error code: ${e.code}');
        print('Firebase error message: ${e.message}');
      }
      return [];
    }
  }

  static void clearCache() {
    _imageCache.clear();
    print('Image cache cleared');
  }

  static void resetNetworkStatus() {
    _networkAvailable = true;
    _initialized = false;
    clearCache();
  }
} 