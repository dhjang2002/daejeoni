// ignore_for_file: unnecessary_const, non_constant_identifier_names, avoid_print

class InfoMember {
  String mberSn;
  String mberId;
  String mberPassword;
  String mberLevel;
  String mberType;
  String mberActvstLevel;
  String mberNm;
  String mberTelno;
  String mberMblTelno;
  String mberCoTelno;
  String mberEml;
  String mberAdres;
  String mberDetailAdres;
  String mberZip;
  String mberBrdt;
  String mberSexdstn;
  String mberAtdrc;
  String regDt;
  String mdfcnDt;
  String useYn;
  String delYn;
  String prvcClctAgreYn;
  String prvcPvsnAgreYn;
  String mberLoginDt;
  String mberLoginIp;
  String mberLoginAtptCnt;
  String mberLoginAtptDt;
  String regId;
  String mdfcnId;
  String appNtcnTkn;
  String appOpersysm;
  String appDeviceId;
  String kakaoSocialToken;
  String naverSocialToken;
  String authorCd;
  String groupId;
  String groupSt;
  String mberJoinCours;
  String mberLevelArr;
  String mberFindType;
  String mberFindResult;
  String authMberType;
  String authMberEml;
  String authMberId;
  String emailAuthKey;
  String authorCdArr;
  String strDt;
  String endDt;
  String preStrDt;
  String preEndDt;
  String custom_UNIQ_KEY;
  String log_TYPE;
  String is_JOIN_MBR;
  String is_CTI_MBR;
  String log_UPD_MSG;
  String creat_DT;
  String use_AT;
  String atch_FILE_ID;
  String file_SN;
  String file_STRE_COURS;
  String orignl_FILE_NM;
  String file_EXTSN;
  String file_CN;
  String stre_FILE_NM;


  String appNtcnTkn2;   // 등록된 Push token
  InfoMember({
    this.mberSn="",
    this.mberId="",
    this.mberPassword="",
    this.mberLevel="",
    this.mberType="",
    this.mberActvstLevel="",
    this.mberNm="",
    this.mberTelno="",
    this.mberMblTelno="",
    this.mberCoTelno="",
    this.mberEml="",
    this.mberAdres="",
    this.mberDetailAdres="",
    this.mberZip="",
    this.mberBrdt="",
    this.mberSexdstn="",
    this.mberAtdrc="",
    this.regDt="",
    this.mdfcnDt="",
    this.useYn="",
    this.delYn="",
    this.prvcClctAgreYn="",
    this.prvcPvsnAgreYn="",
    this.mberLoginDt="",
    this.mberLoginIp="",
    this.mberLoginAtptCnt="",
    this.mberLoginAtptDt="",
    this.regId="",
    this.mdfcnId="",
    this.appNtcnTkn="",
    this.appOpersysm="",
    this.appDeviceId="",
    this.kakaoSocialToken="",
    this.naverSocialToken="",
    this.authorCd="",
    this.groupId="",
    this.groupSt="",
    this.mberJoinCours="",
    this.mberLevelArr="",
    this.mberFindType="",
    this.mberFindResult="",
    this.authMberType="",
    this.authMberEml="",
    this.authMberId="",
    this.emailAuthKey="",
    this.authorCdArr="",
    this.strDt="",
    this.endDt="",
    this.preStrDt="",
    this.preEndDt="",
    this.custom_UNIQ_KEY="",
    this.log_TYPE="",
    this.is_JOIN_MBR="",
    this.is_CTI_MBR="",
    this.log_UPD_MSG="",
    this.creat_DT="",
    this.use_AT="",
    this.atch_FILE_ID="",
    this.file_SN="",
    this.file_STRE_COURS="",
    this.orignl_FILE_NM="",
    this.file_EXTSN="",
    this.file_CN="",
    this.stre_FILE_NM="",

    this.appNtcnTkn2="",
  });

