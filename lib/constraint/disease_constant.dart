class DiseaseConstant {
  static const String bacterialLeafBlight = 'ជំងឺបាក់តេរីរលាកស្លឺក';
  static const String brownSpot = 'ជំងឺអុចត្នោត';
  static const String sheathBlight = 'ជំងឺរលាកស្រទងស្លឹក';
  static const String stemRot = 'ជំងឺរលួយដេីម';
  static const String falseSmut = 'ជំងឺធ្យូងបៃតង';
  static const String tungro = 'ជំងឺទុងគ្រោ';
  static const String riceBlast = 'ជំងឺ​រលួយក​ស្រូវ';

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
