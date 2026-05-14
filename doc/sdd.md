SoftwareDesignDocument—Singgah

Project:Singgah—MobileItineraryPlannerDocumentVersion:1.0Status:DraftLast
Updated:2026DocumentOwner:Product&EngineeringTeamAudience:Engineering,
Product,Design,QA,DevOps

TableofContents

> 1\. <u>ProjectOverview</u>
>
> 2\. <u>ProblemStatement</u>
>
> 3\. <u>BusinessGoals</u>
>
> 4\. <u>TargetUsers&Personas</u>
>
> 5\. <u>FunctionalRequirements</u>
>
> 6\. <u>Non-FunctionalRequirements</u>
>
> 7\. <u>SystemArchitecture</u>
>
> 8\. <u>TechStackRecommendation</u>
>
> 9\. <u>FrontendArchitecture</u>
>
> 10\. <u>BackendArchitecture</u>
>
> 11\. <u>DatabaseSchema&ERD</u>
>
> 12\. <u>APIDesi</u>g<u>n</u>
>
> 13\. <u>AuthenticationFlow</u>
>
> 14\. <u>MapsIntegrationFlow</u>
>
> 15\. <u>ItineraryEngineLo</u>g<u>ic</u>
>
> 16\. <u>RecommendationS</u>y<u>stemOverview</u>
>
> 17\. <u>StateManagement</u>
>
> 18\. <u>ScalabilityStrate</u>g<u>y</u>
>
> 19\. <u>SecurityConsiderations</u>
>
> 20\. <u>UI/UXFlow</u>
>
> 21\. <u>ScreenList&Navigation</u>
>
> 22\. <u>DevelopmentRoadmap</u>
>
> 23\. <u>Deplo</u>y<u>mentArchitecture</u>
>
> 24\. <u>DevO</u>p<u>sRecommendation</u>
>
> 25\. <u>TestingStrateg</u>y
>
> 26\. <u>FolderStructure</u>
>
> 27\. <u>CodingConventions</u>
>
> 28\. <u>A</u>pp<u>endix</u>

1.ProjectOverview

1.1ProductSummary

SinggahadalahaplikasimobileberbasisFlutteryangmembantupenggunamerencanakan
perjalanankeluarkotasecaraterstruktur.Aplikasiinimenggabungkantripplanning,
transportationestimation,hoteldiscovery,destinationmanagement,dantimelinescheduling
dalamsatupengalamanyangterpadu.

Nama"Singgah"diambildarikatabahasaIndonesiayangberarti"berhentisejenak"atau
"mampir",mereﬂeksikanﬁlosoﬁprodukyangfokuspadaperjalananyangdinikmatipertitik
singgah,bukansekadarberpindahdariAkeB.

1.2ProductVision

MenjadiplatformitineraryplanningnomorsatudiIndonesiauntukperjalanandomestikantar
kota,dengankekuatanutamapadakemudahanpenyusunanjadwalhariandanrekomendasi
cerdasberbasisAI.

1.3ScopeofThisDocument

Dokumeninimencakupdesainteknisend-to-endaplikasiSinggahdarisisimobileclient,
backendservices,database,integrasipihakketiga,hinggastrategideployment.Dokumentidak
mencakupbusinessplan,ﬁnancialmodeling,ataumarketingstrategyyangberadadidokumen
terpisah.

1.4OutofScope(v1.0)

BeberapaﬁtursecaraeksplisittidaktermasukdalamscopeMVPdanrilisawal,yaitubooking
transportasilangsungdalamaplikasi,paymentgatewayinternal,socialfeaturessepertisharing
tripkefeedpublik,supportuntukperjalananinternasionaldenganmultiplecurrencydanvisa
requirements,sertaintegrasidenganride-hailingsepertiGojekatauGrab.

2.ProblemStatement

2.1TheProblem

PenggunayanginginmelakukanperjalanankeluarkotadiIndonesiasaatinimenghadapi
fragmentasitools.MerekaharusmenggunakanGoogleMapsuntukrute,TravelokaatauAgoda
untukhotel,InstagramatauTikTokuntukinspirasidestinasi,danspreadsheetmanualatau
Notesuntukmenyusuntimeline.Tidakadasatuaplikasiyangmenyatukanseluruhalur
perencanaandenganfokuspadakebutuhantravelerdomestikIndonesia.

Akibatnya,perencanaanperjalananmenjadimelelahkan,jadwalseringbentrok,estimasiwaktu
antarlokasitidakakurat,danpenggunaseringmelewatkantempatmenarikyangsearahdengan
rutemereka.

2.2ExistingSolutions&Gaps

Solusiyangadasaatinimemilikiketerbatasanmasing-masing.TripItfokuspadapenerbangan
internasionaldanbookingconﬁrmation,kurangrelevanuntukperjalananroadtripdomestik.
GoogleMapsunggulpadanavigasitetapitidakpunyakonsepitinerarymulti-day.Travelokakuat
dibookingtetapilemahdiplanning.WanderlogpopulertetapiUX-nyatidakdioptimalkanuntuk
konteksIndonesia,terutamaurusanestimasiperjalananmotordanpencarianhiddengemlokal.

2.3WhyNow

AdopsismartphonediIndonesiasudahmerata,trenroadtripdanstaycationpasca-pandemi
terustumbuh,kemampuanAIuntukrekomendasipersonalsemakinmatangdanterjangkau,
sertaAPImapslokalsepertiGoogleMapsIndonesiasudahmemilikicoverageyangmemadai
sampaikekotatier2.

3.BusinessGoals

3.1PrimaryGoals

TujuanutamabisnisadalahmembangunbasispenggunaaktifyangloyaldipasarIndonesia,
memvalidasiproduct-marketﬁtdisegmentravelerdomestikusia18hingga35tahun,dan
membangunfondasidataperjalananyangkelakmenjadicompetitivemoatuntukﬁturAI
recommendation.

3.2SuccessMetrics

Padalevelproduk,metrikutamayangdipantauadalahjumlahtripyangberhasildisusun
lengkapdenganminimaltigadestinasi,retentionratepenggunapadaD7danD30,durasirata-ratasesiperencanaan,sertatingkatkonversidaripembuatantripmenjadipenyelesaian
itinerary.

Padalevelbisnis,metrikyangdilacakmeliputimonthlyactiveusers,growthrate,costper
acquisition,dankelakrevenueperusersetelahmodelmonetisasidiaktifkan.TargetMVPadalah
mencapaisepuluhribuMAUdalamenambulanpertamasetelahpeluncuranpublik.

3.3MonetizationDirection(Post-MVP)

WalaupunMVPfokuspadapertumbuhanorganiktanpamonetisasilangsung,arahmonetisasi
yangdipertimbangkanmeliputiaﬃliatecommissiondarihotelbookingpartner,premiumtier
denganﬁturAIrecommendationlanjutandanoﬄinemode,sponsoredplacementuntuk
destinasiataucoﬀeshopyanginginmenjangkautraveler,sertadatainsightuntukdinas
pariwisatadaerah.

4.TargetUsers&Personas

4.1PrimaryPersona—Rara,theWeekendTraveler

Raraberusia26tahun,bekerjasebagaicontentmarketingdiJakarta,danmemilikikebiasaan
roadtripkeBandung,Yogyakarta,atauMalangsetiapsatuhinggaduabulansekalibersamadua
atautigatemandekatnya.Iamengendaraimobilpribadiatausewa,danbiasanyamenyusun
itinerarylewatcatatanWhatsAppdanInstagrambookmark.Kebutuhanutamanyaadalahsatu
tempatuntukmerangkumsemuatempatmenarikyangiasimpandariInstagram,dengan
estimasiwaktuantartempatyangrealistissehinggaiatidakterlalumemforsirjadwal.

4.2SecondaryPersona—Bayu,theSoloMotorRider

Bayuberusia23tahun,mahasiswatingkatakhir,danseringmelakukantouringmotorsolodari
BandungkeGarut,Pangandaran,atauDieng.Anggarannyaterbatas,sehinggakebutuhan
utamanyaadalahestimasibiayaBBMdanjaraktempuhyangakuratuntukkendaraanmotor,
rekomendasihotelatauhomestayyangramahbudget,sertahiddengemyangsearahjalur
perjalanannya.

4.3TertiaryPersona—KeluargaIwan,theFamilyTraveler

Iwanberusia38tahun,bekerjasebagaiPNS,danmelakukanperjalanankeluargadenganistri
danduaanaksetiaptigasampaiempatbulansekali.Kebutuhannyaadalahhotelfamilyfriendly,
destinasiyangramahanak,jadwalyangtidakterlalupadat,danestimasidurasiyang
memperhitungkankecepatankeluargadengananakkecilyanglebihlambat.

4.4UserNeedsSummary

Dariketigapersona,kebutuhanintiyangkonsistenmunculadalahpenyusunanitineraryyang
cepatdanvisual,estimasiperjalananyangakuratperjeniskendaraan,kemampuanmenyimpan
danmengelompokkantempatmenarik,ﬂeksibilitasuntukmengaturulangurutankunjungan,
sertakeyakinanbahwajadwalyangdisusunrealistisdantidakakanbentrokdilapangan.

5.FunctionalRequirements

5.1UserManagement

Sistemharusmenyediakankemampuanregistrasipenggunabarumenggunakanemaildan
passwordsertaopsisigninwithGoogledanAppleID.Penggunaharusdapatmelakukanlogin,
logout,danresetpassword.Setiappenggunamemilikiproﬁlyangmenyimpannama,foto,kota
asaldefault,danpreferensiperjalanansepertitipekendaraanfavoritdankategoridestinasiyang
disukai.

