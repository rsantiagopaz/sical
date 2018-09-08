<?php
/*
 * Created on 21/01/2010
 *
 * To change the template for this generated file go to
 * Window - Preferences - PHPeclipse - PHP - Code Templates
 */
 
include("../control_acceso_flex.php"); 
 
error_reporting(E_ALL);

/** PHPExcel */
require_once $SYSpathraiz.'_scripts/phpLib/PHPExcel.php';

/** PHPExcel_IOFactory */
require_once $SYSpathraiz.'_scripts/phpLib/PHPExcel/IOFactory.php';

function genero_xml_ok_errores($_ok,$_errores,$otroNodoXml)
//       _______________________________________________
{
	  $xml = "<?xml version='1.0' encoding='UTF-8' ?>";
	  $xml.= "<xml>";
	  if(!empty($_ok))
		{
		 $xml.=  "<ok>$_ok</ok>";
		}
	  if(!empty($_errores))	 
		{ 
		 $xml.=  "<error>$_errores</error>";
		}	
	  $xml.=$otroNodoXml;	
	  $xml.= "</xml>";
	  header('Content-Type: text/xml');
	  print $xml;
}

/** 
 * ****************************************************************************
 *            función  R E P O R T E_P R O D U C T O R E S_D E P T O S
 * ****************************************************************************
 * 
 */
