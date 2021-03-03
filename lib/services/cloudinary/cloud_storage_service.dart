import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_folio/_utils/string_utils.dart';
import 'package:flutter_folio/app_keys.dart';

class CloudStorageService {
  CloudinaryPublic _cloudinary;

  void init() {
    _cloudinary = CloudinaryPublic(AppKeys.cloudinaryCloud, AppKeys.cloudinaryPreset, cache: false);
  }

  // The response would have any errors, but List<AppImage> would be created here.
  Future<List<CloudinaryResponse>> multiUpload({@required List<String> urls}) async {
    List<Future<CloudinaryFile>> f = urls.map((url) async {
      return CloudinaryFile.fromFile(url, resourceType: CloudinaryResourceType.Image);
    }).toList();
    //List<CloudinaryFile> files = await Future.wait(f);

    return await _cloudinary.multiUpload(f);
  }

  Future<CloudinaryResponse> uploadImage({@required String url}) async {
    return await _cloudinary.uploadFile(
      CloudinaryFile.fromFile(
        url,
        resourceType: CloudinaryResourceType.Image,
      ),
    );
  }

  // TODO: Transform images on upload, not on request (SB: cloudinaries "eager transforms" were not working, needs more debugging)
  static void addMaxSizeToUrlList<T>(List<T> items, String Function(T) getUrl, T Function(T, String) setUrl) {
    for (var i = items.length; i-- > 0;) {
      T item = items.removeAt(i);
      String url = addMaxSizeToUrl(getUrl(item));
      items.insert(i, setUrl(item, url));
    }
  }

  static String addMaxSizeToUrl(String imageUrl) {
    String transform = "w_1200,h_1200,c_fit";
    // If this looks line a non-cloudinary image, or it's already been transformed, leave it alone.
    if (StringUtils.isEmpty(imageUrl)) return imageUrl;
    if (imageUrl.contains("cloudinary.com") == false) return imageUrl;
    if (imageUrl.contains(transform)) return imageUrl;
    // Do transform
    String url = imageUrl.replaceAll("upload/v", "upload/$transform/v");
    return url;
  }
}

//https://res.cloudinary.com/gskinner/image/upload/w_600,h_600,c_fit/v1613885251/IMG_1697_1_vtbkrp.jpg
//https://res.cloudinary.com/gskinner/image/upload/v1613885251/IMG_1697_1_vtbkrp.jpg