5.2TripManagement

Penggunaharusdapatmembuattripbarudenganmenentukankotaasal,kotatujuan,tanggal

mulai,tanggalselesai,danjeniskendaraanutama.Tripyangsudahdibuatdapatdiedit,dihapus,
dandiduplikasi.Penggunadapatmelihatdaftarsemuatripyangpernahdibuatdenganﬁlter
berdasarkanstatussepertiupcoming,ongoing,completed,danarchived.

5.3TransportationEstimation

Untuksetiappasanganasal-tujuan,sistemharusmenampilkanestimasijarakdalamkilometer,
estimasiwaktutempuhdalamjamdanmenit,estimasibiayaberdasarkankonsumsiBBMrata-ratakendaraan,sertaminimalsaturekomendasirutealternatif.Estimasiharusberbedaantara
motordanmobil,denganasumsikecepatanrata-ratayangberbeda.

5.4HotelDiscovery

Sistemharusmenampilkandaftarhoteldikotatujuandenganinformasinama,foto,rating,
kisaranhargapermalam,jarakdaripusatkotaataudaridestinasiyangsudahditambahkan
pengguna,dantagkategori.Penggunadapatmemﬁlterhotelberdasarkanbudget,predikat
familyfriendly,aesthetic,kedekatandenganwisata,dankedekatandengancoﬀeshop.Pengguna
dapatmenyimpanhotelpilihankedalamtripsebagaireferensi,walauMVPbelummenyediakan
bookinglangsung.

5.5DestinationManagement

Penggunadapatmenambahkandestinasiketripmerekamelaluipencarianpeta,pencarian
nama,ataudarirekomendasisistem.Setiapdestinasimemilikiatributnama,alamat,koordinat
latitudedanlongitude,kategori,jambuka,jamtutup,danestimasidurasikunjungandefault.
Penggunadapatmenambahkancatatanpersonalpadasetiapdestinasi.

KategoridestinasiyangdidukungpadaMVPadalahwisata,coﬀeshop,hiburan,kuliner,dan
hiddengem.Setiapkategorimemilikiikondanwarnayangberbedauntukmemudahkanvisual
scanningditimeline.

5.6ItineraryTimeline

Penggunadapatmenyusunurutankunjungandalamtimelinehariandenganoperasidragand
drop.Untuksetiapdestinasidalamtimeline,penggunamenentukanjamdatangdanjampergi.
Sistemsecaraotomatismenghitungdurasiperjalananantardestinasiberdasarkankoordinat
danjeniskendaraan,mengidentiﬁkasikonﬂikjadwalsepertitumpangtindihwaktuatau
kunjungandiluarjambuka,sertamenampilkantotaldurasidanestimasiketerlambatanjika
ada.

5.7SmartRecommendation(FutureFeature)

PadafasepascaMVP,sistemakanmerekomendasikandestinasiyangsearahdenganrute
perjalanan,memberiperingatanjikajadwalterlalupadat,mengoptimalkanurutankunjungan
untukmeminimalkantotalwaktuperjalanan,danmemberikansaranpersonalberdasarkan
riwayattrippengguna.

5.8Notiﬁcation

Sistemharusmengirimnotiﬁkasiremindersatuharisebelumtripdimulai,notiﬁkasipengingat
dipagihariuntuktripyangsedangberjalan,dannotiﬁkasifollow-upsetelahtripselesaiuntuk
memintareviewataufeedback.

6.Non-FunctionalRequirements

6.1Performance

Aplikasiharusdapatmembukalayarutamadalamwaktukurangdariduadetikdikoneksi4G.
Operasidraganddroppadatimelineharusterasainstandenganresponsdibawahseratus
milidetik.Pencariandestinasiharusmengembalikanhasildalamsatudetik.Estimasirutedari
GoogleMapsAPIditargetkankembalidalamduadetikdikondisinormal.

6.2Scalability

Arsitekturharusmendukungpertumbuhandarisepuluhribupenggunapadatahunpertama
hinggajutaanpenggunadalamtigatahuntanparewritebesar.Backendharusstatelessagar
dapatdi-scalehorizontal.Databaseharusmendukungpartitioningdanreadreplica.

6.3Reliability

Targetuptimeadalah99,5persenuntukMVPdanmeningkatke99,9persenpadarilisstabil.
Aplikasiharusdapatberfungsidalammodeoﬄineterbatasuntukmelihatitineraryyangsudah
disusun,walaupunﬁtursepertirekomendasidanpencarianpetamemerlukankoneksi.

6.4Usability

Aplikasiharusdapatdigunakanolehpenggunabarutanpaonboardingtutorialyangpanjang.
Onboardingmaksimalterdiridaritigalayarpenjelasansingkat.Aksiutamauntukmembuattrip
baruharusdapatdiaksesdalammaksimalduatapdarihomescreen.

6.5Localization

MVPmendukungbahasaIndonesiasebagaibahasautamadanbahasaInggrissebagaibahasa
sekunder.Semuaformattanggal,matauang,dansatuanjarakmengikutikonvensiIndonesia
secaradefault.

6.6Compatibility

AplikasimendukungAndroidversi8.0(Oreo)keatasdaniOSversi13keatas.Resolusilayar
yangdidukungmencakupsmallphonedenganlebar360dphinggalargephonedenganlebar
480dp,denganadaptasiuntuktabletsebagaipengembanganlanjutan.

6.7Security&Privacy

SemuakomunikasiantaraclientdanserverharusmelaluiHTTPSdenganTLS1.3.Token
autentikasiharusdisimpandisecurestoragenativemasing-masingplatform.Datalokasi
penggunahanyadiaksesketikadiperlukandenganpermintaanizinyangeksplisit.Aplikasi
mematuhiUUPerlindunganDataPribadiIndonesia.

7.SystemArchitecture

7.1High-LevelArchitecture

Singgahmengadopsiarsitekturclient-serverdenganpolamodularmonolithpadafaseMVP,
yangdirancanguntukdapatdipecahmenjadimicroservicesketikaskaladankompleksitas
membutuhkannya.Pendekataninimemberikecepataniterasipadafaseawaltanpa
mengorbankankemampuanuntukberevolusikearsitekturyanglebihterdistribusidikemudian
hari.

Arsitektursistemsecarakeseluruhanterdiridarilimalapisanutama.Lapisanclientberupa
aplikasiFlutteryangberjalandiAndroiddaniOS.LapisanAPIgatewayberfungsisebagaientry
pointtunggalyangmenanganiautentikasi,ratelimiting,danroutingkeservice.Lapisan
applicationserviceberisiseluruhbusinesslogicyangdibagiperdomain.Lapisandataterdiri
dariPostgreSQLsebagaisumberkebenaranutama,Redissebagaicache,danobjectstorage
untukmedia.LapisanintegrasieksternalmencakupGoogleMapsAPI,layananemail,push
notiﬁcation,dankelakAIserviceuntukrecommendation.

7.2ArchitectureDiagram

> +---------------------------------------------------------------+ \|
> Mobile Client \| \| Flutter App (Android / iOS) \| \| - Presentation
> Layer (Widgets, Screens) \| \| - Application Layer (BLoC / Riverpod
> Notifiers) \| \| - Domain Layer (Entities, Use Cases) \| \| - Data
> Layer (Repositories, API Clients, Local Cache) \|
> +---------------------------------+-----------------------------+
>
> \|
>
> \| HTTPS / REST + WebSocket v
>
> +---------------------------------------------------------------+ \|
> API Gateway \| \| - JWT Validation \| \| - Rate Limiting \| \| -
> Request Logging \|
> +---------------------------------+-----------------------------+
>
> \|
>
> +---------------------+---------------------+ \| \| \| v v v
>
> +----------------------+ +-----------------+ +---------------------+
> \| Auth Service \| \| Trip Service \| \| Recommendation Svc \| \|
> (NestJS Module) \| \| (NestJS Module) \| \| (NestJS Module) \|
> +----------------------+ +-----------------+ +---------------------+
>
> \| \| \| +---------------------+---------------------+ \| v
>
> +---------------------------------------------------------------+ \|
> Data Layer \| \| PostgreSQL (Primary) \| Redis (Cache) \| S3 (Object
> Store) \|
> +---------------------------------------------------------------+
>
> \| v
>
> +---------------------------------------------------------------+ \|
> External Integrations \| \| Google Maps API \| Firebase Cloud
> Messaging \| Email SMTP \| \| AI Service (post-MVP) \| Hotel Data
> Provider \|
> +---------------------------------------------------------------+

7.3ArchitecturalStyleJustiﬁcation

Pemilihanmodularmonolithdenganstrukturperdomaindipilihkarenatimengineeringpada
faseawalakankecil,kompleksitasinter-servicecommunicationpadamicroservicesakan
menambahoverheadoperasionalyangtidakproporsionaldenganukurantim,danstruktur
modularmemungkinkanekstraksiservicekedalammicroservicesterpisahketikadibutuhkan
tanparewritetotal.

8.TechStackRecommendation

8.1Frontend

FlutterdipilihsebagaiframeworkutamakarenamemberikansatucodebaseuntukAndroiddan
iOSdenganperformanativeyangbaik,ekosistempackageyangmatang,dankemampuan
renderingUIyangkonsistenlintasplatform.VersiFlutteryangdirekomendasikanadalahversi
stableterbarusaatdevelopmentdimulai,denganDartsebagaibahasapemrogramanutama.

