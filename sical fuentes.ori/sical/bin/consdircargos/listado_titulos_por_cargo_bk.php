<?php
include("../control_acceso_flex.php");
include("../config.php");
include("../rutinas.php");

/** PHPExcel */
require_once $SYSpathraiz.'_scripts/phpLib/PHPExcel.php';

/** PHPExcel_IOFactory */
require_once $SYSpathraiz.'_scripts/phpLib/PHPExcel/IOFactory.php';

switch ($_REQUEST['rutina'])
{
	case 'listado_titulos':
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
						 ->setTitle("Títulos por Cargo")
						 ->setSubject("Títulos por Cargo");
		
		$objPHPExcel->setActiveSheetIndex(0);
		
		$objPHPExcel->getActiveSheet()->getPageSetup()->setOrientation(PHPExcel_Worksheet_PageSetup::ORIENTATION_LANDSCAPE);
		$objPHPExcel->getActiveSheet()->getPageSetup()->setPaperSize(PHPExcel_Worksheet_PageSetup::PAPERSIZE_A4);
		
		$objPHPExcel->getActiveSheet()->mergeCells('A2:D2');
		
		// Set fonts
		$objPHPExcel->getActiveSheet()->getStyle('C1:D1')->getFont()->setBold(true);
		
		$objPHPExcel->getActiveSheet()->getStyle('A2')->getFont()->setSize(16);
		$objPHPExcel->getActiveSheet()->getStyle('A2')->getFont()->setBold(true);	
		$objPHPExcel->getActiveSheet()->setCellValue('A2', 'Títulos por Cargo');
		$objPHPExcel->getActiveSheet()->getStyle('A2')->getFont()->getColor()->setARGB(PHPExcel_Style_Color::COLOR_BLACK);			
		$objPHPExcel->getActiveSheet()->getStyle('A2:D2')->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
		$objPHPExcel->getActiveSheet()->getStyle('A2:D2')->getFill()->getStartColor()->setARGB('297C98');
		
		// Escribir fecha del reporte
		$date = date("d/m/Y");
		$objPHPExcel->getActiveSheet()->setCellValue('C1', 'Fecha:');
		$objPHPExcel->getActiveSheet()->setCellValue('D1', $date);
		
		// Set alignments
		$objPHPExcel->getActiveSheet()->getStyle('A2:D2')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
		
		$styleFill = array(
				'font'    => array(
					'bold'      => true
				),
				'alignment' => array(
					'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
				),
				'borders' => array(
					'top'     => array(
	 					'style' => PHPExcel_Style_Border::BORDER_THIN
	 				),
	 				'bottom'     => array(
	 					'style' => PHPExcel_Style_Border::BORDER_THIN
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
			);
			
		$styleNoFill = array(				
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
		
		// Set style for header row using alternative method
		$objPHPExcel->getActiveSheet()->getStyle('A3:D3')->applyFromArray($styleFill);
		
		$sql="SELECT * FROM cargos ";				
		$sql.="LEFT JOIN niveles USING(id_nivel) ";
		$sql.="WHERE id_cargo = '$id_cargo'";		
				
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$row = mysqli_fetch_array($result);
		
		$objPHPExcel->getActiveSheet()->setCellValue('A2','Cargos por Título');
		
		$objPHPExcel->getActiveSheet()->mergeCells('A4:D4');
		
		$objPHPExcel->getActiveSheet()->getStyle('A6')->getFont()->setBold(true);
		
	    $objPHPExcel->getActiveSheet()->setCellValue('A3','CARGO');
	    $objPHPExcel->getActiveSheet()->setCellValue('A4',$row['denominacion']);    
	    $objPHPExcel->getActiveSheet()->setCellValue('A6','Nivel');
	    $objPHPExcel->getActiveSheet()->setCellValue('A7',$row['nivel']);
		
							 
		//$objPHPExcel->getActiveSheet()->getColumnDimension('A')->setWidth(15);
		$objPHPExcel->getActiveSheet()->getColumnDimension('A')->setWidth(12);
		$objPHPExcel->getActiveSheet()->getColumnDimension('B')->setWidth(55);
		$objPHPExcel->getActiveSheet()->getColumnDimension('C')->setWidth(30);
		$objPHPExcel->getActiveSheet()->getColumnDimension('D')->setWidth(15);
		
		$sql="SELECT id_tomo_cargo, id_cargo, cod_cargo, tit.codigo 'codtit', tit.denominacion 'denomtit', id_tipo_titulo, cod_tipo_titulo, tipo, id_tipo_clasificacion, ";
	  	$sql.="ca.denominacion 'denomcar', t.denominacion 'denomclas', t.codigo 'cod_tipo_clasificacion', cod_nivel, 'A' as origen ";
		$sql.="FROM tomo_cargos ";
		$sql.="INNER JOIN cargos ca USING(id_cargo) ";
		$sql.="INNER JOIN titulos tit USING(id_titulo) ";
		$sql.="INNER JOIN tipos_titulos USING(id_tipo_titulo) ";
		$sql.="INNER JOIN tipos_clasificacion t USING(id_tipo_clasificacion) ";
		$sql.="WHERE id_cargo = '$id_cargo' ";		
		$sql.="ORDER BY denomcar";
		
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		
		// Poner línea separadora antes del total
	    $styleThinBorder = array(				
				'borders' => array(				
	 				'bottom'     => array(
	 					'style' => PHPExcel_Style_Border::BORDER_THIN 					
	 				)
				)	
		);
		
		$i=8;
		
		$objPHPExcel->getActiveSheet()->getStyle('A'.$i.':D'.$i)->applyFromArray($styleFill);
		
		$objPHPExcel->setActiveSheetIndex(0)
							->setCellValue('A' . $i,'Código')
							->setCellValue('B' . $i,'Título')
							->setCellValue('C' . $i,'Tipo Clasificación')
							->setCellValue('D' . $i,'Tipo Título');
		
		while ($row = mysqli_fetch_array($result)) {		
			$i++;
			
			$objPHPExcel->getActiveSheet()->getStyle('A'.$i.':D'.$i)->applyFromArray($styleNoFill);																
					 
			$objPHPExcel->setActiveSheetIndex(0)
							->setCellValue('A' . $i,$row['codtit'])
							->setCellValue('B' . $i,$row['denomtit'])
							->setCellValue('C' . $i,$row['denomclas'])
							->setCellValue('D' . $i,$row['tipo']);										
		}
		
		$i++;        
		
		for ($c = 0;$c <= 3;$c++) {
			$objPHPExcel->getActiveSheet()->getStyleByColumnAndRow($c,$i-1)->applyFromArray($styleThinBorder);	
		}		    
	    
		// Rename sheet
		$objPHPExcel->getActiveSheet()->setTitle('Antecedentes');
		
		$objPHPExcel->getActiveSheet()->getPageSetup()->setRowsToRepeatAtTopByStartAndEnd(1, 8);
		
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
}
?>
