#include <stdint.h>
#include <stdio.h>
#include <iomanip>


#include <limits.h>
#include "yam_big_int.h"
#include "gtest/gtest.h"


class BigIntTest : public testing::Test
{
protected:
	const char* a, * b, * c, *d, *e;
	virtual void SetUp() {
	/*numbers from the digits of pi*/
	this->a = "951059731732816096318595024459455346908302642522308253344685035261931188171010003137838752886587533208381420617177669147303598253490428755468731159562863882353787593751957781857780532171226806613001927876611195909216420198938095257201065485863278865936153381827968230301952035301852968995773622599413891249721775283479131515574857242454150695950829533116861727855889075098381754637464939319255060400927701671139009848824012858361603563707660104710181942955596198946767837449448255379774726847104047534646208046684259069491293313677028989152104752162056966024058038150193511253382430035587640247496473263914199272604269922796782354781636009341721641219924586315030286182974555706749838505494588586926995690927210797509302955321165344987202755960236480665499119881834797753566369807426542527862551818417574672890977772793800081647060016145249192173217214772350141441973568548161361157352552133475741849468438523323907394143334547762416862518983569485562099219222184272550254256887671790494601653466804988627232791786085784383827967976681454100953883786360950680064225125205117392984896084128488626945604241965285022210661186306744278622039194945047123713786960956364371917287467764657573962413890865832645995813390478027590099465764078951269468398352595709825822620522489407726719478268482601476990902640136394437455305068203496252451749399651431429809190659250937221696461515709858387410597885959772975498930161753928468138268683868942774155991855925245953959431049972524680845987273644695848653836736222626099124608051243884390451244136549762780797715691435997700129616089441694868555848406353422072225828488648158456028506016842739452267467678895252138522549954666727823986456596116354886230577456498035593634568174324112515076069479451096596094025228879710893145669136867228748940560101503308617928680920874760917824938589009714909675985261365549781893129784821682998948722658804857564014270477555132379641451523746234364542858444795265867821051141354735739523113427166102135969536231442952484937187110145765403590279934403742007310578539062198387447808478489683321445713868751943506430218453191048481005370614680674919278191197939952061419663428754440643745123718192179998391015919561814675142691239748940907186494231961567945208095146550225231603881930142093762137855956638937787083039069792077346722182562599661501421503068038447734549202605414665925201497442850732518666002132434088190710486331734649651453905796268561005508106658796998163574736384052571459102897064140110971206280439039759515677157700420337869936007230558763176359421873125147120532928191826186125867321579198414848829164470609575270695722091756711672291098169091528017350671274858322287183520935396572512108357915136988209144421006751033467110314126711136990865851639831501970165151168517143765761835155650884909989859982387345528331635507647918535893226185489632132933089857064204675259070915481416549859461637180270981994309924488957571282890592323326097299712084433573265489382391193259746366730583604142813883032038249037589852437441702913276561809377344403070746921120191302033038019762110110044929321516084244485963766983895228684783123552658213144957685726243344189303968642624341077322697802807318915441101044682325271620105265227211166039666557309254711055785376346682065310989652691862056476931257058635662018558100729360659876486117910453348850346113657686753249441668039626579787718556084552965412665408530614344431858676975145661406800700237877659134401712749470420562230538994561314071127000407854733269939081454664645880797270826683063432858785698305235808933065757406795457163775254202114955761581400250126228594130216471550979259230990796547376125517656751357517829666454779174501129961489030463994713296210734043751895735961458901938971311179042978285647503203198691514028708085990480109412147221317947647772622414254854540332157185306142288137585043063321751829798662237172159160771669254748738986654949450114654062843366393790039769265672146385306736096571209180763832716641627488880";
	
	this->b = "963186294726547364252308177036751590673502350728354056704038674351362222477158915049530984448933309634087807693259939780541934144737744184263129860809988868741326047215695162396586457302163159819319516735381297416772947867242292465436680098067692823828068996400482435403701416314965897940924323789690706977942236250822168895738379862300159377647165122893578601588161755782973523344604281512627203734314653197777416031990665541876397929334419521541341899485444734567383162499341913181480927777103863877343177207545654532207770921201905166096280490926360197598828161332316663652861932668633606273567630354477628035045077723554710585954870279081435624014517180624643626794561275318134078330336254232783944975382437205835311477119926063813346776879695970309833913077109870408591337464144282277263465947047458784778720192771528073176790770715721344473060570073349243693113835049316312840425121925651798069411352801314701304781643788518529092854520116583934196562134914341595625865865570552690496520985803385072242648293972858478316305777756068887644624824685792603953527734803048029005876075825104747091643961362676044925627420420832085661190625454337213153595845068772460290161876679524061634252257719542916299193064553779914037340432875262888963995879475729174642635745525407909145135711136941091193932519107602082520261879853188770584297259167781314969900901921169717372784768472686084900337702424291651300500516832336435038951702989392233451722013812806965011784408745196012122859937162313017114448464090389064495444006198690754851602632750529834918740786680881833851022833450850486082503930213321971551843063545500766828294930413776552793975175461395398468339363830474611996653858153842056853386218672523340283087112328278921250771262946322956398989893582116745627010218356462201349671518819097303811980049734072396103685406643193950979019069963955245300545058068550195673022921913933918568034490398205955100226353536192041994745538593810234395544959778377902374216172711172364343543947822181852862408514006660443325888569867054315470696574745855033232334210730154594051655379068662733379958511562578432298827372319898757141595781119635833005940873068121602876496286744604774649159950549737425626901049037781986835938146574126804925648798556145372347867330390468838343634655379498641927056387293174872332083760112302991136793862708943879936201629515413371424892830722012690147546684765357616477379467520049075715552781965362132392640616013635815590742202020318727760527721900556148425551879253034351398442532234157623361064250639049750086562710953591946589751413103482276930624743536325691607815478181152843667957061108615331504452127473924544945423682886061340841486377670096120715124914043027253860764823634143346235189757664521641376796903149501910857598442391986291642193994907236234646844117394032659184044378051333894525742399508296591228508555821572503107125701266830240292952522011872676756220415420516184163484756516999811614101002996078386909291603028840026910414079288621507842451670908700069928212066041837180653556725253256753286129104248776182582976515795984703562226293486003415872298053498965022629174878820273420922224533985626476691490556284250391275771028402799806636582548892648802545661017296702664076559042909945681506526530537182941270336931378517860904070866711496558343434769338578171138645587367812301458768712660348913909562009939361031029161615288138437909904231747336394804575931493140529763475748119356709110137751721008031559024853090669203767192203322909433467685142214477379393751703443661991040337511173547191855046449026365512816228824462575916333039107225383742182140883508657391771509682887478265699599574490661758344137522397096834080053559849175417381883999446974867626551658276584835884531427756879002909517028352971634456212964043523117600665101241200659755851276178583829204197484423608007193045761893234922927965019875187212726750798125547095890455635792122103334669749923563025494780249011419521238281530911407907386025152274299581807247162591668545133312394804947079119153267343028244186041426363954800044800267";
	/*result of a+b*/
	this->c = "963186294726547364252308177036751590673502350728354056704038674351362222477159866109262717265029628229112267148606848083184456452991088869298391791998159878744463885968581749929794838722780337488466820333634787845528416598401855329319033885661444781609926776932653662210314418242842509136833540209889645073199437316308032174604316015681987345877467074928880454557157529405572937235854003287910682865830228055019870182686616371409514791062275410616440281240082199506702417559742840883152066786952687890201538811109362192312481103144860762295227258763809645854207936059163767700396578876680290532637121647791305064034229828306872642920894337119585817525770563054679214434808771791397992529608858502706741757737218841844653198761145988399661807165878944865540662915615364997178264459835209488060975250002779950123707395527488309657456269835603179270814136443156670235641697601134730415098012903424591869492999861330846553973817005733301442995962090152482357923292266893729101607715038991213820428379946719620005065156491842047801867876975291071917175078942680275744022336456514833994503308616890832876027789330652726379728374304618446611870689679462418270988829964856588778788822283766026919274468380729223043471686592974859084464146662223845328367796763196939300209707939298774977781706950331569221522618573366161471531348251541366294123081788303804377627621399438199974261759375326221294775157729359854796752968581736086470381512180051484388943710274322674870171819343081971895835436092474771042916602359072933438218162190546680097556592181579807443421632668155478546871487287586708708603054821373215436233514789637316591075728129467988791675305077484840163207919678880965418726083982330705011842247178540183022539379795957816502909785496277623126813880038712861981896448933918699385265153387271627924495125803551847200281500668422830689912215633092112529293998628651698981640850594854793328952315336794964815136029521453407544527431723595056078543908501036707231780186981649919475923589273705599096773056865105238591756390918195670206436097859282199334470180266386037004140316255772879145362101842512836040834682898437819339983228928114322689262318781990354820002716963057965697640955920352106301820327228979926787999566237555559366292543679863564527865721406388400158309798070738390867963573787406833900028968207449541362025466590874022029963767371370010362679913761082482224893406947920216138880889023117114163287331167967547058565817511078666323260868022451161848718432386887883075203333158830619959448040340816420359227825375433802658021813850656086700722619383921316690140420694026111945685414188383402431133420530488456651572660402116371131549550207640539256335206834566730290395609765119010572437114732312437763207108335796499699084086670437307430110550749901428630403139328242985680311227708159370321035243902973726027712564659465108372274317656728153992035691126812627638480853647380324674756308646701673795617689606856875818776262066993868325841462490477207181396073598545996800022953799292393254309365753921614226822214635647946545875470979359786725790398828022952599816145923445118785574615308342367032245625741393612224257572005388586801535485605766475520256992169783701865267332016201460758805974982428907420748346878588305847603853234985748589252372479562543229342486816761785554600809005135480393356643153188648140834023650001605771618486870618089664823633846239167270564108233454305257924781839254187450228997561024748736717539439564116111990265756077734381536635181586408613346549015177617271410837845374740510758073404086186416360520153365920670962094401657370997684988022654568865204316367443090076745491820544023106395031654437012546252478158678234330179788443305633853434978706205858423099034402102492635888945586545457688691529482933123486676958756819328334708853136936621214753215149895008247175770071111210391737275921943008918445129287334434044698445898169510145310176124279288640812038061148068558102000841218183475453690072179576640773891260954531257361816654511911527102434574212751265538574079124815395222190196671441672289147";

	/*10000th Fibonacci number (zero indexed) */
	this->d = "33644764876431783266621612005107543310302148460680063906564769974680081442166662368155595513633734025582065332680836159373734790483865268263040892463056431887354544369559827491606602099884183933864652731300088830269235673613135117579297437854413752130520504347701602264758318906527890855154366159582987279682987510631200575428783453215515103870818298969791613127856265033195487140214287532698187962046936097879900350962302291026368131493195275630227837628441540360584402572114334961180023091208287046088923962328835461505776583271252546093591128203925285393434620904245248929403901706233888991085841065183173360437470737908552631764325733993712871937587746897479926305837065742830161637408969178426378624212835258112820516370298089332099905707920064367426202389783111470054074998459250360633560933883831923386783056136435351892133279732908133732642652633989763922723407882928177953580570993691049175470808931841056146322338217465637321248226383092103297701648054726243842374862411453093812206564914032751086643394517512161526545361333111314042436854805106765843493523836959653428071768775328348234345557366719731392746273629108210679280784718035329131176778924659089938635459327894523777674406192240337638674004021330343297496902028328145933418826817683893072003634795623117103101291953169794607632737589253530772552375943788434504067715555779056450443016640119462580972216729758615026968443146952034614932291105970676243268515992834709891284706740862008587135016260312071903172086094081298321581077282076353186624611278245537208532365305775956430072517744315051539600905168603220349163222640885248852433158051534849622434848299380905070483482449327453732624567755879089187190803662058009594743150052402532709746995318770724376825907419939632265984147498193609285223945039707165443156421328157688908058783183404917434556270520223564846495196112460268313970975069382648706613264507665074611512677522748621598642530711298441182622661057163515069260029861704945425047491378115154139941550671256271197133252763631939606902895650288268608362241082050562430701794976171121233066073310059947366875";
	this->e = "1234567890123456789012345678";
	}
	virtual void TearDown() {}
};