Pustakapendukungyangdirekomendasikanmeliputiﬂutter_blocatauriverpoduntukstate
management,diountukHTTPclient,get_itdaninjectableuntukdependencyinjection,hiveatau
isaruntuklocalstorage,google_maps_ﬂutterataumapbox_gluntukpeta,dan
ﬂutter_local_notiﬁcationsuntuknotiﬁkasilokal.

8.2Backend

NestJSdipilihsebagaiframeworkbackendkarenastrukturnyayangopinionateddanmodular
sangatcocokuntukarsitekturperdomain,dukunganTypeScriptyangkuatmemberikeamanan
tipesejakawal,ekosistemdecoratordandependencyinjectionmemudahkantesting,serta
komunitasyangbesarmemastikanketersediaandokumentasidanintegrasidenganlayanan
pihakketiga.

AlternatifyangdipertimbangkanadalahLaraveldenganPHP,yangunggulpadakecepatan
developmentdankekayaanﬁturbuilt-insepertiqueuedanscheduler,namunNestJSdipilih
karenakeseragamanbahasaTypeScriptdengankemungkinantoolinglaindimasadepandan
performaruntimeNode.jsyangumumnyalebihringanuntukbebanAPI.

PustakapendukungutamadibackendmencakupPrismaatauTypeORMsebagaiORM,
Passport.jsuntukautentikasi,class-validatoruntukvalidasiDTO,BullMQuntukantrian
backgroundjob,danPinountukstructuredlogging.

8.3Database

PostgreSQLdipilihsebagaiprimarydatabasekarenadukungantipedatageograﬁsmelalui
ekstensiPostGISyangsangatrelevanuntukaplikasipetadanjarak,dukunganJSONBuntuk
ﬂeksibilitasdatasemi-terstruktursepertipreferensipengguna,kekuatanqueryrelationaluntuk
relasikompleksantaratrip,destinasi,dantimeline,sertareputasikeandalanyangterujipada
skalabesar.

Redisdigunakansebagaicacheuntukhasilqueryyangseringdiaksessepertidaftardestinasi
populer,sessiondata,danratelimitingcounter.

8.4Cloud&Infrastructure

PadafaseMVPdirekomendasikanmenggunakanlayananmanagedyangmengurangibeban
operasional.SupabasememberikanPostgreSQLterkelola,autentikasisiappakai,danstorage
dalamsatupaketyangsangatcepatuntukvalidasiawal.AWSdipilihuntukfasepertumbuhan
denganEKSuntukcontainerorchestration,RDSuntukPostgreSQL,ElastiCacheuntukRedis,
danS3untukobjectstorage.FirebasedigunakansecaraselektifuntukCloudMessagingdan
CrashlyticskarenakeduanyamemilikiintegrasiyangsangatbaikdenganFlutter.

8.5MapsIntegration

GoogleMapsPlatformdirekomendasikansebagaipilihanutamakarenacoveragedataIndonesia
yanglebihlengkapdibandingkanMapboxterutamauntukPOIlokal,kualitasestimasiwaktu
tempuhyangsudahmemperhitungkankondisilalulintas,danintegrasiyangmulusdengan
google_maps_ﬂutter.APIyangakandigunakanmeliputiMapsSDKuntukrenderingpeta,
DirectionsAPIuntukrute,DistanceMatrixAPIuntukestimasijarakdanwaktu,PlacesAPI
untukpencariandestinasi,danGeocodingAPIuntukkonversialamatkekoordinat.

Mapboxtetapdipertahankansebagaiopsialternatifyangdievaluasipadafaseoptimasibiaya,
terutamajikavolumerequesttumbuhsigniﬁkandanbiayaGoogleMapsmenjadibebanyang

besar.

8.6OtherServices

LayananpendukunglainnyamencakupSentryuntukerrortrackingdanperformance
monitoringdisisimobilemaupunbackend,MixpanelatauAmplitudeuntukproductanalytics,
SendGridatauResenduntukpengirimanemailtransaksional,danGitHubActionsuntuk
continuousintegrationdandelivery.

9.FrontendArchitecture

9.1ArchitecturalPattern

AplikasimobilemengadopsiCleanArchitecturedengantigalapisanutamayaitupresentation
layer,domainlayer,dandatalayer.Pemilihaninidipertahankankarenamemberikanpemisahan
tanggungjawabyangtegas,memudahkanunittestingpadabusinesslogictanpadependensi
padaframework,danmempersiapkancodebaseuntukpertumbuhantimengineeringtanpa
kekacauanstruktur.

9.2LayerResponsibilities

PresentationlayerberisiwidgetdanscreenyangfokuspadarenderingUIdanmenerimaevent
daripengguna.Layerinitidakbolehberisibusinesslogicapapunselainlogicyangmurniterkait
tampilansepertiformatstringatautogglevisibility.

DomainlayerberisientitybisnissepertiTrip,Destination,danTimelineItem,besertausecase
yangmengekspresikanoperasibisnissepertiCreateTripUseCase,
AddDestinationToTripUseCase,danReorderTimelineUseCase.Layerinisepenuhnya
independendariframeworkdanlibraryeksternalsehinggadapatdiujisecaramurni.

Datalayerberisiimplementasirepositoryyangmenjembatanidomaindengansumberdata
konkretsepertiRESTAPI,localdatabase,ataucache.Datalayerjugaberisidatasourcedan
modelyangmemetakanresponseAPIkeentitydomain.

9.3StateManagementChoice

StatemanagementdirekomendasikanmenggunakanRiverpodversi2karenakemampuan
compile-timesafety,sintaksyanglebihsederhanadibandingkanBLoCmurni,dukungan
asynchronousstateyangeleganmelaluiAsyncValue,dankomunitasyangsangataktif.Untuk
timyanglebihfamiliardenganpolaevent-stateeksplisit,BLoCtetapmenjadialternatifyang
valid.

Pembagianstatemengikutiaturanbahwastateyanghanyadigunakanolehsatuwidgettetap
menggunakanStatefulWidgetlokal,stateyangdigunakanolehsubtreewidgetmenggunakan
providerlokal,danstateyangbersifatglobalsepertiusersessiondanpreferensimenggunakan
providerglobalyangdi-scopeditingkataplikasi.

Navigasimenggunakango_routeryangmendukungdeeplinking,type-saferouting,dan
integrasidenganstaterestoration.Strukturrutemengikutipolahierarkiyangmenggambarkan
informasiarsitekturaplikasi.

9.5Theming&DesignSystem

AplikasimenggunakanMaterial3sebagaidasardengancustomdesigntokens.Warnautama,
tipograﬁ,spacing,danradiusdideﬁnisikandalamsatuﬁlethemeterpusatsehinggaperubahan
visualdapatdilakukansecarakonsisten.KomponenreusablesepertiSinggahButton,
SinggahCard,danSinggahInputdibangundiataswidgetMaterialuntukmenjagakonsistensi
visualsekaligusmemudahkankustomisasi.

10.BackendArchitecture

10.1ModularStructure

Backenddisusunsebagaimodularmonolithdenganpembagianperdomainbisnis.Modul
utamameliputiAuthModuleyangmenanganiregistrasi,login,danmanajementoken,User
Moduleuntukproﬁldanpreferensipengguna,TripModuleuntukoperasiCRUDtrip,
DestinationModuleuntukmanajemendestinasidanpencarian,HotelModuleuntukdaftardan
ﬁlterhotel,ItineraryModuleyangmenjadiintibusinesslogicuntukpenyusunantimeline,
RecommendationModuleyangawalnyaberisirule-basedlogicdankelakmenjadibridgekeAI
service,NotiﬁcationModuleuntukpengirimanemaildanpushnotiﬁcation,danIntegration
ModuleyangmembungkusklienGoogleMapsdanlayananeksternallainnya.

10.2LayeredPatternwithinEachModule

Setiapmodulmengikutipolalayeredyangkonsistendengancontrollersebagaientrypoint
HTTPyanghanyamenanganiserializationdanvalidasiinput,serviceyangberisibusinesslogic
murni,repositoryyangmembungkusakseskedatabase,danDTOsebagaikontrakdataantar
layer.

10.3Cross-CuttingConcerns

Hal-hallintasmodulsepertilogging,exceptionhandling,validasi,danaudittrail
diimplementasikanmenggunakaninterceptor,guard,danpipekhasNestJS.Pendekatanini
menjagamodultetapfokuspadadomainmasing-masingtanpaduplikasikode.

10.4BackgroundJobs

Pekerjaanasinkronsepertipengirimannotiﬁkasireminder,pemrosesanrekomendasiberat,dan
sinkronisasidatahoteldaripenyediaeksternalditanganiolehBullMQdenganRedissebagai
broker.Setiapjobmemilikistrategiretrydandeadletterqueueuntukkegagalanpermanen.

11.DatabaseSchema&ERD

11.1ConceptualERD

Hubunganantarentitasutamadapatdigambarkansebagaiberikut.SeorangUsermemiliki
banyakTrip.SetiapTripmemilikisatukotaasaldansatukotatujuanyangmerujukkeentitas
City.SetiapTripmemilikibanyakDestinationyangdipilihpengguna,banyakTimelineItem
yangmenyusunurutankunjungan,danopsionalsatuataulebihHotelSelection.Setiap
DestinationmerujukkeentitasPlaceyangberisidatamastertempat.SetiapTimelineItem
merujukkesatuDestinationdanmenyimpanjamdatangsertajampergi.

