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
	case 'reporte_reclamos':
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
						 ->setTitle("Impresión de Reclamos")
						 ->setSubject("Impresión de Reclamos");
		
		$objPHPExcel->setActiveSheetIndex(0);
		
		$objPHPExcel->getActiveSheet()->getPageSetup()->setOrientation(PHPExcel_Worksheet_PageSetup::ORIENTATION_LANDSCAPE);
		$objPHPExcel->getActiveSheet()->getPageSetup()->setPaperSize(PHPExcel_Worksheet_PageSetup::PAPERSIZE_A4);
		
		$objPHPExcel->getActiveSheet()->mergeCells('A2:D2');
		
		// Set fonts
		$objPHPExcel->getActiveSheet()->getStyle('C1:D1')->getFont()->setBold(true);
		
		$objPHPExcel->getActiveSheet()->getStyle('A2')->getFont()->setSize(16);
		$objPHPExcel->getActiveSheet()->getStyle('A2')->getFont()->setBold(true);	
		$objPHPExcel->getActiveSheet()->setCellValue('A2', 'Reclamos');
		$objPHPExcel->getActiveSheet()->getStyle('A2')->getFont()->getColor()->setARGB(PHPExcel_Style_Color::COLOR_BLACK);			
		$objPHPExcel->getActiveSheet()->getStyle('A2:D2')->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
		$objPHPExcel->getActiveSheet()->getStyle('A2:D2')->getFill()->getStartColor()->setARGB('297C98');
		
		$objPHPExcel->getActiveSheet()->mergeCells('A1:D1');
		
		// Escribir fecha del reporte
		$date = date("d/m/Y");
		$objPHPExcel->getActiveSheet()->setCellValue('A1', 'Fecha: ' . $date);		
		
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
		$objPHPExcel->getActiveSheet()->getStyle('A2:D2')->applyFromArray($styleFill);
		
		$sql="SELECT * FROM docentes JOIN docentes_llamados USING(id_docente) ";
		$sql.="JOIN tipos_documentos USING(id_tipo_doc) ";
		$sql.="WHERE id_docente_llamado = '$id_docente_llamado'";
		
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$row = mysqli_fetch_array($result);
		
		$apellido = $row['apellido'];
		$nombres = $row['nombres'];
		$tipo_doc = $row['tipo_doc'];
		$nro_doc = $row['nro_doc'];
		
		$objPHPExcel->getActiveSheet()->setCellValue('A2','RECLAMOS DEL DOCENTE');
		
		$objPHPExcel->getActiveSheet()->mergeCells('A3:D3');
		$objPHPExcel->getActiveSheet()->mergeCells('A4:D4');
				
	    $objPHPExcel->getActiveSheet()->setCellValue('A3','DOCENTE: ' . $apellido . ', ' . $nombres);	        
	    $objPHPExcel->getActiveSheet()->setCellValue('A4','DNI: ' . $nro_doc);		
							 
		//$objPHPExcel->getActiveSheet()->getColumnDimension('A')->setWidth(15);
		$objPHPExcel->getActiveSheet()->getColumnDimension('A')->setWidth(30);
		$objPHPExcel->getActiveSheet()->getColumnDimension('B')->setWidth(12);
		$objPHPExcel->getActiveSheet()->getColumnDimension('C')->setWidth(70);
		$objPHPExcel->getActiveSheet()->getColumnDimension('D')->setWidth(12);				
		
		$sql="SELECT id_reclamo, id_docentes_llamado, id_reclamo_entrada, id_reclamo_respuesta, e.descripcion 'motivo', ";
	  	$sql.="r.descripcion 'respuesta', DATE_FORMAT(fecha_reclamo,'%d/%m/%Y') 'fecha_reclamo', DATE_FORMAT(fecha_respuesta,'%d/%m/%Y') 'fecha_respuesta', observaciones_reclamo, observaciones_respuesta, estado ";	  	
		$sql.="FROM reclamos ";
		$sql.="LEFT JOIN reclamos_entrada e ON id_reclamo_entrada = id_tipo_reclamo_ent ";
		$sql.="LEFT JOIN reclamos_respuesta r ON id_reclamo_respuesta = id_tipo_reclamo_resp ";
		$sql.="WHERE id_docentes_llamado = '$id_docente_llamado' ";		
		$sql.="ORDER BY fecha_reclamo DESC";		
				
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);		
		
		// Poner línea separadora antes del total
	    $styleThinBorder = array(				
				'borders' => array(				
	 				'bottom'     => array(
	 					'style' => PHPExcel_Style_Border::BORDER_THIN 					
	 				)
				)	
		);
		
		$i=5;								
		
		while ($row = mysqli_fetch_array($result)) {		
			$i++;
			
			$objPHPExcel->getActiveSheet()->mergeCells('A'.$i.':D'.$i);
		
			$objPHPExcel->getActiveSheet()->getStyle('A'.$i.':D'.$i)->applyFromArray($styleFill);
			
			$objPHPExcel->setActiveSheetIndex(0)
							->setCellValue('A' . $i,'RECLAMO');
			
			$i++;
			
			$objPHPExcel->getActiveSheet()->getStyle('A'.$i.':D'.$i)->applyFromArray($styleNoFill);
			
			$i++;
			
			$objPHPExcel->getActiveSheet()->mergeCells('A'.$i.':D'.$i);
			
			$objPHPExcel->getActiveSheet()->getStyle('A'.$i)->getFont()->setBold(true);
			
			$objPHPExcel->setActiveSheetIndex(0)
							->setCellValue('A' . $i,'FECHA: ' . $row['fecha_reclamo']);
			
			$i++;
			
			$objPHPExcel->getActiveSheet()->mergeCells('A'.$i.':D'.$i);
			
			$objPHPExcel->getActiveSheet()->getStyle('A'.$i)->getFont()->setBold(true);
			
			$objPHPExcel->setActiveSheetIndex(0)
							->setCellValue('A' . $i,'MOTIVO');																
			
			$i++;
			
			$objPHPExcel->getActiveSheet()->mergeCells('A'.$i.':D'.$i);
			 
			$objPHPExcel->setActiveSheetIndex(0)
							->setCellValue('A' . $i,$row['motivo']);
							
			$i++;
			
			$objPHPExcel->getActiveSheet()->mergeCells('A'.$i.':D'.$i);
			
			$objPHPExcel->getActiveSheet()->getStyle('A'.$i)->getFont()->setBold(true);
			
			$objPHPExcel->setActiveSheetIndex(0)
							->setCellValue('A' . $i,'RESPUESTA');																
			
			$i++;
			
			$objPHPExcel->getActiveSheet()->mergeCells('A'.$i.':D'.$i);
			 
			$objPHPExcel->setActiveSheetIndex(0)
							->setCellValue('A' . $i,$row['respuesta']);
		}
		
		$i++;        
		
		for ($c = 0;$c <= 3;$c++) {
			$objPHPExcel->getActiveSheet()->getStyleByColumnAndRow($c,$i-1)->applyFromArray($styleThinBorder);	
		}
		
		$i++;
	
		$objPHPExcel->getActiveSheet()->mergeCells("A$i:D$i");
		
		$objPHPExcel->setActiveSheetIndex(0)						
							->setCellValue('A' . $i,'OPERADOR: ' . $_SESSION['usuario_nombre']);	    
	    
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