TEST_F(BigIntTest, FromString) {
	/*This test depends on big_int_to_str working*/
	char* aa, * bb;
	const char* cc;
	BigInt* A = newBigInt;
	size_t nbytes;
	nbytes = 0;
	/*create a string with all lower ascii characters*/
	aa = (char*) malloc(128*sizeof(char));
	if(aa != NULL) {
		bb = aa;
		unsigned ii;
		for(ii = 1; ii < 128; ++ii) {
			*bb++ = ii;
		}
		*bb = '\0';
		/*now create the expected BigInt skipping all other characters*/
		big_int_from_str(A, aa);
		/*the digit characters should be the only ones left*/
		cc = "0123456789";
		ASSERT_STREQ(big_int_to_str(A, &nbytes), cc);
		free(aa);
		BigInt_destroy(A);
	}
}

TEST_F(BigIntTest, ToString) {
	BigInt* D,* E;
	D = newBigInt;
	E = newBigInt;
	big_int_from_str(D, const_cast<char*>(d));
	big_int_from_str(E, const_cast<char*>(e));
	size_t nbytes;
	nbytes = 0;
	ASSERT_STREQ(d, big_int_to_str(D, &nbytes));
	EXPECT_EQ(2090, nbytes);
	nbytes = 0;
	ASSERT_STREQ(e, big_int_to_str(E, &nbytes));
	EXPECT_EQ(28, nbytes);
	/**/
	BigInt_destroy(D);
	BigInt_destroy(E);
}