> +--------+ +--------+ +-----------+ \| User \|1-----\*\| Trip
> \|\*-----1\| City \| +--------+ +--------+ +-----------+
>
> \|
>
> +-------------+-------------+--------------+ \| \| \| \| 1 1 1 1 \* \*
> \* \*
>
> +--------------+ +-------------+ +-----------+ +-----------+ \|
> Destination \| \|TimelineItem \| \| HotelSel. \| \|TripVehicle\|
> +--------------+ +-------------+ +-----------+ +-----------+
>
> \| 1 1
>
> +----------+
>
> \| 1 1

+-------------+

> \| 1 1

+---------+

> \| Place \| \| Destination \| \| Hotel \| +----------+ +-------------+
> +---------+

11.2DetailedSchema

TabelusersberisikolomidsebagaiUUIDprimarykey,emailyangunik,password_hash,
full_name,avatar_url,default_origin_city_idsebagaiforeignkeykecities,preferencessebagai
JSONB,created_at,danupdated_at.Indeksunikdiberikanpadakolomemailuntuk
mempercepatlookuplogin.

Tabelcitiesmenyimpandatamasterkotadengankolomid,name,province,countryyangdefault
Indonesia,latitude,longitude,danis_supportedsebagaiﬂagapakahkotadilayanipenuh.Indeks
geograﬁsmenggunakanPostGISdipasangpadakolomkoordinatuntukqueryproximity.

Tabeltripsberisiid,user_id,title,origin_city_id,destination_city_id,start_date,end_date,
primary_vehicleyangberisienummotorataumobil,statusdengannilaidraft,planned,ongoing,
completed,atauarchived,total_distance_km,estimated_total_cost,created_at,danupdated_at.
Indekskompositpadauser_iddanstatusmempercepatlistingtrippengguna.

Tabelplacesmenyimpandatamastertempatdengankolomid,name,address,city_id,latitude,
longitude,categoryyangberisienumwisata,coﬀeshop,hiburan,kuliner,atauhidden_gem,
opening_hourssebagaiJSONByangmenyimpanjambukaperhari,
average_visit_duration_minutes,rating,photo_url,dansourceyangmenandaiapakahdata
berasaldariGooglePlaces,kurasiinternal,atauusergenerated.

Tabeldestinationsadalahtabelasosiasiantaratripdanplacedengankolomid,trip_id,place_id,
custom_notedaripengguna,custom_visit_duration_minutesyangdapatmenimpadefault,
added_at,danposition_ordersebagaiposisiawaldidaftardestinasisebelumdisusunke
timeline.

Tabeltimeline_itemsmenyimpanjadwalaktualdengankolomid,trip_id,destination_id,
day_number,arrival_time,departure_time,travel_time_from_previous_minutes,has_conﬂict
sebagaiﬂagboolean,conﬂict_reason,danorder_in_day.Indekskompositpadatrip_id,
day_number,danorder_in_daymempercepatpengambilantimelinehariansecaraterurut.

Tabelhotelsberisidatamasterhoteldengankolomid,name,address,city_id,latitude,longitude,
rating,price_per_night_idr,photo_urlssebagaiJSONBarray,tagssebagaiJSONBarrayberisi
family_friendly,aesthetic,near_tourist_spot,near_coﬀeshop,danbudget_friendly,dansource.

Tabelhotel_selectionsmenyimpanhotelyangdipilihpenggunauntuktriptertentudengan
kolomid,trip_id,hotel_id,check_in_date,check_out_date,dannote.

11.3IndexingStrategy

Selainindeksunikdankomposityangsudahdisebut,indekstambahandiberikanpada
places.categoryuntukﬁltercepatperkategori,hotels.price_per_night_idruntukrangequery
padaﬁlterharga,danindeksGINpadakolomJSONBtagspadatabelhotelsuntukpencarian
berbasistag.

11.4Migration&Seeding

MigrasidatabasedikelolamenggunakanPrismaMigrateyangmenyediakanversioningdan
rollback.SeeddataawalmencakupdaftarkotatiersatudanduadiIndonesia,datamaster
tempatpopulerdisetiapkota,dandatahotelsampelhasilscrapingataupartnershipdengan
penyediadata.

12.APIDesign

12.1Conventions

APImenggunakanRESTdenganformatJSONdanmengikutikonvensipenamaanresource
dalambentukpluralnoun.VersiAPIditandaidenganpreﬁx/v1/padapath.Responsesukses
mengembalikanstatuscode2xxdenganbodyberisidatadanopsionalmetadata.Responsegagal
mengembalikanstatuscodeyangsesuaidanbodyberisiﬁelderrordengancodedanmessage
yangkonsisten.

SemuarequestyangmembutuhkanautentikasiharusmenyertakanheaderAuthorization
denganformatBearertoken.Paginationmenggunakanqueryparameterpagedanlimitdengan
responsemenyertakanﬁeldmetaberisitotal,page,dantotal_pages.

12.2CoreEndpoints

EndpointautentikasimencakupPOST/v1/auth/registeruntukpendaftaran,POST/v1/auth/login
untukmasuk,POST/v1/auth/refreshuntukmemperpanjangaccesstoken,POST/v1/auth/logout
untukkeluar,danPOST/v1/auth/forgot-passworduntukinisiasireset.

EndpointusermeliputiGET/v1/users/meuntukproﬁlsaatini,PATCH/v1/users/meuntuk
pembaruanproﬁl,danPATCH/v1/users/me/preferencesuntukpembaruanpreferensi.

EndpointtripmencakupPOST/v1/tripsuntukmembuattrip,GET/v1/tripsuntukdaftartrip
penggunadenganﬁlterstatus,GET/v1/trips/{id}untukdetailtrip,PATCH/v1/trips/{id}untuk
pembaruan,DELETE/v1/trips/{id}untukpenghapusan,danPOST/v1/trips/{id}/duplicateuntuk
menggandakantrip.

EndpointdestinasipadaleveltripmencakupPOST/v1/trips/{tripId}/destinationsuntuk
menambahkandestinasi,GET/v1/trips/{tripId}/destinationsuntukdaftar,PATCH
/v1/trips/{tripId}/destinations/{id}untukpembaruan,danDELETE
/v1/trips/{tripId}/destinations/{id}untukpenghapusan.

EndpointpencariandestinasitersediamelaluiGET/v1/places/searchdenganparameterquery,
city_id,dancategory.

EndpointtimelinemencakupGET/v1/trips/{tripId}/timelineuntukpengambilantimeline
harian,PUT/v1/trips/{tripId}/timelineuntuksimpantimelinesecarabatch,danPOST
/v1/trips/{tripId}/timeline/validateuntukpengecekankonﬂik.

EndpointhotelmencakupGET/v1/hotelsdenganparametercity_iddanﬁlter,GET
/v1/hotels/{id}untukdetail,POST/v1/trips/{tripId}/hotel-selectionsuntukmenyimpanpilihan
hotelketrip,danDELETE/v1/trips/{tripId}/hotel-selections/{id}untukmembatalkan.

EndpointestimasiperjalanantersediamelaluiPOST/v1/routes/estimateyangmenerimatitik
asal,titiktujuan,danjeniskendaraan,lalumengembalikanjarak,waktutempuh,biayaestimasi,
danpolylinerute.

12.3ExampleRequestandResponse

Sebagaicontoh,requestuntukmembuattripbarumemilikibodyberisititle,origin_city_id,
destination_city_id,start_date,end_date,danprimary_vehicle.Responsesuksesdenganstatus
201mengembalikanobjektriplengkapdenganid,statusdefaultdraft,dantimestamp
pembuatan.

> json
>
> POST /v1/trips
>
> Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
>
> {
>
> "title": "Weekend di Bandung", "origin_city_id": "city_jakarta",
> "destination_city_id": "city_bandung", "start_date": "2026-06-12",
> "end_date": "2026-06-14", "primary_vehicle": "mobil"
>
> }
>
> Response 201 Created {
>
> "data": {
>
> "id": "trip_01HXYZ...", "title": "Weekend di Bandung", "status":
> "draft",
>
> "origin_city": { "id": "city_jakarta", "name": "Jakarta" },
> "destination_city": { "id": "city_bandung", "name": "Bandung" },
> "start_date": "2026-06-12",
>
> "end_date": "2026-06-14", "primary_vehicle": "mobil", "created_at":
> "2026-05-09T10:23:11Z"
>
> } }

12.4ErrorResponseFormat

Semuaerrormengikutiformatkonsistendenganﬁelderrorberisicodedalamsnake_case,
messageyangdapatdibacapengguna,danopsionaldetailsyangberisiinformasiﬁeld-levelerror
untukvalidasi.

> json
>
> {
>
> "error": {
>
> "code": "validation_failed",
>
> "message": "Beberapa field tidak valid", "details": {
>
> "end_date": "Tanggal selesai harus setelah tanggal mulai" }
>
> } }

12.5Real-TimeChannel

Untukﬁturkolaborasimulti-userpadatripyangsamayangdirencanakanpascaMVP,akan
ditambahkanWebSocketchannelpadapath/v1/realtime/trips/{id}yangmendorongevent
sepertidestination_added,timeline_reordered,danmember_joinedkesemuaclientyang
terhubungpadatriptersebut.

13.AuthenticationFlow

13.1Strategy

SinggahmenggunakankombinasiaccesstokendanrefreshtokenberbasisJWT.Accesstoken
memilikimasaberlakupendeklimabelasmenitdandikirimpadasetiaprequestAPI.Refresh
tokenmemilikimasaberlakutigapuluhharidandisimpandisecurestoragenative,digunakan
hanyauntukmemperpanjangaccesstokentanpamemaksapenggunaloginulang.

