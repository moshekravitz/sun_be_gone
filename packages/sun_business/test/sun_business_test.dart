import 'package:flutter_test/flutter_test.dart';
import 'package:sun_business/models/point.dart';

import 'package:sun_business/sun_business.dart';

void main() {
  test('adds one to input values', () async {
    final Point departure = Point(34.98973, 31.70847);
    final Point destination = Point(35.16979, 31.79639);
    final SunBusiness api = SunBusiness();

    DateTime midday = DateTime.now().add(const Duration(hours: 12));

    var result =
        await api.whereToSit(polyline, departure, destination, midday);

    for(var segment in result.segments!) {
      print('segment: ${segment}');
    }

    //expect(calculator.addOne(2), 3);
  });
}

String polyline =
    "ckn`EqgntE??o@bCkCrHC?C?C?C?A?C?C@A@A@A@ABAB?B?B?B?B?@?B?@?B@BBD?@??@@B@@?@?o@dCUpAOj@Kn@WlCMjAm@nFC|@Ah@Cr@G@KFGJ?@?B?@?@?B?B?B?@???B@BBDy@nG?F?PAFs@fC_@x@q@hAo@t@cAz@]Ji@DC?E?C?A???C@A?C@AB?@ABABe@VIBM@I?s@@W?gAQ_@QECEAWOu@i@][IG[_@KMEMGQ?C?C?A?E?E?A?AACAAAAAAAAC?C?C?A?C?C@C@??IWi@_BIa@G]E_@C]AUCs@?m@?i@?g@@iA?GD[@A@ABC@C@E?C?C?A?A?E?C?A?CAC??AACQ@OF]PiANs@Ru@BMl@eBp@oAHQvBkD@?B?B?@?B?@???BABA@A@A?A@C?C?A?A?C?C?C?EP_@fA_BRQ??@?@?@?@?@?@A????@A?A?A???A?C?C?A???A?CzA}Bj@oAFQL]H_@Ba@@w@@?@A@A@A?A@C@C?C?A?C?C?C?C?C?AAC?AAC??AA??AACA??C?A?A?C?C?A?A?A?{Bu@CAQIe@YSMEGIKKQIQWo@]iB@???@???@A@A@A?A???A?A???A?A?A?A???CAAAAAAAAA?A?A?A?OiAGo@I_@IYO_@MUOSMOYUUMWMYIUCSA]AW?W@SDSDMDUJMFOJURQRqCzCWVMJMHKFOHSHSFWFi@Fq@DgABuA@oAAa@?q@Em@E}BWYC{@McB]_AUSUGIEKCMAK?K?K?M@KH_@P]h@sANe@Nk@Je@DSF]Da@Dg@Bg@Bw@@}A?m@@eB?K@?@?@?@?@?@?@A@A@A@A@A?A?A?A?A?A?A?A?A?A?A?A?E?C?A?A?A?A?A?AAA?AAAAAAAAAAAA?A?A?A?A??e@?W?YBu@@Y@U@]HiAFaA@OX{DVuDF}@Fy@Ba@Bc@?K?O?O?Q?W?QAQCQCSEUGUGU?????A???A?A?AHMRSRSJKLONSx@oAl@cAHKHKHGLKDEBA@?B?B?@?@?@?@?@A@A?A?A?A?AHCJCJCJAJAH?XAF?H?R@D?^Fv@Jv@LNBP@F?H?L?P?L?H?NAJARE?B?@?@@B@B?@BBB@B@@?B?@?B???@?B?@?BABABABC@C@C@C@E?E?A?C?C?A?E?E?A?AACACAACCA?CACAC?TaBBS@IB]@M?E@S@e@?G?g@?i@?_@?i@?}A?S?o@?W?a@?kC@o@?OBY@?@??A?A???A?A?C?A?A?A?A?A?A?A?_@@QD[LwAf@_D@KXcBBQTqA~@eF@GJi@VoAJs@F_@@?@?@?@A@A??@A???A?A???A?A?A?A?A?A?A??AA??Vg@FMN[FIHMHMjE}GNYJSNa@Ne@XgAPm@@?@?@?@?@?@?@?@?@A?A?A?A?A?A?A?A?A?A?C?A?AAAAAA?A?A?A?A???Go@AS?QAYCe@E_@Ie@AII]GUGQg@gAWc@m@{@kA}AEQCIAIAM?A?A?C?A???A?A?CAA?AAAA?A?A?C?A?A?A?A?A?A?A?A@A@?@?@?@?@QLGDMHSJ}@l@MHs@f@]Vi@`@_@Xc@XKHg@VYJSFSFUDWDYBa@BO?_@?g@?]Ao@Iu@Ke@Go@Oy@SkCs@aCs@e@M}C}@}HaC]KyBq@gA[_@IeAU_BWcAG{BM_CIaAGwAIuHq@_Gm@sAEk@@e@Fi@JoA\\i@Vq@f@aAx@wA`BkClCm@h@}BzAUHsA\\mARkLvAoC\\sDh@AA??AAAA??A???A?A?A?A?A?A?A?A@??A@?@?@?@gBDyADoAAuBEwDQq@?m@Fc@HeAZgAh@yAlAcBbBkFhEc@d@]\\A?A?A?A?A?A?A?A?A@?@?@?@a@Pw@`@eDzAg@Ro@TSHa@LYHMBUFSD[FMBs@HQ@Q@S@oAF]@u@@i@?[?w@?g@Ak@AYAOASAYCMAe@Kg@MMEKCMESIy@_@KEKEMGMI?C?A?A?A??AA??AA??A???C???A?A?A?OEEAECYS_@Ui@Y}@e@]OOGWIKCOCEAOCSAG?E?M?Y?Y@]Bo@HWFSFe@P]LYJI@QBC?A?A?A?????A?A?A@??A@A@?????@???@?@?@?@?@CHEHOPKLYVe@^a@ZWRk@b@KFKDKFQHYJ_@JsA^MBG@E?E?O???AAA?C?C?A?C?C?A?A?A@A@A@A@AB?@IDG@G?E?O?c@BqCTeAJSBQBWFQDKDMFq@\\OHIDMJMJIHIHIJMNSVILINIPGLGPIRKVIXK`@GVKf@k@jCOn@GXK^GPCHEHSb@INKPQVQTMPONYT{@r@YTi@b@]Va@ZMJ[RSNORW\\Ub@Wn@M`@K\\Qv@e@zCSrASlAIf@Kr@YvAOd@G?C?A?A?C@A?A@A@ABABAB?D?@?D?B?B?@?@?D@D?@@B@@DVA\\G^c@rAUn@AB]l@UXMLSPKBK?KAMIm@g@iAoCe@aBGU_@cB]eBc@cCg@cCeAaEm@cBGO_@}@_@q@OYcAyA]e@a@e@e@e@_@]o@i@}@m@gCsA{Au@eCoAe@WYOe@Wy@a@}C}AaAm@aAw@m@k@}@}@aCqCeF{FaEoEwCgDeBsBm@u@{@iAgAaBYe@Wc@GICECEEI[m@i@gAg@gAq@aBe@oA]cAGSqBsFqAsDIYgAcDcBuE[u@s@wASYQUWY_@g@a@[w@g@c@SsAe@aASiAOu@Eq@E{AAi@@gBHeF\\qAHiG^aCLwAJqDNcCB{AAmBGiAE{AOuAQ_IgAgBUyAQyB[a@GKAoCYgAEuAAeA?w@?aABa@BaCVgBRmALy@JeAJmAJc@Bi@?m@?o@Ce@Gi@G_@I]Ke@Oc@Sw@a@iBiAe@YgBgAoAy@g@]s@c@_Ae@o@WqAg@uAg@_AYcAYwBo@qCy@qA[qAa@c@Mu@Yc@OeAe@MGc@Uu@a@m@_@wBqAgDiBeCiBeCoBq@q@_@g@Q_@K[K]Ki@_@qBKu@Ee@A_@?g@@UFi@Jc@La@FOR_@JQ\\e@pBcDl@iAvBiFv@mB~B}E`AgBdAcBvIoLTa@`@y@d@sAn@wBb@wBp@sDRwAPqAJwANoBHqBDsCHwGJuGFeBD}@Dk@Fc@Ly@Ji@Vy@HWL[fCeFVe@|@cBj@iA^}@X{@^sA\\mBL}@FuA@u@A{@Cw@ImAUeBKo@U}@Y_Aa@mAwAmDuAmDe@qAe@uA[aAo@gB_AeCa@sA[wAg@qCMyACqABgADiAFeAJaALq@Pw@h@kBd@eAr@{AtAsCbAwBdBeEpAsC`@w@Zo@f@iA\\gA|CaKXiALm@f@wBnAeFh@}Bd@oBb@eBj@aCl@gCZiAx@wCXsAVcBFeADeA?{@C}@QiCI{@Ge@Iy@WoCIaAIkAE}@AeA?wABwAJkDBs@NmDBc@TmHDuBFqB@mB?qBS}JQaH?QQaIKuCGmCKuESaI_@{Nc@_SAu@EmA_@_NEwCCiC?aA?UFaCDcAFeATwB`@gC\\aB`@sBjCoLxA{GrAqGf@cCRgANkAJw@JgADuABeA@aA?g@GgCKcBUmBc@kCq@wCeAeEi@mBc@}A[mAiB{Ge@sB[}AOgAG{@EaAC{@AwB@u@HyAJqARaBXiCRuAXwBlAmIR{AZuBF_@dCiQ^iCfAsHrD{Vv@}FBSFc@j@cED]b@uDj@{DJy@LaBFqA?A@mAIiDSsFEwCEiBAeBBsCJkCPyBX}BPsAPgAl@gCZoANo@d@yAh@{Ab@gAZy@^eATo@VaAVeARy@ZcBRuAJw@Hs@DeA?[@c@@o@?_@?UCs@K{AKcAIo@O_A]uA[gAQk@K]Yo@[q@_@u@e@_Aq@kAOYa@s@[e@o@y@[c@a@e@g@s@y@}@wFsFeDuC}@{@i@m@e@s@c@s@g@eAa@eAOm@Qs@Ii@Is@Eo@Ag@Ao@?u@BqB@gA@{@@aC?s@EoBIeAM{@OeAGe@WqAMy@Oy@G]E[E]C]AY?Y?Y@a@D_@D_@DWFWHYJUNWNUNQPQRO`Ao@bDuBj@_@d@[HIHINQNSNULYHWHYDUF]F_@F]DUFSJULUPSHGLILGRIVIFAx@YlA_@rAc@TIPIZQNIRMJG\\]LOt@kAHKDIBGDOf@aBNg@X{@FWDWBOBOD[BYF}@Be@@U@W@SBY@KBKDIDIHMHGHGHCDAHAVCbBMPAD?NEDCLGFGFGFIDIDMBO?E@Q?I?KAQCUQkACWAM?M?M@KBMBIBIDGHIHIv@o@^[~@u@pAeAx@}@v@w@|@{@z@aAT[`@s@hCcGHQR[LQPSl@e@RKLGd@Ud@WZOHENELENCN??[?M??F_@?CD[F_@DW?ADUFa@?O@U@e@?q@?u@Fu@Be@?g@";
