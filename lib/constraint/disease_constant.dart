class DiseaseConstant {
  static const String bacterialLeafBlight = 'ជំងឺបាក់តេរីរលាកស្លឺក';
  static const String brownSpot = 'ជំងឺអុចត្នោត';
  static const String sheathBlight = 'ជំងឺរលាកស្រទងស្លឹក';
  static const String stemRot = 'ជំងឺរលួយដេីម';
  static const String falseSmut = 'ជំងឺធ្យូងបៃតង';
  static const String tungro = 'ជំងឺទុងគ្រោ';
  static const String riceBlast = 'ជំងឺ​រលួយក​ស្រូវ';

  static const List<String> bacterialLeafBlightImages = [
    'assets/images/bacterial_leaf_blight/1.jpeg',
    'assets/images/bacterial_leaf_blight/2.jpeg',
    'assets/images/bacterial_leaf_blight/3.jpeg',
    'assets/images/bacterial_leaf_blight/4.jpeg',
  ];

  static const List<String> brownSpotImages = [
    'assets/images/brown_spot/1.jpeg',
    'assets/images/brown_spot/2.jpeg',
    'assets/images/brown_spot/3.jpeg',
    'assets/images/brown_spot/4.jpeg',
  ];

  static const List<String> sheathBlightImages = [
    'assets/images/sheath_blight/1.jpg',
    'assets/images/sheath_blight/2.jpg',
    'assets/images/sheath_blight/3.jpg',
    'assets/images/sheath_blight/4.jpg',
  ];

  static const List<String> stemRotImages = [
    'assets/images/stem_rot/1.jpeg',
    'assets/images/stem_rot/2.jpeg',
    'assets/images/stem_rot/3.jpeg',
    'assets/images/stem_rot/4.jpeg',
  ];

  static const List<String> falseSmutImages = [
    'assets/images/false_smut/1.jpg',
    'assets/images/false_smut/2.jpg',
    'assets/images/false_smut/3.jpg',
    'assets/images/false_smut/4.jpg',
  ];

  static const List<String> riceBlastImages = [
    'assets/images/rice_blast/4.jpg',
    'assets/images/rice_blast/1.jpg',
    'assets/images/rice_blast/2.jpg',
    'assets/images/rice_blast/3.jpg',
  ];

  static const List<String> tungroImages = [
    'assets/images/tungro/1.jpg',
    'assets/images/tungro/2.jpg',
    'assets/images/tungro/3.jpg',
    'assets/images/tungro/4.jpg',
  ];

  List<String> getDiseaseImageList(String name) {
    switch (name) {
      case bacterialLeafBlight:
        return bacterialLeafBlightImages;
      case brownSpot:
        return brownSpotImages;
      case sheathBlight:
        return sheathBlightImages;
      case stemRot:
        return stemRotImages;
      case falseSmut:
        return falseSmutImages;
      case tungro:
        return tungroImages;
      case riceBlast:
        return riceBlastImages;
      default:
        return stemRotImages;
    }
  }

  String getTitleInKhmer(String title) {
    late String titleInKhmer;

    switch (title) {
      case 'bacterial_leaf_blight':
        titleInKhmer = DiseaseConstant.bacterialLeafBlight;
        break;
      case 'brown_spot':
        titleInKhmer = DiseaseConstant.brownSpot;
        break;
      case 'false_smut':
        titleInKhmer = DiseaseConstant.falseSmut;
        break;
      case 'rice_blast':
        titleInKhmer = DiseaseConstant.riceBlast;
        break;
      case 'sheath_blight':
        titleInKhmer = DiseaseConstant.sheathBlight;
        break;
      case 'stem_rot':
        titleInKhmer = DiseaseConstant.stemRot;
        break;
      case 'tungro':
        titleInKhmer = DiseaseConstant.tungro;
        break;
    }
    return titleInKhmer;
  }
}