13.2RegistrationFlow

Penggunamengisiformregistrasidiaplikasi,aplikasimengirimPOSTke/v1/auth/register
denganemail,password,dannamalengkap,backendmemvalidasidanmenyimpanuserbaru
denganpasswordyangdi-hashmenggunakanbcryptdengancostfactor12,backendmengirim
emailveriﬁkasiopsional,danbackendmengembalikanaccesstokensertarefreshtoken
sehinggapenggunalangsungmasuktanpaperluloginterpisah.

13.3LoginFlow

Penggunamengisiemaildanpassword,aplikasimengirimPOSTke/v1/auth/login,backend
memveriﬁkasikredensial,backendmengembalikanaccesstokendanrefreshtoken,aplikasi
menyimpanaccesstokendimemorystatedanrefreshtokendisecurestorage,dansetiaprequest
berikutnyamenyertakanaccesstoken.

13.4TokenRefreshFlow

Ketikaaccesstokenexpiredditandaidenganresponse401dariAPI,interceptordisisiaplikasi
secaraotomatismemanggilPOST/v1/auth/refreshdenganrefreshtoken,jikasuksesinterceptor
menyimpanaccesstokenbarudanretryrequestasli,jikagagalaplikasimemaksapengguna
loginulang.

13.5SocialLoginFlow

PenggunamemilihsigninwithGoogleatauApple,aplikasimembukaOAuthdialognativedan
menerimaid_tokendariprovider,aplikasimengirimPOSTke/v1/auth/socialdenganprovider
danid_token,backendmemveriﬁkasitokenkeproviderdanmencariuserdenganemailyang
sesuaiataumembuatuserbarujikabelumada,backendmengembalikanaccesstokendan
refreshtokensepertipadaloginbiasa.

13.6LogoutFlow

AplikasimemanggilPOST/v1/auth/logoutdenganrefreshtokenagarbackenddapatmelakukan
invalidasipadawhitelistrefreshtokenaktif,aplikasimenghapusaccesstokendarimemorydan
refreshtokendarisecurestorage,danaplikasimengarahkanpenggunakelayarlogin.

14.MapsIntegrationFlow

14.1Overview

IntegrasipetamenjaditulangpunggungbeberapaﬁturutamaSinggah.PemilihanGoogleMaps
Platformsebagaipenyediautamamenuntutperencanaanyanghati-hatipadacaching,batching
request,danstrategifallbackagarbiayatetapterkendali.

14.2PlaceSearchFlow

Ketikapenggunamengetikquerydipencariandestinasi,aplikasiterlebihdahulumengecek
cachelokaluntukhasilpencarianyangsamadalamtigapuluhmenitterakhir,jikatidakada
aplikasimengirimrequestkebackendpadaGET/v1/places/search,backendkemudian
mengecekcacheRedisdandatabaseinternaluntukplaceyangrelevan,jikahasilinternalkurang
dariambangminimalbackendmemanggilGooglePlacesAutocompleteAPI,hasildariGoogle
diperkayadengandatainternalsepertikategoridanratingdaritrippenggunalain,danresponse
dikembalikankeaplikasisambildisimpankecache.

PendekataninimemastikanbahwapencarianpopulertidakselalumemanggilGoogleAPIyang
berbayar,sekaligustetapmemberikancoveragedataluasuntukqueryyangjarang.

14.3RouteEstimationFlow

Penggunamemilihpasanganasal-tujuandanjeniskendaraan,aplikasimengirimPOSTke
/v1/routes/estimate,backendmemeriksacacheuntukruteyangsamadalamtigapuluhmenit
terakhir,jikatidakadabackendmemanggilGoogleDirectionsAPIdenganparametermode
drivingkarenabaikmotordanmobilsama-samamenggunakanjalanraya,untukmotorbackend
menerapkankoreksiwaktutempuhberdasarkankoeﬁsienkecepatanrata-ratayangberbeda,
backendmenghitungbiayaestimasiBBMberdasarkankonsumsirata-ratayangdikonﬁgurasi
perjeniskendaraandanhargaBBMterkiniyangdi-updateterjadwal,danresponse
dikembalikandenganpolylineyangdapatlangsungdigambardipeta.

14.4Inter-DestinationTravelTime

Untuktimelinehariandenganbeberapadestinasiberurutan,aplikasimemanggilendpoint
/v1/routes/matrixyangmenerimadaftarkoordinatberurutandanjeniskendaraan,backend
memanggilGoogleDistanceMatrixAPIuntukmenghitungsemuapasanganberurutandalam
saturequestagareﬁsien,danresponseberisiwaktutempuhantardestinasiyangdigunakanoleh
itineraryengineuntukvalidasijadwal.

14.5MapRenderingonMobile

Padalayartimelinehariandanlayarpetatrip,aplikasimenggunakangoogle_maps_ﬂutteruntuk
menampilkanpetadenganmarkerperdestinasidanpolylineantardestinasi.Markerdiwarnai
sesuaikategoridestinasi.Tappadamarkermenampilkanbottomsheetdengandetailsingkat.
Polylinediambildarihasilestimasiruteyangdicachedistatelokaltrip.

14.6CostControl

UntukmenjagabiayaGoogleMapsAPI,beberapastrategiditerapkan.Hasilpencariandan
estimasirutedicachediRedisdenganTTLyangsesuai.RequestDistanceMatrixdibatasipada
panjangmaksimalsepuluhwaypointperrequest.Aplikasimenggunakanstaticmapuntuk
previewkecilagartidakmemuatpetainteraktifyangbiayanyalebihtinggi.Quotaharian
dimonitormelaluidashboarddanakanmen-triggeralertjikamendekatiambangbatas.

15.ItineraryEngineLogic

15.1EngineResponsibilities

Itineraryengineadalahkomponenyangbertanggungjawabatasvalidasidankalkulasijadwal
harian.Engineinimemastikanbahwatimelineyangdisusunpenggunarealistisdan
memberikanfeedbackotomatisketikaadamasalah.

15.2CoreComputations

Enginemelakukanbeberapaperhitunganutama.Untuksetiappasangandestinasiberurutan
dalamsatuhari,enginemenghitungtravel_time_minutesberdasarkanhasilDistanceMatrixAPI
danjeniskendaraantrip.Untuksetiaptimeline_item,enginememvalidasibahwaarrival_time
beradadalamjambukadestinasipadahariyangsesuai.Untuksetiappasangantimeline_item
berurutan,enginememvalidasibahwaarrival_timeberikutnyatidaklebihawaldari
departure_timesebelumnyaditambahtravel_time_minutes.

15.3ConﬂictDetection

Enginemengidentiﬁkasitigajeniskonﬂikutama.Konﬂikout_of_hoursmunculketika
kunjunganberadadiluarjambukadestinasi.Konﬂikinsuﬃcient_travel_timemunculketika
jedaantaraduadestinasilebihkecildariestimasiwaktutempuh.Konﬂikoverlapmunculketika
duatimeline_itemmemilikirentangwaktuyangtumpangtindih.

Setiapkonﬂikdirepresentasikansebagaiobjekdengankolomtype,severityyangdapatberupa
warningatauerror,aﬀected_item_ids,dansuggested_ﬁxyangopsional.

15.4Optimization(Future)

PadafasepascaMVP,engineakanmenyediakanmodeoptimasiyangmenerimadaftardestinasi
tanpaurutandanmenghasilkanurutanoptimalyangmeminimalkantotaltraveltime.Algoritma

yangdipertimbangkanadalahheuristiknearestneighboruntukawalyangcepat,dankelak
digantidengansolverTSPyanglebihakuratuntukkasusdenganjumlahdestinasisedikit.

15.5AlgorithmSketch

Pseudo-codeuntukvalidasitimelinehariandapatdigambarkansebagaiberikut.

> function validateDailyTimeline(items, vehicle): conflicts = \[\]
>
> sortedItems = items.sortedBy(arrival_time)
>
> for i in 0 to sortedItems.length - 1: item = sortedItems\[i\]
>
> place = getPlace(item.destination_id)
>
> if not isWithinOpeningHours(item.arrival_time, item.departure_time,
> place):
>
> conflicts.add(Conflict("out_of_hours", "warning", \[item.id\]))
>
> if i \> 0:
>
> prev = sortedItems\[i - 1\]
>
> travelTime = estimateTravelTime(prev.place_coords, place.coords,
> vehicle)
>
> availableTime = item.arrival_time - prev.departure_time
>
> if availableTime \< travelTime:
> conflicts.add(Conflict("insufficient_travel_time", "error",
>
> \[prev.id, item.id\]))
>
> return conflicts

15.6EnginePlacement

EnginediimplementasikandibackendsebagaibagiandariItineraryModule.Aplikasimobile
dapatmelakukanvalidasioptimistiksecaralokaluntukfeedbackinstansaatpengguna
melakukandraganddrop,namunvalidasiotoritatiftetapdilakukandibackendketikatimeline
disimpanagarkonsistensiterjaga.

16.RecommendationSystemOverview

16.1PhasedApproach

RekomendasipadaSinggahdirancangdenganpendekatanbertahap.Fasepertamabersifatrule-basedyangdapatsegeradiluncurkantanpakompleksitasmachinelearning.Fasekedua
memperkenalkancontent-basedﬁlteringyangmemanfaatkankategoridanpreferensi.Fase

