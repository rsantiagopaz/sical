<?php
//include("../control_acceso_flex.php");
include("../config.php");
include("../rutinas.php");

/** PHPExcel */
require_once '../_scripts/phpLib/PHPExcel.php';

/** PHPExcel_IOFactory */
//require_once '../_scripts/phpLib/PHPExcel/IOFactory.php';

session_start();
if (!isset($_SESSION['usuario']) OR empty($_SESSION['usuario']))
	die("ACCESO NO PERMITIDO\n");

switch ($_REQUEST['rutina'])
{
	case 'tomo_cargos':
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
						 ->setTitle("Tomo Cargos")
						 ->setSubject("Tomo Cargos");
		
		$objPHPExcel->setActiveSheetIndex(0);
		
		$objPHPExcel->getActiveSheet()->getPageSetup()->setOrientation(PHPExcel_Worksheet_PageSetup::ORIENTATION_LANDSCAPE);
		$objPHPExcel->getActiveSheet()->getPageSetup()->setPaperSize(PHPExcel_Worksheet_PageSetup::PAPERSIZE_A4);
		
		$objPHPExcel->getActiveSheet()->mergeCells('A2:D2');
		
		// Set fonts
		$objPHPExcel->getActiveSheet()->getStyle('C1:D1')->getFont()->setBold(true);
		
		$objPHPExcel->getActiveSheet()->getStyle('A2')->getFont()->setSize(16);
		$objPHPExcel->getActiveSheet()->getStyle('A2')->getFont()->setBold(true);	
		$objPHPExcel->getActiveSheet()->setCellValue('A2', 'Cargos por Título');
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
		
		$sql="SELECT id_titulo, t.codigo, t.denominacion 'nombre', id_grado_titulo, id_institucion, norma_creacion, disciplina_unica, id_nivel_otorga, i.denominacion, descripcion 'nivel', anios_duracion, ";
	  	$sql.="carga_horaria, requisitos_ingreso, modalidad_cursado, especifico ";
		$sql.="FROM titulos t ";		
		$sql.="LEFT JOIN instituciones i USING(id_institucion) ";		
		$sql.="LEFT JOIN nivel_otorga USING(id_nivel_otorga) ";
		$sql.="WHERE id_titulo = '$id_titulo'";		
				
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$row = mysqli_fetch_array($result);
		
		$objPHPExcel->getActiveSheet()->setCellValue('A2','Cargos por Título');
		
		$objPHPExcel->getActiveSheet()->mergeCells('A4:D4');
				
	    $objPHPExcel->getActiveSheet()->setCellValue('A3','TÍTULO');
	    $objPHPExcel->getActiveSheet()->setCellValue('A4',$row['nombre']);    
	    $objPHPExcel->getActiveSheet()->setCellValue('A6','Institución');
	    $objPHPExcel->getActiveSheet()->setCellValue('A7',$row['denominacion']);
		
							 
		//$objPHPExcel->getActiveSheet()->getColumnDimension('A')->setWidth(15);
		$objPHPExcel->getActiveSheet()->getColumnDimension('A')->setWidth(30);
		$objPHPExcel->getActiveSheet()->getColumnDimension('B')->setWidth(12);
		$objPHPExcel->getActiveSheet()->getColumnDimension('C')->setWidth(70);
		$objPHPExcel->getActiveSheet()->getColumnDimension('D')->setWidth(12);
		
		$sql="SELECT id_tomo_cargo, id_cargo, cod_cargo, id_tipo_titulo, cod_tipo_titulo, tipo, id_tipo_clasificacion, ";
	  	$sql.="ca.denominacion 'denomcar', t.denominacion 'denomclas', t.codigo 'cod_tipo_clasificacion', cod_nivel, nivel, 'A' as origen ";
		$sql.="FROM tomo_cargos ";
		$sql.="INNER JOIN cargos ca USING(id_cargo) ";		
		$sql.="INNER JOIN tipos_titulos USING(id_tipo_titulo) ";
		$sql.="INNER JOIN tipos_clasificacion t USING(id_tipo_clasificacion) ";
		$sql.="INNER JOIN niveles USING(id_nivel) ";
		$sql.="WHERE id_titulo = '$id_titulo'";
		
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
							->setCellValue('A' . $i,'Cargo')
							->setCellValue('B' . $i,'Nivel')
							->setCellValue('C' . $i,'Tipo Clasificación')
							->setCellValue('D' . $i,'Tipo Título');
		
		while ($row = mysqli_fetch_array($result)) {		
			$i++;
			
			$objPHPExcel->getActiveSheet()->getStyle('A'.$i.':D'.$i)->applyFromArray($styleNoFill);																
					 
			$objPHPExcel->setActiveSheetIndex(0)
							->setCellValue('A' . $i,$row['denomcar'])
							->setCellValue('B' . $i,$row['nivel'])
							->setCellValue('C' . $i,$row['denomclas'])
							->setCellValue('D' . $i,$row['tipo']);										
		}
		
		$i++;        
		
		for ($c = 0;$c <= 3;$c++) {
			$objPHPExcel->getActiveSheet()->getStyleByColumnAndRow($c,$i-1)->applyFromArray($styleThinBorder);	
		}		    
	    
		// Rename sheet
		$objPHPExcel->getActiveSheet()->setTitle('Tomo Cargos');
		
		$objPHPExcel->getActiveSheet()->getPageSetup()->setRowsToRepeatAtTopByStartAndEnd(1, 8);
		
		$objPHPExcel->getActiveSheet()->getHeaderFooter()->setOddFooter('&L&B' . $objPHPExcel->getProperties()->getTitle() . '&RPágina &P de &N');
	
		// Set active sheet index to the first sheet, so Excel opens this as the first sheet
		$objPHPExcel->setActiveSheetIndex(0);
		
		if ($_REQUEST['tipoinforme']=="html") {
			$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'HTML');
			$objWriter->setSheetIndex(0);
			//$objWriter->setImagesRoot('http://www.example.com');
			$objWriter->save('php://output');	
		} elseif ($_REQUEST['tipoinforme']=="xls") {
			// Redirect output to a client’s web browser (Excel5)
			header('Content-Type: application/vnd.ms-excel');
			header('Content-Disposition: attachment;filename="reporte.xls"');
			header('Cache-Control: max-age=0');
			
			$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel5');
			$objWriter->save('php://output');	
		} else {
			header('Content-type: application/pdf'); 
			header('Content-disposition: attachment; filename="reporte.pdf"');
			header('Cache-Control: max-age=0');
			
			$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'PDF');
			$objWriter->setSheetIndex(0);
			$objWriter->save('php://output');
		}				
		
		exit;
	}
}
?>