function reporte_antecedentes_docente()
{
	$_errores = '';
	$_ok='';
	$otroNodoXml = '';
	$i = 3;	
	
	// Create new PHPExcel object
	$objPHPExcel = new PHPExcel();

	// Set properties
	$objPHPExcel->getProperties()->setCreator("SiCal")
					 ->setLastModifiedBy("SiCal")
					 ->setTitle("Antecedentes Declarados")
					 ->setSubject("Antecedentes Declarados");
	
	$objPHPExcel->setActiveSheetIndex(0);
	
	$objPHPExcel->getActiveSheet()->getPageSetup()->setOrientation(PHPExcel_Worksheet_PageSetup::ORIENTATION_LANDSCAPE);
	$objPHPExcel->getActiveSheet()->getPageSetup()->setPaperSize(PHPExcel_Worksheet_PageSetup::PAPERSIZE_A4);
	
	$arraySimple = array(
					'font'    => array(
						'bold'      => false
					),
					'alignment' => array(
						'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_LEFT,
					),
					'borders' => array(
						'top'     => array(
		 					'style' => PHPExcel_Style_Border::BORDER_THIN
		 				),
		 				'bottom'     => array(
		 					'style' => PHPExcel_Style_Border::BORDER_THIN
		 				)
					)
				);
				
	$arraySimpleBold = array(
					'font'    => array(
						'bold'      => true
					),
					'alignment' => array(
						'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_LEFT,
					),
					'borders' => array(
						'top'     => array(
		 					'style' => PHPExcel_Style_Border::BORDER_THIN
		 				),
		 				'bottom'     => array(
		 					'style' => PHPExcel_Style_Border::BORDER_THIN
		 				)
					)
				);
	
	$arrayBlank = array(
					'font'    => array(
						'bold'      => true
					),
					'alignment' => array(
						'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
					),
					'borders' => array(
						'top'     => array(
		 					'style' => PHPExcel_Style_Border::BORDER_THICK
		 				),
		 				'bottom'     => array(
		 					'style' => PHPExcel_Style_Border::BORDER_THICK
		 				)
					)
				);
				
	$arrayBlankNoTop = array(
					'font'    => array(
						'bold'      => true
					),
					'alignment' => array(
						'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
					),
					'borders' => array(						
		 				'bottom'     => array(
		 					'style' => PHPExcel_Style_Border::BORDER_THICK
		 				)
					)
				);
				
	$arrayBlankNoBottom = array(
					'font'    => array(
						'bold'      => true
					),
					'alignment' => array(
						'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
					),
					'borders' => array(
						'top'     => array(
		 					'style' => PHPExcel_Style_Border::BORDER_THICK
		 				)
					)
				);
				
	$arrayBlankLeft = array(
					'font'    => array(
						'bold'      => false
					),
					'alignment' => array(
						'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_LEFT,
					)
				);
	
	// Set fonts
	$objPHPExcel->getActiveSheet()->getStyle('C1:E1')->getFont()->setBold(true);
	
	$objPHPExcel->getActiveSheet()->getStyle('A1:E1')->applyFromArray($arrayBlank);
	
	// Escribir fecha del reporte
	$date = date("d/m/Y");
	$objPHPExcel->getActiveSheet()->setCellValue('C1', 'Fecha:');
	$objPHPExcel->getActiveSheet()->setCellValue('D1', $date);
	
	$objPHPExcel->getActiveSheet()->mergeCells('A2:E2');		
	
	$objPHPExcel->getActiveSheet()->getStyle('A2')->getFont()->setSize(16);
	$objPHPExcel->getActiveSheet()->getStyle('A2')->getFont()->setBold(true);	
	$objPHPExcel->getActiveSheet()->setCellValue('A2', 'Antecedentes Declarados por el Docente');
	$objPHPExcel->getActiveSheet()->getStyle('A2')->getFont()->getColor()->setARGB(PHPExcel_Style_Color::COLOR_WHITE);			
	$objPHPExcel->getActiveSheet()->getStyle('A2:E2')->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
	$objPHPExcel->getActiveSheet()->getStyle('A2:E2')->getFill()->getStartColor()->setARGB('297C98');
	
	// Set style for header row using alternative method
	$objPHPExcel->getActiveSheet()->getStyle('A2:E2')->applyFromArray(
		array(
			'font'    => array(
				'bold'      => true
			),
			'alignment' => array(
				'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
			),
			'borders' => array(
				'top'     => array(
 					'style' => PHPExcel_Style_Border::BORDER_THICK
 				),
 				'bottom'     => array(
 					'style' => PHPExcel_Style_Border::BORDER_THICK
 				)
			),
			'fill' => array(
	 			'type'       => PHPExcel_Style_Fill::FILL_GRADIENT_LINEAR,
	  			'rotation'   => 90,
	 			'startcolor' => array(
	 				'argb' => 'FFA0A0A0'
	 			),
	 			'endcolor'   => array(
	 				'argb' => 'FFFFFFFF'
	 			)
	 		)
		)
	);		
	
	// Set alignments
	$objPHPExcel->getActiveSheet()->getStyle('A3:E3')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
	
	$objPHPExcel->getActiveSheet()->getStyle('A3:E3')->applyFromArray($arrayBlank);		
	
	$sql = "SELECT apellido, nombres, tipo_doc, nro_doc FROM docentes " .
			"JOIN tipos_documentos USING(id_tipo_doc) JOIN docentes_llamados USING(id_docente) " .
			"WHERE id_docente_llamado = '".$_REQUEST['id_docente_llamado']."'";
			
	$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
	$row = mysqli_fetch_array($result);
	
	$objPHPExcel->getActiveSheet()->getStyle('A3:E3')->getFont()->setSize(14);
			
    $objPHPExcel->getActiveSheet()->setCellValue('A3','DOCENTE:');
    $objPHPExcel->getActiveSheet()->setCellValue('B3',$row['apellido'] . ', ' . $row['nombres']);    
    $objPHPExcel->getActiveSheet()->setCellValue('C3',$row['tipo_doc'] . ':');
    $objPHPExcel->getActiveSheet()->setCellValue('D3',$row['nro_doc']); 
    
    $objPHPExcel->getActiveSheet()->getStyle('A4:E4')->applyFromArray($arraySimple);
    
    if ($_REQUEST['idNivel'] == '1' || $_REQUEST['idNivel'] == '2') {    
    	$sql = "SELECT id_region FROM docentes_llamados WHERE id_docente_llamado = '".$_REQUEST['id_docente_llamado']."'";
    	
    	$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$row = mysqli_fetch_array($result);
		
		$array_regiones = array('1','2','3','4','5','6','7','8');				
		
		if (in_array($row['id_region'],$array_regiones)) {			
			$objPHPExcel->setActiveSheetIndex(0)
					->setCellValue('A4','N° REGIÓN:')            				
					->setCellValue('B4',$row['id_region']);	
		}
    }
	
						 
	$objPHPExcel->getActiveSheet()->getColumnDimension('A')->setWidth(15);
	$objPHPExcel->getActiveSheet()->getColumnDimension('B')->setWidth(75);
	$objPHPExcel->getActiveSheet()->getColumnDimension('C')->setWidth(15);
	$objPHPExcel->getActiveSheet()->getColumnDimension('D')->setWidth(12);
	$objPHPExcel->getActiveSheet()->getColumnDimension('E')->setWidth(12);
	/*$objPHPExcel->getActiveSheet()->getColumnDimension('F')->setWidth(25);*/		
	
	$sql = "SELECT * FROM docentes_llamados_titulos " .
			"JOIN titulos USING(id_titulo) " .
			"WHERE id_docente_llamado = '".$_REQUEST['id_docente_llamado']."'";
	
	$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
	
	// Poner línea separadora antes del total
    $styleThinBorder = array(				
			'borders' => array(				
 				'bottom'     => array(
 					'style' => PHPExcel_Style_Border::BORDER_THIN 					
 				)
			)	
	);
	
	$i=4;
	
	while ($row = mysqli_fetch_array($result)) {		
		$i++;
		
		$objPHPExcel->getActiveSheet()->getStyle('A' . $i . ':E' . $i)->applyFromArray($arrayBlankNoBottom);
		
		$objPHPExcel->setActiveSheetIndex(0)
					->setCellValue('A' . $i,'TÍTULO:')            				
					->setCellValue('B' . $i,$row['denominacion']);
		
		$i++;
		
		$objPHPExcel->getActiveSheet()->getStyle('A' . $i . ':E' . $i)->applyFromArray($arrayBlankNoTop);
		
		$objPHPExcel->setActiveSheetIndex(0)
					->setCellValue('A' . $i,'CÓDIGO:')            				
					->setCellValue('B' . $i,$row['codigo']);
					
		$i++;
		
		$objPHPExcel->getActiveSheet()->getStyle('A' . $i . ':E' . $i)->applyFromArray($arraySimple);
		
		$objPHPExcel->setActiveSheetIndex(0)
					->setCellValue('A' . $i,'ANTECEDENTES');
					
		$i++;				
		
		$objPHPExcel->getActiveSheet()->getStyle('A' . $i . ':E' . $i)->applyFromArray($arraySimpleBold);
					
		$objPHPExcel->setActiveSheetIndex(0)
						->setCellValue('B' . $i,'Código')            				
						->setCellValue('C' . $i,'Cantidad')
						->setCellValue('D' . $i,'Puntaje')
						->setCellValue('E' . $i,'Ac. Hist.');
						/*->setCellValue('F' . $i,'Puntaje Reconocido');*/
		
		$sql2 = "SELECT * FROM docentes_llamados_titulos_antecedentes " .
				"JOIN antecedentes USING(id_antecedente) " .
				"WHERE id_docente_llamado_titulo = '".$row['id_docente_llamado_titulo']."'";
				
		$result2 = mysqli_query($GLOBALS["___mysqli_ston"], $sql2);
		
		$total_puntos_antecedente_titulo = 0;		
		while ($row2 = mysqli_fetch_array($result2)) {		
			$i++;
			
			$objPHPExcel->getActiveSheet()->getStyle('A' . $i . ':E' . $i)->applyFromArray($arrayBlankLeft);					
			
			$objPHPExcel->getActiveSheet()->getStyle('C' . $i . ':D' . $i)->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
			
			$objPHPExcel->getActiveSheet()->getStyle('C' . $i)->getNumberFormat()
->setFormatCode('#.##');
			
			$objPHPExcel->getActiveSheet()->getStyle('E' . $i)->getNumberFormat()
->setFormatCode('#.##');

			for ($c = 1;$c <= 4;$c++) {
				$objPHPExcel->getActiveSheet()->getStyleByColumnAndRow($c,$i)->applyFromArray($styleThinBorder);	
			}
				 
			$objPHPExcel->setActiveSheetIndex(0)
						->setCellValue('B' . $i,$row2['codigo'])            				
						->setCellValue('C' . $i,$row2['unidades'])
						->setCellValue('D' . $i,$row2['puntos'])
						->setCellValue('E' . $i,$row2['acum_historico']);
						/*->setCellValue('F' . $i,$puntaje_reconocido);*/
		}
		/*$i++;
		$objPHPExcel->getActiveSheet()->getStyle('F' . $i)->getNumberFormat()
->setFormatCode('#.##');
		$objPHPExcel->getActiveSheet()->getStyle('E' . $i . ':' . 'F' . $i)->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
		$objPHPExcel->setActiveSheetIndex(0)						
						->setCellValue('E' . $i,'TOTAL:')
						->setCellValue('F' . $i,$total_puntos_antecedente_titulo);*/
	}
	
	$i++;        
	
	for ($c = 0;$c <= 4;$c++) {
		$objPHPExcel->getActiveSheet()->getStyleByColumnAndRow($c,$i-1)->applyFromArray($styleThinBorder);	
	}
	
	$objPHPExcel->getActiveSheet()->mergeCells("A$i:E$i");		
	
	if ($_REQUEST['idNivel'] == '1' || $_REQUEST['idNivel'] == '2' || $_REQUEST['idNivel'] == '5') {
		$sql="SELECT * FROM docentes_llamados_cargos JOIN cargos USING(id_cargo) WHERE id_docente_llamado = '".$_REQUEST['id_docente_llamado']."'";
		$result=mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$objPHPExcel->getActiveSheet()->mergeCells("A$i:E$i");
		$objPHPExcel->setActiveSheetIndex(0)						
						->setCellValue('A' . $i,'CARGOS');												

		if ($_REQUEST['idNivel'] == '1' || $_REQUEST['idNivel'] == '2') {
			while ($row = mysqli_fetch_array($result)) {
				$i++;
				$objPHPExcel->getActiveSheet()->mergeCells("B$i:E$i");
				$objPHPExcel->setActiveSheetIndex(0)
							->setCellValue('B' . $i,$row['denominacion'] . " (CÓDIGO: ".$row['codigo'].")");
			}
		} else {
			while ($row = mysqli_fetch_array($result)) {
				switch ($row['subtipo']) {
					case 'E': {
						$modalidad='ESPECIAL';
						break;
					}
					case 'A': {
						$modalidad='ADULTOS';
						break;
					}
					case 'C': {
						$modalidad='CAPACITACIÓN';
						break;
					}
				}
				$i++;
				$objPHPExcel->getActiveSheet()->mergeCells("B$i:E$i");
				$objPHPExcel->setActiveSheetIndex(0)
							->setCellValue('B' . $i,$row['denominacion'] . " (CÓDIGO: ".$row['codigo'].", MODALIDAD: $modalidad)");
			}			
		}		
	} else {
		$sql="SELECT * FROM docentes_llamados_escuelas JOIN escuelas USING(id_escuela) WHERE id_docente_llamado = '".$_REQUEST['id_docente_llamado']."'";
		$result=mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$objPHPExcel->getActiveSheet()->mergeCells("A$i:D$i");
		$objPHPExcel->setActiveSheetIndex(0)						
						->setCellValue('A' . $i,'ESTABLECIMIENTOS');												
												
		while ($row = mysqli_fetch_array($result)) {
			$i++;
			$objPHPExcel->getActiveSheet()->getStyle('A' . $i . ':D' . $i)->applyFromArray($arrayBlankLeft);
			for ($c = 1;$c <= 3;$c++) {
				$objPHPExcel->getActiveSheet()->getStyleByColumnAndRow($c,$i)->applyFromArray($styleThinBorder);	
			}
			$objPHPExcel->getActiveSheet()->mergeCells("B$i:E$i");
			$objPHPExcel->setActiveSheetIndex(0)
						->setCellValue('B' . $i,$row['nombre'] . " (CÓDIGO: ".$row['codigo'].")");
		}
	}
	
	$i++;        
	
	for ($c = 0;$c <= 4;$c++) {
		$objPHPExcel->getActiveSheet()->getStyleByColumnAndRow($c,$i-1)->applyFromArray($styleThinBorder);	
	}
	
	$objPHPExcel->getActiveSheet()->mergeCells("A$i:E$i");
	
	$objPHPExcel->getActiveSheet()->getStyle('A' . $i . ':E' . $i)->applyFromArray($arrayBlankLeft);
	
	$i++;
	
	$objPHPExcel->getActiveSheet()->mergeCells("A$i:E$i");
	
	$objPHPExcel->setActiveSheetIndex(0)						
						->setCellValue('A' . $i,'OPERADOR: ' . $_SESSION['usuario_nombre']);
	
	// Poner el valor del total
	/*$objPHPExcel->getActiveSheet()->getStyle('D' . $i)->getFont()->setBold(true);
	$objPHPExcel->getActiveSheet()->getStyle('E' . $i)->getFont()->setBold(true);
	$objPHPExcel->getActiveSheet()->setCellValue('D' . $i,'Total');            				
    $objPHPExcel->getActiveSheet()->setCellValue('E' . $i,$xmlReporte->grantotal);*/    
    
	// Rename sheet
	$objPHPExcel->getActiveSheet()->setTitle('Antecedentes');
	
	$objPHPExcel->getActiveSheet()->getPageSetup()->setRowsToRepeatAtTopByStartAndEnd(1, 3);
	
	$objPHPExcel->getActiveSheet()->getHeaderFooter()->setOddFooter('&L&B' . $objPHPExcel->getProperties()->getTitle() . '&RPágina &P de &N');

	// Set active sheet index to the first sheet, so Excel opens this as the first sheet
	$objPHPExcel->setActiveSheetIndex(0);

	$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'HTML');
	$objWriter->setSheetIndex(0);
	//$objWriter->setImagesRoot('http://www.example.com');
	$objWriter->save('php://output');

	// Redirect output to a client’s web browser (Excel2007)
	/*header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
	header('Content-Disposition: attachment;filename="reporte.xlsx"');
	header('Cache-Control: max-age=0');
	
	$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel2007');
	$objWriter->save('php://output');*/
	
	/*header('Content-type: application/pdf'); 
	header('Content-disposition: attachment; filename="reporte.pdf"');
	header('Cache-Control: max-age=0');
	
	$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'PDF');
	$objWriter->setSheetIndex(0);
	$objWriter->save('php://output');*/
	
	exit;
}

/**
 * ***************************************************************************
 *                    función  I N I C I O 
 * ***************************************************************************
 */
function inicio()
{		
	$rutina = $_REQUEST['rutina'];	
	switch($rutina)
	 {
//---------------------------------------------------------------------------------------------------
		case "reporte_antecedentes_docente":
//---------------------------------------------------------------------------------------------------
		{						
			reporte_antecedentes_docente();			
			break;
		}
//---------------------------------------------------------------------------------------------------
		default:
//---------------------------------------------------------------------------------------------------		
			break;
	} // del switch
} // de la función

inicio();
?>