ketigamengintegrasikanmodelembeddingdancollaborativeﬁlteringuntukpersonalisasiyang
lebihdalam.

16.2Phase1—Rule-Based

PadaMVP,rekomendasimengandalkanaturansederhana.Destinasipopulerdikotatujuan
diurutkanberdasarkanratingdanjumlahtripyangmenyertakandestinasitersebut.Hotel
direkomendasikanberdasarkantagyangdipilihpengguna.Destinasiyangsearahdenganrute
dihitungberdasarkanjaraktegaklurusdarititikdestinasikegarislurusruteasal-tujuan.

16.3Phase2—Content-Based

Padafaseini,sistemmembangunproﬁlpreferensipenggunaberdasarkankategoridestinasi
yangseringditambahkanketripmereka.Skorkemiripanantaraproﬁlpenggunadancalon
destinasidihitungsehinggarekomendasiterasalebihpersonal.

16.4Phase3—AI-Powered

PadafasepascaMVPyanglebihjauh,sistemakanmenggunakanembeddingpre-traineduntuk
merepresentasikandestinasidanpenggunadalamruangvektoryangsama.Pencarian
kemiripandilakukanmenggunakanvectordatabasesepertipgvectoratauPinecone.Selainitu,
integrasidenganmodelbahasabesarmemungkinkanrekomendasinaratifseperti"Jikakamu
sukacoﬀeshoptenangdiBandung,kamumungkinakansukakawasanDagoAtasdengantiga
rekomendasiberikut".

16.5RecommendationAPISurface

Rekomendasidiaksesmelaluibeberapaendpointdedicated.GET
/v1/recommendations/destinationsmenerimaparametertrip_iddanmengembalikandaftar
destinasiyangrelevandengankotatujuandanrute.GET/v1/recommendations/hotels
menerimatrip_iddanﬁlter,lalumengembalikanhotelyangcocok.GET
/v1/recommendations/along-routemenerimatrip_iddanopsionalkategori,lalumengembalikan
tempatyangsearahperjalanan.

16.6FeedbackLoop

Untukmemperbaikikualitasrekomendasi,sistemmencatattindakanpenggunaterhadap
rekomendasisepertipenambahanketrip,dismiss,danklikuntukdetail.Datainimenjadisinyal
pembelajaranuntukfasecontent-baseddanAI-powered.

17.StateManagement

17.1MobileStateCategories

Statepadaaplikasimobiledipisahmenjadiempatkategoriyaituephemeralstatesepertianimasi
dantoggleUI,appstatesepertisessionpenggunadantema,servercachestatesepertidaftartrip
dandetaildestinasi,danformstatesepertiinputyangsedangdiisipengguna.

17.2RecommendedTools

EphemeralstatemenggunakanStatefulWidgetbawaanFlutter.Appstate,servercachestate,
danformstatedikeloladenganRiverpod.Untukservercachestatesecarakhusus,AsyncNotiﬁer
dengancachingdaninvalidasiotomatissangatcocokdanmenggantikankebutuhanlibrary
terpisahsepertiReactQuery.

17.3CacheInvalidationStrategy

Strategiinvalidasicachemengikutiaturansederhana.Setelahoperasimutasisepertimembuat
ataumengubahtrip,provideryangrelevandi-invalidatesehinggapengambilandataberikutnya
memuatdatasegardariserver.Optimisticupdatedigunakanpadaoperasiyangdampaknyajelas
dancepatsepertireordertimeline,denganrollbackotomatisjikaservermenolakperubahan.

17.4BackendState

Backendbersifatstatelessdalamartitidakmenyimpansessiondimemoryproses.Semuastate
persistenberadadiPostgreSQLdanRedis.Pendekataninimemudahkanhorizontalscalingdan
zero-downtimedeployment.

18.ScalabilityStrategy

18.1VerticalScalingFirst

Padafaseawaldengantraﬁkrendah,scalingdilakukansecaravertikaldenganmenambah
resourcepadainstancebackendtunggal.Pendekataninimemberikanoperasionalyang
sederhanaselamatraﬃcbelummencapaipuluhanriburequestpermenit.

18.2HorizontalScalingatInﬂectionPoint

Ketikatraﬃcmendekatibataskemampuansatuinstance,backenddi-scalehorizontaldi
belakangloadbalancer.Karenabackendstateless,penambahaninstancedapatdilakukantanpa
perubahankode.AutoscalingdiaturberdasarkanCPUutilizationdanrequestpersecond.

18.3DatabaseScaling

Databasescalingdimulaidenganoptimasiquery,penambahanindeksyangsesuai,dancaching
agresifdiRedis.Tahapberikutnyamenambahkanreadreplicauntukmemisahkanbebanbaca
daribebantulis.Tahapselanjutnyamelakukanpartitioningpadatabelyangtumbuhbesar
sepertitimeline_itemsberdasarkantrip_idatauperiodewaktu.

18.4CachingLayers

Cachingditerapkanpadabeberapalapisan.Padaclient,responseAPIyangrelatifstabilseperti
daftarkotadankategoridicachedilocalstoragedenganTTLpanjang.PadaCDN,assetstatisdan
responGETyangdapatdicachepublikdi-cachediedge.Padaserver,Redismenyimpanhasil
queryyangmahalsepertipencariandanestimasirute.

18.5PathtoMicroservices

Ketikatimengineeringtumbuhdanmodultertentumulaimemilikikebutuhanscalingyang
berbedasecarasigniﬁkan,ekstraksimodulmenjadimicroserviceindependenmenjadiopsi.
KandidatekstraksipertamaadalahRecommendationServicekarenabebankomputasinyaakan
tumbuhpalingcepatketikaﬁturAIdiaktifkan.KandidatkeduaadalahIntegrationServiceuntuk
mengisolasidependensipadaGoogleMapsAPI.

19.SecurityConsiderations

19.1TransportSecurity

Seluruhkomunikasiantaraclient,backend,danlayananeksternalharusmelaluiHTTPSdengan
TLSminimalversi1.2dandirekomendasikan1.3.SertiﬁkatdikelolaotomatismelaluiLet's
EncryptatauACMAWSdenganrotasiterjadwal.

19.2Authentication&Authorization

TokenJWTditandatanganidenganalgoritmaHS256atauRS256menggunakansecretyang
disimpandisecretmanager.Otorisasipadalevelresourcedilakukandenganmemastikanbahwa
useryangmelakukanrequestadalahpemiliktripataumemilikiperanyangsesuai.Padamasa
depanketikaﬁturkolaborasidiaktifkan,otorisasidiperluasdenganmodelroleyaituowner,
editor,danviewer.

19.3InputValidation

Semuainputdariclientdivalidasidibackendmenggunakanclass-validatordenganDTO.
Validasimencakuptipedata,format,panjang,dandomainbisnissepertitanggalselesaiharus
setelahtanggalmulai.Backendtidakpernahmempercayaivalidasiyangdilakukandiclient.

19.4SensitiveDataHandling

Passworddisimpansebagaibcrypthashdengancostfactor12.Tokenresetpassworddantoken
veriﬁkasiemailmemilikimasaberlakupendekdansingleuse.Datapribadisepertiemaildan
namadianonimkanpadalogproduksi.Datalokasipenggunahanyadisimpanjikamemang
diperlukandandapatdihapussesuaipermintaanpengguna.

19.5APISecurity

RatelimitingditerapkanperIPdanperuserpadaendpointsensitifsepertilogindanregister
untukmencegahbruteforce.CORSdikonﬁgurasiketathanyauntukoriginyangdikenal.Header
keamanansepertiStrict-Transport-Security,X-Content-Type-Options,danContent-Security-Policydikirimpadasetiapresponse.

19.6MobileAppSecurity

Padasisimobile,beberapapraktikditerapkan.TokendisimpandiKeychainpadaiOSdan

KeystorepadaAndroidmelaluiﬂutter_secure_storage.Aplikasimelakukancertiﬁcatepinning
padakoneksikeAPIutamauntukmencegahmaninthemiddleattack.Buildreleasedi-obfuscatemenggunakanﬂutterbuilddenganﬂagobfuscatedansplitdebuginfo.Aplikasitidak
menyimpaninformasisensitifdisharedpreferencesbiasa.

19.7Compliance

AplikasimematuhiUUPerlindunganDataPribadiIndonesiadenganmenyediakanhalaman
privacypolicyyangjelas,mekanismepersetujuaneksplisituntukpengumpulandata,hak
penghapusanakunbesertaseluruhdataterkait,danlogaudituntukaksesdatasensitif.

20.UI/UXFlow

20.1DesignPrinciples

DesainSinggahmengikutitigaprinsiputama.Pertama,jelasditatappertamayaitupengguna
baruharussegeramemahamiapayangdilakukanaplikasitanpatutorialpanjang.Kedua,ringan
secarakognitifyaitusetiaplayarfokuspadasatuaksiutamadenganopsisekunderyangtidak
mengganggu.Ketiga,estetisdanramahIndonesiayaitumenggunakantipograﬁmodern,palet
warnayanghangat,danistilahyangfamilierbagitravelerIndonesia.

20.2VisualLanguage

Paletwarnautamamenggunakanwarnaprimerhijaunaturalyangmerepresentasikan
perjalanandaneksplorasi,denganaksenoranyeterakotauntukcalltoaction.Tipograﬁ
menggunakansatutypefacemodernsepertiPlusJakartaSansatauInterdengantigaskala
ukuranutama.Sudutkomponenmenggunakanradiusmediumyanglembut.Ilustrasiminimal
denganikonline-styleyangkonsisten.