TEST_F(BigIntTest, AddOnStack) {
	/*this test depends on big_int_to_str, and big_int_equality*/
	BigInt* A, * B, * C;
	A = newBigInt;
	B = newBigInt;
	C = newBigInt;
	BigInt D, E;
	big_int_from_str(A, const_cast<char*>(a));
	big_int_from_str(B, const_cast<char*>(b));
	/*hold what the result should be*/
	big_int_from_str(C, const_cast<char*>(c));
	/*test that operation is associative*/
	D = big_int_add_stack(A, B);
	E = big_int_add_stack(B, A);
	ASSERT_EQ(1, big_int_equality(&D, C));
	ASSERT_EQ(1, big_int_equality(&E, C));
	BigInt_destroy(A);
	BigInt_destroy(B);
	BigInt_destroy(C);
}

TEST_F(BigIntTest, AddOnHeap) {
	BigInt* A, * B, * C, *D, *E;
	A = newBigInt;
	B = newBigInt;
	C = newBigInt;
	D = newBigInt;
	E = newBigInt;
	big_int_from_str(A, const_cast<char*>(a));
	big_int_from_str(B, const_cast<char*>(b));
	/*hold what the result should be*/
	big_int_from_str(C, const_cast<char*>(c));
	/*test that operation is associative*/
	big_int_add_heap(A, B, D);
	big_int_add_heap(B, A, E);
	ASSERT_EQ(1, big_int_equality(D, C));
	ASSERT_EQ(1, big_int_equality(E, C));
	BigInt_destroy(A);
	BigInt_destroy(B);
	BigInt_destroy(C);
	BigInt_destroy(D);
	BigInt_destroy(E);
}

