package context.components.proteins.notes
{
	import context.Context;
	
	import mx.containers.Canvas;
	import mx.containers.VBox;
	import mx.controls.Alert;
	import mx.controls.Text;

	public class PersonalNotesClass extends Canvas
	{
		public var parentContext:Context;
		public var uniprotId:String;
		public var noteText:Text;
					
		
		public function PersonalNotesClass()
		{
			super();
		}
		
		public function render():void
		{
			if (!parentContext.uniprotId)
				Alert.show("Please select a protein","Alert");
			else{
				parentContext.workBox.removeAllChildren();
				uniprotId = parentContext.uniprotId;
				parentContext.workBox.addChild(this);
				noteText.htmlText = "";				
				getNotes();
			}
		}
		
		private function getNotes():void
		{
			var note:String;
			switch (uniprotId){
			
				case "Q05397":	
					note = "<p>* FAK is a validated cancer target. *</p>" +
					"<p>* FAK is frequently overexpressed in tumours and there is a high correlation between FAK overexpression and invasiveness of tumours/poor prognosis in patients. </p>" + 
					"<p>* FAK is different to several other cancer targets in the following way: Many cancer targets (e.g. PI3K, Ras, JAK, MET, Src ...) are frequently mutated in cancers. Targeting these mutated proteins will probably only cure patients that carry these mutations, resulting in highly tailored therapies. In contrast there is no cancer causing mutation known for FAK. Rather, FAK is upregulated during tumour progression, when the tumour acquires an invasive phenotype. This mechanism appears to occur frequently in many different tumours. Targeting FAK alone or in combination therapy could therefore provide a strategy to combat a variety of different malignancies. To strengthen this point, targeting FAK was shown in vivo to have impressive effects (in terms of life expectancy and/or tumour size) in mice with brain, ovarian, liver, bone, prostate, breast, pancreatic, colon, esophageal and imatinib resistant gastrointestinal stromal cancers.</p> " + 
					"<p>*FAK overexpression affects both growth and adhesion signals, hence FAK is involved in many processes required for tumor progression, e.g. tumour growth, migration/invasion and angiogenesis.</p>" + 
					"<p>* We have well established procedures in house to determine crystal structures of FAK, allowing for efficient structure guided drug design</p>" + 
					"<p>* There are two rational approaches to develop compounds that target FAK with high specificity:</p>" + 
					"<p>1) Discover non-ATP competitive compounds that stabilize autoinhibited FAK allosterically, using a FRET based conformational biosensor that can detect the autoinhibited conformation of FAK in high-throughput mode.</p>" + 
					"<p>2) Applying structure based drug design to develop ATP-competitive compounds that target a unique DFG conformation close to the active site. This concept has already proven successful for imatinib (Gleevec) that targets the DFG out conformation of Abl. However, the DFG conformation observed in FAK is unique, suggesting that highly selective compounds can be developed.</p>";
				break;
				
				case "P12931":
					note = "<p>Main Point: he has some very interesting work done in this protein.</p>" + 
							"<p>Pro:</p>" + 
							"<p>a. Is a validated target</p>" + 
							"<p>b. It  has been shown that is involved in metastasis (Massague).</p>" + 
							"<p>c. We are able to express it in large quantities with selective labeling -> structural studies possible</p>" + 
							"<p>d. We have good understanding of its activation mechanism.</p>" + 
							"<p>Cons.</p>" + 
							"<p>It is a very well known targets and there are so many other groups working on it.</p>" + 
							"<p>The idea would be to use our NMR/Computational methods to develop more selective drugs.</p>";
				break;
				
				
				case "P11362":
					note = "<p>Main point: potential new drug binding sites in allosteric patches.</p>" + 
							"<p>Pro:</p>" + 
							"<p>a. Paco Real has shown that it is a marker of malignancy in bladder cancer.</p>" + 
							"<p>b. We are starting to understand how allosteric drugs work.</p>" + 
							"<p>Cons.</p>" + 
							"<p>It is a big and complex targets on which several companies are working.</p>";
				break;
				
				case "P22607":
					note = "<p>Main point: potential new drug binding sites in allosteric patches.</p>" + 
							"<p>Pro:</p>" + 
							"<p>a. Paco Real has shown that it is a marker of malignancy in bladder cancer.</p>" + 
							"<p>b. We are starting to understand how allosteric drugs work.</p>" + 
							"<p>Cons.</p>" + 
							"<p>It is a big and complex targets on which several companies are working.</p>";
				break;
				
				
				case "Q9NYY3":
					note = "<p>Silencing occurs with very high frequency in Burkitt lymphoma (BL) but is also detected in B-cell neoplasms of other types and is associated with aberrant cytosine methylation in the CpG island located at the 5\' end of the SNK/PLK2 gene [1].</p>" + 
							"<p>Silencing is specific to malignant B cells because SNK/PLK2 was unmethylated (and expressed) in primary B lymphocytes, in EBV-immortalized B lymphoblastoid cell lines (LCLs), and in adenocarcinomas (of the breast) and squamous-cell carcinomas (of the head and neck) [1].</p>" + 
							"<p>More recent evidence reveals a novel function for Plk2 in mediating apoptosis in high grade B lymphomas [2].</p>";
				break;
				
				case "Q9H4B4":
					note = "<p>Most human tumors are p53 deficient and therefore one of the pathways leading to G1 checkpoint arrest is compromised.</p>" + 
							"<p>If the alternate pathway is also compromised by inhibition of Plk3 by a small molecule inhibitor, the tumors would be selectively killed or sensitized to low levels of standard chemotherapies.</p>";
				break;
				
				case "O00444":
					note = "<p><b>Localizes to the nucleolus, centrosomes and the cleavage furrow. Involved in centrosome maturation</b></p><br>" + 
							"<p><b>Sak expression increases gradually in S through M phase, and Sak is destroyed by APC/C dependent proteolysis.</b></p><br>" + 
							"<p><b>Sak-deficient mouse embryos arrest at E7.5 and display an increased incidence of apoptosis and anaphase arrest.</b></p>" + 
							"<p><a href='http://www.nature.com/onc/journal/v24/n2/abs/1208275a.html'>Sak/Plk4 and mitotic fidelity</a></p><br>" + 
							"<p><b>Reduced Plk4 gene dosage increases the probability of mitotic errors and cancer development.</b></p>" + 
							"<p><a href='http://www.nature.com/ng/journal/v37/n8/abs/ng1605.html'>Plk4 haploinsufficiency causes mitotic infidelity and carcinogenesis</a></p><br>" + 
							"<p><b>Seems to be mutated in some cancers</b></p>" + 
							"<p><a href='http://www.sanger.ac.uk/perl/genetics/CGP/cosmic?action=gene&ln=PLK4'>COSMIC</a></p><br>" + 
							"<p><b>Patents in the topic</b></p>" + 
							"<p><a href='http://www.wipo.int/pctdb/en/wo.jsp?WO=2009065232'>CANCER DIAGNOSTIC AND THERAPEUTIC METHODS THAT TARGET PLK4/SAK</a></p>";
				break;
				
				case "P40227":
					note = "<p>Essential for tubulin, actin, Cdh1 and Cdc20 folding and therefore for their proper function.</p>" + 
							"<p>siRNA of any of the 8 CCT subunits promotes a G1/S cell cycle arrest and cytoskleton defects Drugable pockets (all the 8 subunits are ATPases)</p>";
				break;
					
				case "P04049":
					note = 'Raf-1 Addiction in Ras-Induced Skin Carcinogenesis <a href="assets/raf-1-doc.pdf">[view article]</a><br>' + 
							'C-Raf Inhibits MAPK Activation and Transformation by B-RafV600E <a href="assets/craf-doc.pdf">[view article]</a><br>' + 
							'Molecular Basis of Cancer <a href="assets/c-Raf-doc.pptx">[view presentation]</a>';
				break;
				
				case "P11802":
						note = 'Diagnostic and Therapeutic Approaches <a href="assets/Cdk4-doc.pptx">[view presentation]</a>'
				break;	
				
				

			} 
			if (note){
					noteText.htmlText = note;
			}else{
					noteText.htmlText = "No notes found";
			}
			this.addChild(noteText);
		}
	}
}