20.3KeyUserFlow

Flowpembuatantripbarudimulaidarihomescreendengantombolcreatetripyangmenonjol,
dilanjutkankelayarinputnamatripdanpemilihankotaasal-tujuan,kemudianpemilihan
tanggaldanjeniskendaraan,lalulayarpreviewestimasiperjalanan,dandiakhiridengantrip
detailscreenyangmenjadihubsemuaaktivitasperencanaan.

Flowpenambahandestinasidimulaidaritripdetailscreendengantabdestinations,dilanjutkan
kesearchscreenyangmenampilkanrekomendasiawal,kemudianpenggunamemilihdestinasi
untukmelihatdetail,danmenambahkanketripdengansatutap.

Flowpenyusunantimelinedimulaidaritripdetailscreendengantabtimeline,sistemmemberi
opsiauto-arrangeawalberdasarkanurutanpenambahanatauurutanoptimal,penggunadapat
melakukandraganddropuntukmengubahurutan,dansetiapperubahanlangsungmemicu
validasidenganumpanbalikvisualjikaadakonﬂik.

21.ScreenList&Navigation

21.1NavigationStructure

NavigasiutamaaplikasimenggunakanbottomtabbardenganempattabyaituHomeyang
menampilkanringkasantripaktifdanrekomendasi,Tripsyangberisidaftarsemuatrip
pengguna,Exploreyangmenampilkankotadandestinasipopuler,danProﬁleyangberisi
pengaturanakundanpreferensi.

Navigasisekundermunculsebagaistackdiatastabbaruntukﬂowsepertipembuatantrip,detail
trip,pencariandestinasi,danediting.

21.2ScreenInventory

DaftarlayaryangadapadaMVPmencakupsplashscreen,onboardingscreenyangterdiridari
tigahalaman,loginscreen,registerscreen,forgotpasswordscreen,homescreen,triplistscreen,
createtripwizardyangterdiridaribeberapastep,tripdetailscreendenganbeberapatabyaitu
overview,destinations,timeline,hotels,danmap,destinationsearchscreen,destinationdetail
screen,hotellistscreen,hoteldetailscreen,timelineeditorscreen,proﬁlescreen,editproﬁle
screen,preferencesscreen,dansettingsscreen.

21.3DeepLinking

Aplikasimendukungdeeplinkuntukskenariopembagiantripdenganpath/trips/{id}dandeep
linkdarinotiﬁkasidenganpath/notiﬁcations/{id}.Deeplinkdiintegrasikandengango_router
dandidaftarkandimanifestAndroidsertainfo.plistiOS.

22.DevelopmentRoadmap

22.1Phase0—Foundation(Month1)

Padabulanpertamatimfokuspadapenyiapanfondasiteknis.Setuprepository,CI/CDpipeline
awal,environmentdevelopment,staging,danproduction.Implementasisistemautentikasiend
toend.Penyusunandesignsystemdasardankomponenreusable.Setupdatabaseschemaawal
danmigration.IntegrasiawalGoogleMapsSDKpadaaplikasimobile.

22.2Phase1—MVPCore(Month2to4)

BulankeduasampaikeempatadalahpengembanganﬁturintiMVP.Tripmanagementlengkap
daripembuatanhinggapenghapusan.Destinationmanagementdenganpencariandankategori.
TransportationestimationdenganintegrasiGoogleDirections.Timelineeditordengandragand
dropdanvalidasikonﬂik.Hoteldiscoverydenganﬁlterdasar.Notiﬁcationremindersederhana.

22.3Phase2—Polish&Launch(Month5)

Bulankelimadifokuskanpadaqualityassurance,perbaikanUXberdasarkaninternaltesting,
performancetuning,betatestingtertutupdengankelompokpenggunaterpilih,danpersiapan

riliskePlayStoredanAppStore.

22.4Phase3—Post-LaunchIteration(Month6to9)

Pascapeluncurantimmengiterasiberdasarkandatadanfeedback.Penambahanﬁturkecilyang
banyakdiminta.Optimasionboardingberdasarkanfunnelanalysis.Eksperimenpertumbuhan
sepertireferraldansharetrip.

22.5Phase4—SmartRecommendation(Month10to12)

PadaakhirtahunpertamafokusbergeserkeﬁturAIrecommendation.Mulaidengancontent-basedﬁltering,kemudianrilisalongrouterecommendation,danberkembangkeembedding-basedrecommendation.

22.6MVPScopeSummary

ScopeMVPsecararingkasmeliputiautentikasiemaildansociallogin,tripmanagement
lengkap,transportationestimationuntukmotordanmobil,hoteldiscoverydenganﬁlter,
destinationmanagementdenganlimakategori,timelineeditordenganvalidasikonﬂik,
notiﬁcationreminder,danproﬁlpenggunadasar.

22.7FutureScopeSummary

ScopemasadepansetelahMVPmeliputiAIrecommendationlengkap,kolaborasimulti-user
padasatutrip,bookinghoteldantransportasiterintegrasi,socialfeaturessepertisharetrip
publik,modeoﬄinepenuh,dukunganperjalananinternasional,integrasicalendarpengguna,
danekspansikewebappsebagaicompanion.

23.DeploymentArchitecture

23.1Environments

Tigaenvironmentdipertahankanyaitudevelopmentuntukpengembanganharian,staging
untukQAdanUAT,danproductionuntukpenggunaakhir.Setiapenvironmentmemiliki
database,Redis,dansecretyangterpisah.Konﬁgurasiperenvironmentdikelolamelalui
environmentvariableyangdi-injectsaatdeployment.

23.2MobileDistribution

Distribusiaplikasimobilemengikutipipelinestandar.Buildinternaldidistribusikanmelalui
FirebaseAppDistributionuntuktestingharianolehtim.Buildbetadidistribusikanmelalui
TestFlightpadaiOSdanInternalTestingdiPlayConsolepadaAndroid.Buildproduction
diunggahkeAppStoredanPlayStoredenganstagedrolloutdimulaidarisatupersenpengguna
lalunaikbertahap.

23.3BackendDeployment

BackenddideploysebagaicontainerDockeryangdibuildolehCIdandipushkeregistry.Pada
faseMVPbackenddijalankandiSupabaseEdgeFunctionsatauRailwayuntukoperasionalyang
ringan.PadafasepertumbuhanmigrasidilakukankeAWSdenganECSFargateatauEKS
sebagaiorchestrator,RDSPostgreSQLsebagaidatabase,danElastiCacheRedissebagaicache.

23.4ZeroDowntimeDeployment

Strategirollingdeploymentdigunakandenganminimalduareplicaselalutersedia.Healthcheck
padaendpoint/healthzmemastikaninstancebarusudahsiapsebelumtraﬃcdialihkan.
Databasemigrationyangmerubahschemadilakukandenganpendekatanexpandandcontract
sehinggatidakmenyebabkandowntime.

23.5InfrastructureasCode

SeluruhinfrastrukturdideklarasikanmenggunakanTerraformsehinggadapatdiversi,di-review,dandireproduksi.ModulTerraformdibagiperkomponenyaitunetwork,database,
compute,dansecrets.

24.DevOpsRecommendation

24.1CI/CDPipeline

ContinuousintegrationdijalankanpadaGitHubActionsdenganworkﬂowyangmencakuplint,
typecheck,unittest,integrationtest,buildartifact,danpublishkeregistryuntukbackendserta
buildAPKdanIPAuntukmobile.Setiappullrequestmemicupipelinelengkapdanharushijau
sebelumdapatdi-merge.

Continuousdeliverydijalankanotomatisuntukenvironmentdevelopmentsetiapmergeke
branchmain,manualapprovaluntukstaging,danmanualapprovaldenganchangelognotes
untukproduction.

24.2Monitoring&Observability

Monitoringbackendmenggunakankombinasimetrik,log,dantrace.Metrikdikumpulkanoleh
Prometheusataudashboardbuilt-indaripenyediacloud,dengandashboarddiGrafanauntuk
metrikkuncisepertirequestrate,errorrate,danlatency.Logterstrukturdikirimkelayanan
terpusatsepertiDatadogatauBetterStackdenganretentionsesuaikepatuhan.Tracing
terdistribusimenggunakanOpenTelemetryuntukmelacakrequestlintasservice.

MonitoringmobilemenggunakanSentryuntukcrashreportingdanperformance,Firebase
Crashlyticssebagaicadangan,danMixpaneluntukproductanalytics.

24.3Alerting

AlertdikirimkechannelSlacktimengineeringuntukinsidenproductiondenganseveritytier.P1

untukinsidenyangberdampakpadamayoritaspenggunasepertiAPIdown.P2untukdegradasi
yangmembatasisebagianﬁtur.P3untukanomaliyangperludiinvestigasitetapitidak
mendesak.

24.4IncidentManagement

SetiapinsidenP1atauP2mendapatpost-mortemdenganformatblamelessyangmencatat
timeline,rootcause,danactionitem.Actionitemdimasukkankebacklogdanditrackingsampai
selesai.

24.5SecretManagement

Secretsepertidatabasepassword,APIkeyGoogleMaps,dansigningkeydikeloladiAWSSecrets
ManageratauDoppler.Secrettidakpernahmasukkerepository,bahkandalambentuk
encrypted.Akseskesecretmanagerdiaturdenganleastprivilege.

25.TestingStrategy

25.1TestPyramid