TEST_F(BigIntTest, LessThan) {
	const char* aa, *bb;
	aa = "1111111111111111111111111111";
	bb = "1091111111111111111111111111";
	BigInt* A,* B;
	A = newBigInt;
	B = newBigInt;
	big_int_from_str(A, const_cast<char*>(aa));
	big_int_from_str(B, const_cast<char*>(bb));
	ASSERT_EQ(1, big_int_less_than(B, A));
	ASSERT_EQ(0, big_int_less_than(A, B));
	ASSERT_EQ(0, big_int_less_than(A, A));
	ASSERT_EQ(0, big_int_less_than(B, B));
	BigInt_destroy(A);
	BigInt_destroy(B);
}

TEST_F(BigIntTest, Equals) {
	const char* aa, *bb;
	aa = "1111111111111111111111111111";
	bb = "10";
	BigInt* A,* B;
	A = newBigInt;
	B = newBigInt;
	big_int_from_str(A, const_cast<char*>(aa));
	big_int_from_str(B, const_cast<char*>(bb));
	ASSERT_EQ(1, big_int_equality(A, A));
	ASSERT_EQ(0, big_int_equality(A, B));
	ASSERT_EQ(0, big_int_equality(B, A));
	ASSERT_EQ(1, big_int_equality(B, B));
	BigInt_destroy(A);
	BigInt_destroy(B);
}