  Map<String, dynamic> toUpdateParam() {
    Map<String, dynamic> map = {
    "mberSn" : mberSn,                  // 키
    "mberNm" : mberNm,                  // 이름
    "mberBrdt": mberBrdt,               // 생년월일
    "mberMblTelno": mberMblTelno,       // 휴대폰
    "mberCoTelno": mberCoTelno,         // 자택전화
    "mberEml": mberEml,                 // 이메일
    "mberAtdrc": mberAtdrc,             // 시구
    "mberZip": mberZip,                 // 우편번호
    "mberAdres": mberAdres,             // 기본주소
    "mberDetailAdres": mberDetailAdres  // 상세주소
    };
    return map;
  }

  factory InfoMember.fromJson(Map<String, dynamic> person)
  {
    return InfoMember(
      mberSn: (person['mberSn']!=null) ? person['mberSn'].toString().trim():"",
      mberPassword: (person['mberPassword']!=null) ? person['mberPassword'].toString().trim():"",
      mberId: (person['mberId']!=null) ? person['mberId'].toString().trim():"",
      mberLevel: (person['mberLevel']!=null) ? person['mberLevel'].toString().trim():"",
      mberType: (person['mberType']!=null) ? person['mberType'].toString().trim():"",
      mberActvstLevel: (person['mberActvstLevel']!=null) ? person['mberActvstLevel'].toString().trim():"",
      mberNm: (person['mberNm']!=null) ? person['mberNm'].toString().trim():"",

      mberTelno: (person['mberTelno']!=null) ? person['mberTelno'].toString().trim():"",
      mberMblTelno: (person['mberMblTelno']!=null) ? person['mberMblTelno'].toString().trim():"",
      mberCoTelno: (person['mberCoTelno']!=null) ? person['mberCoTelno'].toString().trim():"",
      mberEml: (person['mberEml']!=null) ? person['mberEml'].toString().trim():"",
      mberAdres: (person['mberAdres']!=null) ? person['mberAdres'].toString().trim():"",
      mberDetailAdres: (person['mberDetailAdres']!=null) ? person['mberDetailAdres'].toString().trim():"",
      mberZip: (person['mberZip']!=null) ? person['mberZip'].toString().trim():"",
      mberBrdt: (person['mberBrdt']!=null) ? person['mberBrdt'].toString().trim():"",
      mberSexdstn: (person['mberSexdstn']!=null) ? person['mberSexdstn'].toString().trim():"",
      mberAtdrc: (person['mberAtdrc']!=null) ? person['mberAtdrc'].toString().trim():"",
      regDt: (person['regDt']!=null) ? person['regDt'].toString().trim():"",
      mdfcnDt: (person['mdfcnDt']!=null) ? person['mdfcnDt'].toString().trim():"",
      useYn: (person['useYn']!=null) ? person['useYn'].toString().trim():"",
      delYn: (person['delYn']!=null) ? person['delYn'].toString().trim():"",
      prvcClctAgreYn: (person['prvcClctAgreYn']!=null) ? person['prvcClctAgreYn'].toString().trim():"",
      prvcPvsnAgreYn: (person['prvcPvsnAgreYn']!=null) ? person['prvcPvsnAgreYn'].toString().trim():"",
      mberLoginDt: (person['mberLoginDt']!=null) ? person['mberLoginIp'].toString().trim():"",
      mberLoginIp: (person['mberLoginIp']!=null) ? person['mberLoginIp'].toString().trim():"",
      mberLoginAtptCnt: (person['mberLoginAtptCnt']!=null) ? person['mberLoginAtptCnt'].toString().trim():"",
      mberLoginAtptDt: (person['mberLoginAtptDt']!=null) ? person['mberLoginAtptDt'].toString().trim():"",
      regId: (person['regId']!=null) ? person['regId'].toString().trim():"",
      mdfcnId: (person['mdfcnId']!=null) ? person['mdfcnId'].toString().trim():"",
      appNtcnTkn: (person['appNtcnTkn']!=null) ? person['appNtcnTkn'].toString().trim():"",
      appOpersysm: (person['appOpersysm']!=null) ? person['appOpersysm'].toString().trim():"",
      appDeviceId: (person['appDeviceId']!=null) ? person['appDeviceId'].toString().trim():"",
      kakaoSocialToken: (person['kakaoSocialToken']!=null) ? person['kakaoSocialToken'].toString().trim():"",
      naverSocialToken: (person['naverSocialToken']!=null) ? person['naverSocialToken'].toString().trim():"",
      authorCd: (person['authorCd']!=null) ? person['authorCd'].toString().trim():"",
      groupId: (person['groupId']!=null) ? person['groupId'].toString().trim():"",
      groupSt: (person['groupSt']!=null) ? person['groupSt'].toString().trim():"",
      mberJoinCours: (person['mberJoinCours']!=null) ? person['mberJoinCours'].toString().trim():"",
      mberLevelArr: (person['mberLevelArr']!=null) ? person['mberLevelArr'].toString().trim():"",
      mberFindType: (person['mberFindType']!=null) ? person['mberFindType'].toString().trim():"",
      mberFindResult: (person['mberFindResult']!=null) ? person['mberFindResult'].toString().trim():"",
      authMberType: (person['authMberType']!=null) ? person['authMberType'].toString().trim():"",
      authMberEml: (person['authMberEml']!=null) ? person['authMberEml'].toString().trim():"",
      authMberId: (person['authMberId']!=null) ? person['authMberId'].toString().trim():"",
      emailAuthKey: (person['emailAuthKey']!=null) ? person['emailAuthKey'].toString().trim():"",
      authorCdArr: (person['authorCdArr']!=null) ? person['authorCdArr'].toString().trim():"",
      strDt: (person['strDt']!=null) ? person['strDt'].toString().trim():"",
      endDt: (person['endDt']!=null) ? person['endDt'].toString().trim():"",
      preStrDt: (person['preStrDt']!=null) ? person['preStrDt'].toString().trim():"",
      preEndDt: (person['preEndDt']!=null) ? person['preEndDt'].toString().trim():"",
      custom_UNIQ_KEY: (person['custom_UNIQ_KEY']!=null) ? person['custom_UNIQ_KEY'].toString().trim():"",
      log_TYPE: (person['log_TYPE']!=null) ? person['log_TYPE'].toString().trim():"",
      is_JOIN_MBR: (person['is_JOIN_MBR']!=null) ? person['is_JOIN_MBR'].toString().trim():"",
      is_CTI_MBR: (person['is_CTI_MBR']!=null) ? person['is_CTI_MBR'].toString().trim():"",
      log_UPD_MSG: (person['log_UPD_MSG']!=null) ? person['log_UPD_MSG'].toString().trim():"",
      creat_DT: (person['creat_DT']!=null) ? person['creat_DT'].toString().trim():"",
      use_AT: (person['use_AT']!=null) ? person['use_AT'].toString().trim():"",
      atch_FILE_ID: (person['atch_FILE_ID']!=null) ? person['atch_FILE_ID'].toString().trim():"",
      file_SN: (person['file_SN']!=null) ? person['file_SN'].toString().trim():"",
      file_STRE_COURS: (person['file_STRE_COURS']!=null) ? person['file_STRE_COURS'].toString().trim():"",
      orignl_FILE_NM: (person['orignl_FILE_NM']!=null) ? person['orignl_FILE_NM'].toString().trim():"",
      file_EXTSN: (person['file_EXTSN']!=null) ? person['file_EXTSN'].toString().trim():"",
      file_CN: (person['file_CN']!=null) ? person['file_CN'].toString().trim():"",
      stre_FILE_NM: (person['stre_FILE_NM']!=null) ? person['stre_FILE_NM'].toString().trim():"",
      appNtcnTkn2:(person['appNtcnTkn2']!=null) ? person['appNtcnTkn2'].toString().trim():"",
    );
  }

  @override
  String toString(){
    return 'SignInfo {'
        'mberSn:$mberSn, '
        'mberId:$mberId, '
        'mberNm:$mberNm, '
        'mberLevel:$mberLevel, '
        'mberActvstLevel:$mberActvstLevel, '
        'mberType:$mberType, '
        'mberEml:$mberEml, '
        'mberTelno:$mberTelno, '
        '}';
  }
}
