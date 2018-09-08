<?php
include("../control_acceso_flex.php");
//include("../config.php");
include("../rutinas.php");

error_reporting(E_ALL);

set_time_limit(240);

/** PHPExcel */
require_once $SYSpathraiz.'_scripts/phpLib/PHPExcel.php';

/** PHPExcel_IOFactory */
require_once $SYSpathraiz.'_scripts/phpLib/PHPExcel/IOFactory.php';

switch ($_REQUEST['rutina'])
{
	case 'llamados':
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
						 ->setTitle("Llamados")
						 ->setSubject("Llamados");
		
		$objPHPExcel->setActiveSheetIndex(0);
		
		$objPHPExcel->getActiveSheet()->getPageSetup()->setOrientation(PHPExcel_Worksheet_PageSetup::ORIENTATION_LANDSCAPE);
		$objPHPExcel->getActiveSheet()->getPageSetup()->setPaperSize(PHPExcel_Worksheet_PageSetup::PAPERSIZE_A4);
		
		$objPHPExcel->getActiveSheet()->mergeCells('A2:D2');
		
		// Set fonts
		$objPHPExcel->getActiveSheet()->getStyle('C1')->getFont()->setBold(true);
		
		$sql = "SELECT nivel FROM niveles WHERE id_nivel = '$SYSusuario_nivel_id'";
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$row = mysqli_fetch_array($result);
		$nivel = $row['nivel'];
		
		$objPHPExcel->getActiveSheet()->getStyle('A2')->getFont()->setSize(16);
		$objPHPExcel->getActiveSheet()->getStyle('A2')->getFont()->setBold(true);	
		$objPHPExcel->getActiveSheet()->setCellValue('A2', 'Llamados de Nivel ' . $nivel);
		$objPHPExcel->getActiveSheet()->getStyle('A2')->getFont()->getColor()->setARGB(PHPExcel_Style_Color::COLOR_BLACK);			
		$objPHPExcel->getActiveSheet()->getStyle('A2:D2')->getFill()->setFillType(PHPExcel_Style_Fill::FILL_SOLID);
		$objPHPExcel->getActiveSheet()->getStyle('A2:D2')->getFill()->getStartColor()->setARGB('297C98');
		
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
		
		$objPHPExcel->getActiveSheet()->getStyle('A1:D1')->applyFromArray($styleNoFill);
		// Escribir fecha del reporte
		$date = date("d/m/Y");
		$objPHPExcel->getActiveSheet()->setCellValue('D1', 'Fecha: ' . $date);		
		
		// Set alignments
		$objPHPExcel->getActiveSheet()->getStyle('A2:D2')->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
		
		$styleFill = array(
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
		
		// Set style for header row using alternative method
		$objPHPExcel->getActiveSheet()->getStyle('A3:D3')->applyFromArray($styleFill);
		
		$sql="SELECT id_llamado, nro_llamado, descripcion, id_tipo_clasificacion 'tipo_clasificacion', oculto, id_nivel, nivel, ";
	  	$sql.="DATE_FORMAT(fecha_desde,'%d/%m/%Y') 'fecha_desde', ";
	  	$sql.="DATE_FORMAT(fecha_hasta,'%d/%m/%Y') 'fecha_hasta' ";
		$sql.="FROM llamados ";
		$sql.="INNER JOIN niveles USING(id_nivel) ";
		$sql.="WHERE descripcion LIKE '%$filter%' ";
		$sql.="AND id_nivel = '$SYSusuario_nivel_id' ";		
		$sql.="ORDER BY id_llamado DESC LIMIT 1000";				
				
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);						
		
		$objPHPExcel->getActiveSheet()->setCellValue('A3','Número');
	    $objPHPExcel->getActiveSheet()->setCellValue('B3','Denominación');    
	    $objPHPExcel->getActiveSheet()->setCellValue('C3','Desde');
	    $objPHPExcel->getActiveSheet()->setCellValue('D3','Hasta');
									 		
		$objPHPExcel->getActiveSheet()->getColumnDimension('A')->setWidth(20);
		$objPHPExcel->getActiveSheet()->getColumnDimension('B')->setWidth(70);
		$objPHPExcel->getActiveSheet()->getColumnDimension('C')->setWidth(25);
		$objPHPExcel->getActiveSheet()->getColumnDimension('D')->setWidth(25);
				
		$i=3;
		
		$objPHPExcel->getActiveSheet()->getStyle('A'.$i.':D'.$i)->applyFromArray($styleFill);				
		
		while ($row = mysqli_fetch_array($result)) {		
			$i++;
			
			$objPHPExcel->getActiveSheet()->getStyle('A'.$i.':D'.$i)->applyFromArray($styleNoFill);																
					 
			$objPHPExcel->setActiveSheetIndex(0)
							->setCellValue('A' . $i,$row['nro_llamado'])            				
							->setCellValue('B' . $i,$row['descripcion'])							
							->setCellValue('C' . $i,$row['fecha_desde'])
							->setCellValue('D' . $i,$row['fecha_hasta']);										
		}						    
	    
		// Rename sheet
		$objPHPExcel->getActiveSheet()->setTitle('Llamados');
		
		$objPHPExcel->getActiveSheet()->getPageSetup()->setRowsToRepeatAtTopByStartAndEnd(1, 3);
		
		$objPHPExcel->getActiveSheet()->getHeaderFooter()->setOddFooter('&L&B' . $objPHPExcel->getProperties()->getTitle() . '&RPágina &P de &N');
	
		// Set active sheet index to the first sheet, so Excel opens this as the first sheet
		$objPHPExcel->setActiveSheetIndex(0);
				
		$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'HTML');
		$objWriter->setSheetIndex(0);			
		$objWriter->save('php://output');
		exit;
	}
}
?>