Strategitestingmengikutipiramidaklasikdenganunittestsebagaidasaryangpalingbanyak,
integrationtestsebagailapisantengah,danendtoendtestsebagaipuncakyangpalingsedikit
namunpalingkomprehensif.

25.2MobileTesting

Padasisimobile,unittestmenggunakanpakettestbawaanFlutterdanmocktailuntukmocking.
Cakupanunittestdifokuskanpadausecasedidomainlayerdantransformerdidatalayer
dengantargetminimaldelapanpuluhpersenlinecoverage.

WidgettestmemveriﬁkasibehaviorkomponenUIdenganmenggunakanﬂutter_test.Setiap
screenutamamemilikiwidgettestuntukskenariodasarsepertirenderingloadingstate,error
state,dansuccessstate.

Endtoendtestmenggunakanintegration_testatauPatroluntukmensimulasikanalurlengkap
diemulatordandeviceasli.Skenariokritissepertilogin,createtrip,danadddestinationdijaga
selaluhijau.

25.3BackendTesting

BackendmenggunakanJestsebagaitestrunner.Unittestmencakupservicelayerdengan
mockingpadarepository.Integrationtestmencakupcontrollerdengandatabasetest
menggunakanTestcontainersuntukPostgreSQL.ContracttestpadalevelAPImemastikan
responsesesuaidengankontrakyangdidokumentasikandiOpenAPIspec.

25.4PerformanceTesting

Performancetestdilakukansecaraterjadwalpadastagingmenggunakank6denganskenario
yangmerepresentasikanbebanhariandanpeak.Thresholdperformancesepertip95latencydi
bawahlimaratusmilidetikuntukendpointdasardandibawahduadetikuntukendpoint
estimasirutedimonitor.

25.5Manual&ExploratoryTesting

QAmanualdilakukanolehtimpadasetiaprilisbesardenganchecklistyangdimaintain.
Exploratorytestingolehanggotatimnon-engineeringmembantumenemukanedgecaseyang
luputdariautomatedtest.

26.FolderStructure

26.1MobileFolderStructure

StrukturfolderaplikasiFluttermengikutipemisahanperﬁturdengansetiapﬁturmemilikitiga
lapisaninternalsesuaiCleanArchitecture.

lib/ app/

> app.dart router.dart theme.dart
>
> core/ constants/ errors/ network/
>
> dio_client.dart interceptors/
>
> utils/ widgets/
>
> features/ auth/
>
> data/ datasources/ models/ repositories/
>
> domain/ entities/ repositories/ usecases/
>
> presentation/ providers/ screens/ widgets/
>
> trip/ data/ domain/
>
> presentation/ destination/ hotel/ timeline/ profile/
>
> l10n/ main.dart

test/ features/

> auth/ trip/

helpers/ integration_test/

26.2BackendFolderStructure

StrukturfolderbackendNestJSmengikutipemisahanpermoduldomaindenganstruktur
internalyangkonsisten.

src/ app.module.ts main.ts common/

> decorators/ filters/ guards/ interceptors/ pipes/
>
> config/ database.config.ts redis.config.ts app.config.ts
>
> modules/ auth/
>
> auth.controller.ts auth.service.ts auth.module.ts dto/
>
> strategies/ user/
>
> trip/ trip.controller.ts trip.service.ts trip.module.ts
> trip.repository.ts dto/
>
> entities/ destination/ hotel/ itinerary/
>
> itinerary.controller.ts itinerary.service.ts itinerary.engine.ts
>
> recommendation/ notification/ integration/
>
> maps/
>
> google-maps.service.ts database/
>
> migrations/ seeders/

test/ unit/

> integration/ e2e/

26.3RepositoryStrategy

PadafaseMVP,mobiledanbackenddisimpandalamduarepositoryterpisahkarenateknologi
dantoolingyangberbeda.DokumentasiinfrastrukturdanSDDdisimpandirepositoryketiga
yangberisicatatanarsitekturdandiagram.Padafasepertumbuhan,monorepodengantooling
sepertiNxdapatdipertimbangkanjikamanfaatsharingkodedantoolinglebihbesardari
kompleksitastambahan.

27.CodingConventions

27.1GeneralPrinciples

Konvensikodingmengikutitigaprinsipyaitukonsistenlebihpentingdaripadasempurna
sehinggatimmengikutikonvensiyangsudahditetapkan,eksplisitlebihbaikdariimplisit
terutamapadanamavariabeldanfungsiyangmenjelaskantujuan,dankodedibacalebihsering
daripadaditulissehinggaketerbacaandiutamakan.

27.2Dart&FlutterConventions

Penamaanﬁlemenggunakansnake_casesepertitrip_repository.dartdan
create_trip_screen.dart.PenamaankelasmenggunakanUpperCamelCase.Penamaanvariabel
danfungsimenggunakanlowerCamelCase.KonstantamenggunakanlowerCamelCaseyang
diawalihurufkecilkbilaberupakonstantavisualsepertikPrimaryColor,atau
SCREAMING_SNAKE_CASEbilaberupakonﬁgurasiglobalyangbersifatenvironment.

Lintingmenggunakanpaketﬂutter_lintssebagaidasardengantambahanaturandari
very_good_analysisuntukkonsistensiyanglebihketat.Formatkodedijalankanotomatis
melaluidartformatdandiveriﬁkasipadaCI.

Komentarditulishanyaketikamenjelaskanalasankeputusanyangtidakterlihatdarikodeitu
sendiri.Komentaryangsekadarmengulangnamafungsitidakditulis.

27.3TypeScript&NestJSConventions

Penamaanﬁlemenggunakankebab-casesepertitrip.controller.tsdancreate-trip.dto.ts.Kelas
menggunakanUpperCamelCase.VariabeldanfungsimenggunakanlowerCamelCase.Interface
diberipreﬁxIhanyajikadiperlukanuntukmembedakandarikelasdengannamaserupa,selain
itunamainterfacetidakdiberipreﬁx.

LintingmenggunakanESLintdengankonﬁgurasitypescript-eslintyangstrict.Prettier
digunakanuntukformattingotomatis.Aturantambahansepertilarangananytanpajustiﬁkasi
di-enforcemelaluiESLintrule.

DTOselaludideklarasikaneksplisituntukrequestdanresponse.ValidasiDTOmenggunakan
class-validatordengandekoratoryangsesuai.Servicetidakbolehmenerimaatau
mengembalikantipeentitydatabasesecaralangsungkecualipadarepository.

27.4Git&CommitConventions

Branchdinamaidenganpolatipe/deskripsi-singkatsepertifeat/create-trip-ﬂow,ﬁx/timeline-conﬂict-edge-case,danchore/upgrade-ﬂutter-3-19.CommitmengikutiConventionalCommits
denganformattype(scope):subjectsehinggachangelogdapatdigenerateotomatis.Pullrequest
memilikideskripsiyangmenjelaskanapayangberubah,mengapa,danbagaimanacara
mengujinya.

27.5CodeReview

Setiappullrequestmembutuhkanminimalsatuapprovaldariengineerlainsebelumdapatdi-merge.Reviewerfokuspadakebenaranlogika,konsistensidengankonvensi,kualitastest,dan
dampakpadakeseluruhansistem.Diskusiyangpanjangdikomentarpullrequestdipindahkan
kemeetingsinkronuntukeﬁsiensi.

27.6Documentation

Dokumentasiteknisdipertahankansedekatmungkindengankode.READMEdisetiapmodul
backendmenjelaskantanggungjawabmodul.READMEdisetiapﬁturmobilemenjelaskan
strukturdanalurdata.ADR(ArchitecturalDecisionRecord)ditulisketikatimmengambil
keputusanarsitekturpentingyangakanberpengaruhjangkapanjang.

28.Appendix

28.1Glossary

Tripmerujukpadasaturencanaperjalananyangdibuatpenggunadarikotaasalkekotatujuan
dalamrentangtanggaltertentu.Destinationmerujukpadasatutempatyangingindikunjungi
penggunadalamsuatutrip.Placemerujukpadadatamastertempatyangdapatmenjadi
destinasidibanyaktrippengguna.Timelinemerujukpadaurutankunjunganhariandenganjam
datangdanjampergi.Itinerarymerujukpadakeseluruhanrencanaperjalanantermasuk
timeline,destinasi,hotel,dantransportasi.BATNAdanistilahnegosiasitidakrelevanpada
dokumenini.

28.2OpenQuestions

Beberapahalyangmasihperludiputuskansebelumimplementasidimulaimeliputipilihanﬁnal
antaraRiverpoddanBLoCuntukstatemanagement,pilihanantaraSupabasedanAWSuntuk
faseMVPberdasarkanestimasibiayabulanan,sumberdatahotelawalapakahdaripartnership
langsungataudaripenyediadataberbayar,danstrategiawaluntukmendapatkandatamaster
Placedikotatierduadantiga.

28.3References

DokumeniniakandikomplemenolehdokumenpendukungyangdimaintainterpisahyaituAPI
SpeciﬁcationdalamformatOpenAPI,DesignSystemDocumentationdiFigma,PrivacyPolicy
danTermsofServiceyangdisusunbersamatimlegal,danOperationalRunbookuntuktim
DevOps.

28.4DocumentMaintenance

DokumenSDDinibersifathidupdanakandiupdateseiringevolusiproduk.Setiapperubahan
signiﬁkanpadaarsitekturmemicuupdatedokumendenganversionbump.Riwayatperubahan
dicatatdisectionterpisahpadaversimendatang.Pemilikdokumenbertanggungjawab
memastikandokumentidakmelebihienambulantanpareview.

EndofDocument
