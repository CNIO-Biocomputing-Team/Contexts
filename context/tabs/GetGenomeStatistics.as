package context.tabs
{
	import context.Context;
	import context.Tab;
	
	import flare.scale.ScaleType;
	import flare.util.Shapes;
	import flare.vis.Visualization;
	import flare.vis.data.Data;
	import flare.vis.operator.encoder.ColorEncoder;
	import flare.vis.operator.layout.AxisLayout;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import misc.SpriteUIComponent;
	
	import mx.controls.Alert;
	import mx.controls.Label;
	import mx.rpc.events.ResultEvent;
	
	import services.Genomestatistics;

	public class GetGenomeStatistics extends Tab
	{
		
		public function GetGenomeStatistics(parent:Context)
		{
			super();
			parentContext = parent;
		}
		
		public function render():void{
			if (!parentContext.genomeEnsemblId)
				Alert.show("Please select a genome","Alert");
			else{	
				parentContext.workBox.removeAllChildren();
				//progress
				/* parentContext.pb.label = "Waiting for response from ensembl.org ..."; */
				parentContext.pb.alpha = 1; 
				
				var biomartName:String = getBiomartName(parentContext.genomeEnsemblId);
				
				var bounds:Rectangle = new Rectangle(0,0,730,200);
				var graph:Sprite = new Sprite();
				var vis:Visualization = new Visualization();
				vis.x = 50;
				vis.y = 50;
				vis.bounds = bounds;
				graph.addChild(vis);
				parentContext.workBox.addChild(new SpriteUIComponent(graph));
				
				var genomeStatisticsServ:Genomestatistics = new Genomestatistics();
				
				genomeStatisticsServ.getGenomeStatistics(biomartName,function(e:ResultEvent):void{
					
					var genome:Data = _buildFlareData(e.result.statistics)
					vis.data = genome;
					
					vis.data.nodes.setProperties({
						shape: Shapes.VERTICAL_BAR,
						lineAlpha: 0,
						size: 5
					});
					vis.operators.add(new AxisLayout("data.x", "data.y", false, true));
					vis.operators.add(new ColorEncoder("data.x", "nodes", "fillColor", ScaleType.CATEGORIES));
					parentContext.pb.alpha = 0;
					vis.update();
				});
			}
		}
		
		private function _buildFlareData(xml:Object):Data{
			var genome:Data = new Data;
			for (var key:String in xml)
				genome.addNode({x:key, y:xml[key]});
			return genome;	
		}
		
		private function getBiomartName(genomeEnsemblId:String):String
		{
			var biomartName:String = "";
			var biomartSelect:String =	'<select><option value="bac_29934_gene">Bacillus amyloliquefaciens genes (EB 1)</option>' + 
					                '<option value="bac_1642_gene">Bacillus anthracis Ames ancestor genes (EB 1)</option>' + 
					                '<option value="bac_136_gene">Bacillus anthracis Ames genes (EB 1)</option>' + 
					                '<option value="bac_20000_gene">Bacillus anthracis Sterne genes (EB 1)</option>' + 
					                '<option value="bac_32390_gene">Bacillus cereus AH187 genes (EB 1)</option>' + 
					                '<option value="bac_32575_gene">Bacillus cereus AH820 genes (EB 1)</option>' + 
					                '<option value="bac_902_gene">Bacillus cereus ATCC 10987 genes (EB 1)</option>' + 
					                '<option value="bac_134_gene">Bacillus cereus ATCC 14579 genes (EB 1)</option>' + 
					                '<option value="bac_32396_gene">Bacillus cereus B4264 genes (EB 1)</option>' + 
					                '<option value="bac_32531_gene">Bacillus cereus G9842 genes (EB 1)</option>' + 
					                '<option value="bac_29604_gene">Bacillus cereus NVH 391-98 genes (EB 1)</option>' + 
					                '<option value="bac_32740_gene">Bacillus cereus Q1 genes (EB 1)</option>' + 
					                '<option value="bac_20340_gene">Bacillus cereus ZK genes (EB 1)</option>' + 
					                '<option value="bac_20483_gene">Bacillus clausii genes (EB 1)</option>' + 
					                '<option value="bac_5_gene">Bacillus halodurans genes (EB 1)</option>' + 
					                '<option value="bac_20380_gene">Bacillus licheniformis Goettingen genes (EB 1)</option>' + 
					                '<option value="bac_20360_gene">Bacillus licheniformis Novozymes genes (EB 1)</option>' + 
					                '<option value="bac_29997_gene">Bacillus pumilus SAFR-032 genes (EB 1)</option>' + 
					                '<option value="bac_6_gene">Bacillus subtilis genes (EB 2)</option>' + 
					                '<option value="bac_25839_gene">Bacillus thuringiensis Al Hakam genes (EB 1)</option>' + 
					                '<option value="bac_20002_gene">Bacillus thuringiensis konkukian 97-27 genes (EB 1)</option>' + 
					                '<option value="bac_30354_gene">Bacillus weihenstephanensis genes (EB 1)</option>' + 
					                '<option value="esc_32463_gene">Escherichia coli 55989 genes (EB 1)</option>' + 
					                '<option value="esc_30585_gene">Escherichia coli Crooks genes (EB 1)</option>' + 
					                '<option value="esc_30910_gene">Escherichia coli DH10B genes (EB 1)</option>' + 
					                '<option value="esc_22574_gene">Escherichia coli DSM 5911 genes (EB 1)</option>' + 
					                '<option value="esc_18_gene">Escherichia coli K12 genes (EB 1)</option>' + 
					                '<option value="esc_31896_gene">Escherichia coli O127:H6 E2348/69 genes (EB 1)</option>' + 
					                '<option value="esc_29938_gene">Escherichia coli O139:H28 E24377A genes (EB 1)</option>' + 
					                '<option value="esc_31685_gene">Escherichia coli O157:H7 EC4115 genes (EB 1)</option>' + 
					                '<option value="esc_19_gene">Escherichia coli O157:H7 genes (EB 1)</option>' + 
					                '<option value="esc_32471_gene">Escherichia coli O17:K52:H18 UMN026 genes (EB 1)</option>' + 
					                '<option value="esc_25686_gene">Escherichia coli O1:K1 / APEC genes (EB 1)</option>' + 
					                '<option value="esc_32467_gene">Escherichia coli O45:K1 S88 genes (EB 1)</option>' + 
					                '<option value="esc_110_gene">Escherichia coli O6 ATCC 700928 genes (EB 1)</option>' + 
					                '<option value="esc_25405_gene">Escherichia coli O6:K15:H31 536 genes (EB 1)</option>' + 
					                '<option value="esc_32473_gene">Escherichia coli O7:K1 IAI39 genes (EB 1)</option>' + 
					                '<option value="esc_32465_gene">Escherichia coli O8 IAI1 genes (EB 1)</option>' + 
					                '<option value="esc_32469_gene">Escherichia coli O81 ED1a genes (EB 1)</option>' + 
					                '<option value="esc_29940_gene">Escherichia coli O9:H4 HS genes (EB 1)</option>' + 
					                '<option value="esc_20_gene">Escherichia coli RIMD 0509952 genes (EB 1)</option>' + 
					                '<option value="esc_31791_gene">Escherichia coli SE11 genes (EB 1)</option>' + 
					                '<option value="esc_30906_gene">Escherichia coli SMS-3-5 genes (EB 1)</option>' + 
					                '<option value="esc_23099_gene">Escherichia coli UTI89 genes (EB 1)</option>' + 
					                '<option value="esc_32413_gene">Escherichia fergusonii genes (EB 1)</option>' + 
					                '<option value="myc_30878_gene">Mycobacterium abscessus genes (EB 1)</option>' + 
					                '<option value="myc_25829_gene">Mycobacterium avium genes (EB 1)</option>' + 
					                '<option value="myc_138_gene">Mycobacterium bovis AF2122/97 genes (EB 1)</option>' + 
					                '<option value="myc_25994_gene">Mycobacterium bovis BCG genes (EB 1)</option>' + 
					                '<option value="myc_29236_gene">Mycobacterium gilvum genes (EB 1)</option>' + 
					                '<option value="myc_32549_gene">Mycobacterium leprae Br4923 genes (EB 1)</option>' + 
					                '<option value="myc_29_gene">Mycobacterium leprae TN genes (EB 1)</option>' + 
					                '<option value="myc_30990_gene">Mycobacterium marinum genes (EB 1)</option>' + 
					                '<option value="myc_679_gene">Mycobacterium paratuberculosis genes (EB 1)</option>' + 
					                '<option value="myc_25827_gene">Mycobacterium smegmatis genes (EB 1)</option>' + 
					                '<option value="myc_28710_gene">Mycobacterium sp. JLS genes (EB 1)</option>' + 
					                '<option value="myc_25946_gene">Mycobacterium sp. KMS genes (EB 1)</option>' + 
					                '<option value="myc_25058_gene">Mycobacterium sp. MCS genes (EB 1)</option>' + 
					                '<option value="myc_29397_gene">Mycobacterium tuberculosis ATCC 25177 genes (EB 1)</option>' + 
					                '<option value="myc_53_gene">Mycobacterium tuberculosis CDC1551 genes (EB 1)</option>' + 
					                '<option value="myc_30_gene">Mycobacterium tuberculosis H37Rv genes (EB 1)</option>' + 
					                '<option value="myc_25870_gene">Mycobacterium ulcerans genes (EB 1)</option>' + 
					                '<option value="myc_25929_gene">Mycobacterium vanbaalenii genes (EB 1)</option>' + 
					                '<option value="nei_21062_gene">Neisseria gonorrhoeae ATCC 700825 genes (EB 1)</option>' + 
					                '<option value="nei_31362_gene">Neisseria gonorrhoeae NCCP11945 genes (EB 1)</option>' + 
					                '<option value="nei_25970_gene">Neisseria meningitidis 2a genes (EB 1)</option>' + 
					                '<option value="nei_33_gene">Neisseria meningitidis A 4A genes (EB 1)</option>' + 
					                '<option value="nei_34_gene">Neisseria meningitidis B genes (EB 1)</option>' + 
					                '<option value="nei_30315_gene">Neisseria meningitidis C genes (EB 1)</option>' + 
					                '<option value="pyr_37_gene">Pyrococcus abyssi Orsay genes (EB 1)</option>' + 
					                '<option value="pyr_77_gene">Pyrococcus furiosus genes (EB 1)</option>' + 
					                '<option value="pyr_38_gene">Pyrococcus horikoshii genes (EB 1)</option>' + 
					                '<option value="pyr_21106_gene">Pyrococcus kodakaraensis genes (EB 1)</option>' + 
					                '<option value="esc_31033_gene">Shigella boydii 18 genes (EB 1)</option>' + 
					                '<option value="esc_22433_gene">Shigella boydii 4 genes (EB 1)</option>' + 
					                '<option value="esc_22435_gene">Shigella dysenteriae genes (EB 1)</option>' + 
					                '<option value="esc_132_gene">Shigella flexneri 2457T genes (EB 1)</option>' + 
					                '<option value="esc_103_gene">Shigella flexneri 301 genes (EB 1)</option>' + 
					                '<option value="esc_25763_gene">Shigella flexneri 8401 genes (EB 1)</option>' + 
					                '<option value="esc_22108_gene">Shigella sonnei genes (EB 1)</option>' + 
					                '<option value="sta_29960_gene">Staphylococcus aureus ATCC 700698 genes (EB 1)</option>' + 
					                '<option value="sta_51_gene">Staphylococcus aureus ATCC 700699 genes (EB 1)</option>' + 
					                '<option value="sta_20863_gene">Staphylococcus aureus COL genes (EB 1)</option>' + 
					                '<option value="sta_22485_gene">Staphylococcus aureus ET3-1 genes (EB 1)</option>' + 
					                '<option value="sta_29522_gene">Staphylococcus aureus JH1 genes (EB 1)</option>' + 
					                '<option value="sta_29377_gene">Staphylococcus aureus JH9 genes (EB 1)</option>' + 
					                '<option value="sta_19583_gene">Staphylococcus aureus MRSA252 genes (EB 1)</option>' + 
					                '<option value="sta_19585_gene">Staphylococcus aureus MSSA476 genes (EB 1)</option>' + 
					                '<option value="sta_86_gene">Staphylococcus aureus MW2 genes (EB 1)</option>' + 
					                '<option value="sta_50_gene">Staphylococcus aureus N315 genes (EB 1)</option>' + 
					                '<option value="sta_22608_gene">Staphylococcus aureus NCTC 8325 genes (EB 1)</option>' + 
					                '<option value="sta_29553_gene">Staphylococcus aureus Newman genes (EB 1)</option>' + 
					                '<option value="sta_30215_gene">Staphylococcus aureus TCH1516 genes (EB 1)</option>' + 
					                '<option value="sta_22602_gene">Staphylococcus aureus USA300 genes (EB 1)</option>' + 
					                '<option value="sta_32748_gene">Staphylococcus carnosus genes (EB 1)</option>' + 
					                '<option value="sta_113_gene">Staphylococcus epidermidis ATCC 12228 genes (EB 1)</option>' + 
					                '<option value="sta_20865_gene">Staphylococcus epidermidis ATCC 35984 genes (EB 1)</option>' + 
					                '<option value="sta_21825_gene">Staphylococcus haemolyticus genes (EB 1)</option>' + 
					                '<option value="sta_22064_gene">Staphylococcus saprophyticus genes (EB 1)</option>' + 
					                '<option value="str_98_gene">Streptococcus agalactiae III genes (EB 1)</option>' + 
					                '<option value="str_22229_gene">Streptococcus agalactiae Ia genes (EB 1)</option>' + 
					                '<option value="str_95_gene">Streptococcus agalactiae V genes (EB 1)</option>' + 
					                '<option value="str_32985_gene">Streptococcus equi 4047 genes (EB 1)</option>' + 
					                '<option value="str_31483_gene">Streptococcus equi MGCS10565 genes (EB 1)</option>' + 
					                '<option value="str_32993_gene">Streptococcus equi zooepidemicus genes (EB 1)</option>' + 
					                '<option value="str_29962_gene">Streptococcus gordonii genes (EB 1)</option>' + 
					                '<option value="str_102_gene">Streptococcus mutans genes (EB 1)</option>' + 
					                '<option value="str_32547_gene">Streptococcus pneumoniae ATCC 700669 genes (EB 1)</option>' + 
					                '<option value="str_64_gene">Streptococcus pneumoniae ATCC BAA-255 genes (EB 1)</option>' + 
					                '<option value="str_30894_gene">Streptococcus pneumoniae CGSP14 genes (EB 1)</option>' + 
					                '<option value="str_25749_gene">Streptococcus pneumoniae D39 genes (EB 1)</option>' + 
					                '<option value="str_31634_gene">Streptococcus pneumoniae G54 genes (EB 1)</option>' + 
					                '<option value="str_30555_gene">Streptococcus pneumoniae Hungary19A-6 genes (EB 1)</option>' + 
					                '<option value="str_57_gene">Streptococcus pneumoniae TIGR4 genes (EB 1)</option>' + 
					                '<option value="str_22007_gene">Streptococcus pyogenes M1 MGAS5005 genes (EB 1)</option>' + 
					                '<option value="str_49_gene">Streptococcus pyogenes M1 SF370 genes (EB 1)</option>' + 
					                '<option value="str_80_gene">Streptococcus pyogenes M18 MGAS8232 genes (EB 1)</option>' + 
					                '<option value="str_21980_gene">Streptococcus pyogenes M28 MGAS6180 genes (EB 1)</option>' + 
					                '<option value="str_93_gene">Streptococcus pyogenes M3 ATCC BAA-595 genes (EB 1)</option>' + 
					                '<option value="str_125_gene">Streptococcus pyogenes M3 SSI-1 genes (EB 1)</option>' + 
					                '<option value="str_20460_gene">Streptococcus pyogenes M6 ATCC BAA-946 genes (EB 1)</option>' + 
					                '<option value="str_23168_gene">Streptococcus pyogenes MGAS10270 genes (EB 1)</option>' + 
					                '<option value="str_23164_gene">Streptococcus pyogenes MGAS10750 genes (EB 1)</option>' + 
					                '<option value="str_23166_gene">Streptococcus pyogenes MGAS2096 genes (EB 1)</option>' + 
					                '<option value="str_23162_gene">Streptococcus pyogenes MGAS9429 genes (EB 1)</option>' + 
					                '<option value="str_26037_gene">Streptococcus pyogenes Manfredo genes (EB 1)</option>' + 
					                '<option value="str_31734_gene">Streptococcus pyogenes NZ131 genes (EB 1)</option>' + 
					                '<option value="str_28432_gene">Streptococcus sanguinis genes (EB 1)</option>' + 
					                '<option value="str_29285_gene">Streptococcus suis 05ZYH33 genes (EB 1)</option>' + 
					                '<option value="str_29287_gene">Streptococcus suis 98HAH33 genes (EB 1)</option>' + 
					                '<option value="str_20662_gene">Streptococcus thermophilus ATCC BAA-250 genes (EB 1)</option>' + 
					                '<option value="str_25787_gene">Streptococcus thermophilus ATCC BAA-491 genes (EB 1)</option>' + 
					                '<option value="str_20664_gene">Streptococcus thermophilus CNRZ 1066 genes (EB 1)</option>' + 
					                '<option value="str_32760_gene">Streptococcus uberis genes (EB 1)</option></select>';
			var mapping:XML = XML(biomartSelect);
			var options:XMLList = mapping.option;
			
			for each (var option:XML in options){
				if (this._parseName(option) == genomeEnsemblId){
					biomartName = option.@value;
					break;
				}
			}
			return biomartName;
		}
		
		
		private function _parseName(object:Object):String
		{
			var name:String = object.toString();
			
			
			var pattern1:RegExp = / /g;
			var pattern2:RegExp = /Streptococcus/g;
			var pattern3:RegExp = /Pyrococcus/g;
			var pattern4:RegExp = /Neisseria/g;
			var pattern5:RegExp = /Mycobacterium/g;
			var pattern6:RegExp = /Escherichia/g;
			var pattern7:RegExp = /Bacillus/g;
			var pattern8:RegExp = /Staphylococcus/g;
			var pattern9:RegExp = /Shigella/g;
			var pattern10:RegExp = /_genes_\(EB_1\)/g;

		
			name = name.replace(pattern1,"_");
			name = name.replace(pattern2,"S");
			name = name.replace(pattern3,"P");
			name = name.replace(pattern4,"N");
			name = name.replace(pattern5,"M");
			name = name.replace(pattern6,"E");
			name = name.replace(pattern7,"B");
			name = name.replace(pattern8,"S");
			name = name.replace(pattern9,"S");
			name = name.replace(pattern10,".EB1");
			
			return name	
		}
		
	}
}