<?php
/*
 * Created on 21/01/2010
 *
 */
 
include("../control_acceso_flex.php"); 
 
error_reporting(E_ALL);

function genero_xml_ok_errores($_ok,$_errores,$otroNodoXml)
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

	$_errores = '';
	$_ok='';
	$otroNodoXml = '';
		
	// fecha del reporte
	$date = date("d/m/Y");	
	
	$sql = "SELECT apellido, nombres, tipo_doc, nro_doc FROM docentes " .
			"JOIN tipos_documentos USING(id_tipo_doc) JOIN docentes_llamados USING(id_docente) " .
			"WHERE id_docente_llamado = '".$_REQUEST['id_docente_llamado']."'";
			
	$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
	$row = mysqli_fetch_array($result);
			
    $objPHPExcel->getActiveSheet()->setCellValue('A3','DOCENTE:');
    $objPHPExcel->getActiveSheet()->setCellValue('B3',$row['apellido'] . ', ' . $row['nombres']);    
    $objPHPExcel->getActiveSheet()->setCellValue('C3',$row['tipo_doc'] . ':');
    $objPHPExcel->getActiveSheet()->setCellValue('D3',$row['nro_doc']);
	
						 
	$objPHPExcel->getActiveSheet()->getColumnDimension('A')->setWidth(15);
	$objPHPExcel->getActiveSheet()->getColumnDimension('B')->setWidth(75);
	$objPHPExcel->getActiveSheet()->getColumnDimension('C')->setWidth(15);
	$objPHPExcel->getActiveSheet()->getColumnDimension('D')->setWidth(12);
	/*$objPHPExcel->getActiveSheet()->getColumnDimension('E')->setWidth(12);
	$objPHPExcel->getActiveSheet()->getColumnDimension('F')->setWidth(25);*/		
	
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
	
	$i=3;	
	
	$i++;        
	
	for ($c = 0;$c <= 3;$c++) {
		$objPHPExcel->getActiveSheet()->getStyleByColumnAndRow($c,$i-1)->applyFromArray($styleThinBorder);	
	}
	
	$i++;
	
	$objPHPExcel->getActiveSheet()->mergeCells("A$i:D$i");
	
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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<style type="text/css">
body{font-size:13px;font-family: times New Roman;margin: 0 auto; width: 850px;}
h1,h2,h3{text-align:center;background-color:#999999;}
h1{font-size:20px;}
h2{font-size:18px;}
h3{font-size:15px;}
table{width:100%; border-collapse: collapse;}
th{font-weight: bold;text-align:center;background-color:#CCCCCC;}
.title{background-color:#CCCCCC;font-weight:bold;}
</style>
</head>
<body>
<h1>Antecedentes Declarados por el Docente</h1>
<h3>Fecha: <?php echo $date; ?></h3>
<h2>Datos del Docente</h2>
<table>
	<tr>
		<td class="title">Nombre:</td>
		<td><? echo $row['apellido'] . ', ' . $row['nombres']; ?></td>
		<td class="title">Tipo Doc:</td>
		<td><? echo $row['tipo_doc']; ?></td>
		<td class="title">Nro Doc:</td>
		<td><? echo $row['nro_doc']; ?></td>
	</tr>	
</table>
<?

	$sql = "SELECT * FROM docentes_llamados_titulos " .
			"JOIN titulos USING(id_titulo) " .
			"WHERE id_docente_llamado = '".$_REQUEST['id_docente_llamado']."'";
	
	$result = mysql_query($sql);	
	?>
	<h2>Títulos y Antecdentes</h2>
	<?php	
	while ($row = mysqli_fetch_array($result)) {?>
		<table>
			<tr>
				<td>Título:</td>
				<td><?php echo $row['denominacion'] ?></td>
			</tr>
			<tr>
		</table>		
		<?php			
		$objPHPExcel->setActiveSheetIndex(0)
						->setCellValue('B' . $i,'Antecedente')            				
						->setCellValue('C' . $i,'Cantidad')
						->setCellValue('D' . $i,'Puntaje');
						/*->setCellValue('E' . $i,'Tope')
						->setCellValue('F' . $i,'Puntaje Reconocido');*/
		
		$sql2 = "SELECT * FROM docentes_llamados_titulos_antecedentes " .
				"JOIN antecedentes USING(id_antecedente) " .
				"WHERE id_docente_llamado_titulo = '".$row['id_docente_llamado_titulo']."'";
				
		$result2 = mysqli_query($GLOBALS["___mysqli_ston"], $sql2);
		
		$total_puntos_antecedente_titulo = 0;		
		while ($row2 = mysqli_fetch_array($result2)) {		
			$i++;
			
			if ($row2['tope'] == 0) {
				if ($row2['codigo'] != 'B')
					$puntaje_reconocido = $row2['unidades'] * $row2['puntos'];
				else
					$puntaje_reconocido = $row2['unidades'];
			} else {
				if ($row2['unidades'] * $row2['puntos'] > $row2['tope'])
					$puntaje_reconocido = $row2['tope'];
				else
					$puntaje_reconocido = $row2['unidades'] * $row2['puntos'];
			}
			
		$total_puntos_antecedente_titulo += $puntaje_reconocido;
			
			$objPHPExcel->getActiveSheet()->getStyle('C' . $i . ':' . 'D' . $i)->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
			
			$objPHPExcel->getActiveSheet()->getStyle('C' . $i)->getNumberFormat()
->setFormatCode('#.##');
			
			/*$objPHPExcel->getActiveSheet()->getStyle('F' . $i)->getNumberFormat()
->setFormatCode('#.##');*/

			for ($c = 1;$c <= 3;$c++) {
				$objPHPExcel->getActiveSheet()->getStyleByColumnAndRow($c,$i)->applyFromArray($styleThinBorder);	
			}
				 
			$objPHPExcel->setActiveSheetIndex(0)
						->setCellValue('B' . $i,$row2['codigo'])            				
						->setCellValue('C' . $i,$row2['unidades'])
						->setCellValue('D' . $i,$row2['puntos']);
						/*->setCellValue('E' . $i,$row2['tope'])
						->setCellValue('F' . $i,$puntaje_reconocido);*/
		}
		/*$i++;
		$objPHPExcel->getActiveSheet()->getStyle('F' . $i)->getNumberFormat()
->setFormatCode('#.##');
		$objPHPExcel->getActiveSheet()->getStyle('E' . $i . ':' . 'F' . $i)->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
		$objPHPExcel->setActiveSheetIndex(0)						
						->setCellValue('E' . $i,'TOTAL:')
						->setCellValue('F' . $i,$total_puntos_antecedente_titulo);*/
	}
	
	if($xmlIngreso->datosingreso['id_nivel']==1){?>
	<h2>Datos de la Consulta</h2>
		<table>
			<tr>
				<td class="title">Tipo de Ingreso:</td>
				<td><? echo $xmlIngreso->datosingreso['tipo_ingreso']; ?></td>
				<td class="title">Consulta:</td>
				<td><? echo $xmlIngreso->datosingreso['primera_vez']; ?></td>
			</tr>
			<tr>
				<td class="title">Motivo de la Consulta</td>
				<td colspan="3"><? echo $xmlIngreso->datosingreso['motivo']; ?></td>
			</tr>
			<tr>
				<td class="title">Observaciones</td>
				<td colspan="3"><? echo $xmlIngreso->datosingreso['observaciones']; ?></td>
			</tr>
			<? if($xmlPaciente->paciente['edad'] <= 12){?>
			<tr>
				<td class="title">Peso:</td>
				<td><? echo $xmlIngreso->datosingreso['peso']; ?></td>
				<td class="title">Talla:</td>
				<td><? echo $xmlIngreso->datosingreso['talla']; ?></td>
				<td class="title">Perimero</td>
				<td><? echo $xmlIngreso->datosingreso['perimetro']; ?></td>
			</tr>
			<tr>
				<td class="title">Perc. Talla:</td>
				<td><? echo $xmlIngreso->datosingreso['peso_edad']; ?></td>
				<td class="title">Perc. Peso:</td>
				<td><? echo $xmlIngreso->datosingreso['talla_edad']; ?></td>
				<td class="title">Perc. Perimero</td>
				<td><? echo $xmlIngreso->datosingreso['perc_perimetro']; ?></td>
			</tr>
			</table>
			<? } ?>
			<? if($xmlIngreso->datosingreso['embarazada'] == 'S'){?>
			<tr>
				<td class="title">Trimestre:</td>
				<td><? echo $xmlIngreso->datosingreso['trimestre']; ?></td>
				<td class="title">Presion Arterial:</td>
				<td><? echo $xmlIngreso->datosingreso['tension_arterial']; ?></td>
			</tr>
			<? } ?>
		</table>
	<?}
	if($xmlIngreso->datosingreso['id_nivel']==2){
		echo '<h2>Datos de Internacion</h2>';	
	}
	if($xmlDiagnosticos->diagnostico){?>
		<h3>Diagnosticos</h3>
		<table>	
			<tr>
				<th>Descripcion</th>
				<th>Tipo</th>
			</tr>
		<? 		
		foreach ($xmlDiagnosticos->diagnostico as $diag){?>
			<tr>
				<td><? echo $diag['descripcion']; ?></td>
				<td align="center"><? echo $diag['tipo_diagnostico']; ?></td>
			</tr> 
		<? } ?>
		</table>
	<? }
	if($xmlIngreso->datosingreso['id_nivel']==2){
		$trau = ($xmlIngreso->datosingreso['traumatismo'] == 'N') ? 'No' : 'Si';
		$emb = ($xmlIngreso->datosingreso['embarazada'] == 'N') ? 'No' : 'Si';
		?>
		<h3>Datos Sobre Traumatismos</h3>	
		<table>
			<tr>
				<td>Presenta Traumatismo?:</td>
				<td colspan="3"><? echo $trau; ?></td>
			</tr>
			<? if ($xmlIngreso->datosingreso['traumatismo'] == 'S'){?>
			<tr>
				<td>Traumatismo Producido Por:</td>
				<td><? echo $xmlIngreso->datosingreso['tp_desc']; ?></td>
				<td>Traumatismo Lugar:</td>
				<td><? echo $xmlIngreso->datosingreso['tl_desc']; ?></td>
			</tr>
			<tr>
				<td>Descripcion:</td>
				<td colspan="3"><? echo $xmlIngreso->datosingreso['traum_comoseprodujo']; ?></td>
			</tr>
			<?}?>
		</table>
		<h3>Datos de Embarazo</h3>	
		<table width="500">
			<tr>
				<td>Embarazada?:</td>
				<td colspan="7"><? echo $emb; ?></td>
			</tr>
			<? if ($xmlIngreso->datosingreso['embarazada'] == 'S'){?>
			<tr>
				<td>Fecha Term.:</td>
				<td><? echo $xmlIngreso->datosingreso['embarazo_fechaterminacion']; ?></td>
				<td>Edad Gest.:</td>
				<td><? echo $xmlIngreso->datosingreso['embarazo_edad_gestacional']; ?></td>
				<td>Tipo:</td>
				<td><? echo $xmlIngreso->datosingreso['embarazo_tipo_parto_text']; ?></td>
				<td>Paridad:</td>
				<td><? echo $xmlIngreso->datosingreso['embarazo_paridad']; ?></td>
			</tr>
			<tr>
				<td colspan="8">
				<table>	
					<tr>
						<th>Peso</th>
						<th>Cond. al Nacer</th>
						<th>Terminacion</th>
						<th>Sexo</th>
					</tr>
				<? 		
				foreach ($xmlNacimientos->nacimiento as $nac){?>
					<tr>
						<td align="center"><? echo $nac['peso']; ?></td>
						<td><? echo $nac['condicion_alnacer_text']; ?></td>
						<td><? echo $nac['terminacion_text']; ?></td>
						<td><? echo $nac['sexo_text']; ?></td>
					</tr> 
				<? } ?>
				</table>
				</td>
			</tr>
			<?}?>
		</table>
	<?}

	if($xmlPrescripciones->prescripcion){?>
		<h3>Prescripciones</h3>
		<table>	
			<tr>
				<th>Fecha</th>
				<th>Monodroga</th>
				<th>Presentacion</th>
				<th>Concentracion</th>
				<th>Posologia</th>
			</tr>
		<? 		
		foreach ($xmlPrescripciones->prescripcion as $prec){?>
			<tr>
				<td align="center"><? echo $prec['fecha_prescripcion']; ?></td>
				<td><? echo $prec['monodroga']; ?></td>
				<td><? echo $prec['presentacion']; ?></td>
				<td><? echo $prec['concentracion']; ?></td>
				<td><? echo $prec['posologia']; ?></td>
			</tr> 
		<? } ?>
		</table>
	<? }
	
	if($xmlPracticas->practica){?>
		<h3>Practicas y Procedimientos</h3>
		<table>	
			<tr>
				<th>Fecha de Solicitud</th>
				<th>Practica</th>
				<th>Resultado</th>
			</tr>
		<? 		
		foreach ($xmlPracticas->practica as $prac){?>
			<tr>
				<td align="center"><? echo $prac['fecha_solicitud']; ?></td>
				<td><? echo $prac['descripcion']; ?></td>
				<td><? echo $prac['resultados']; ?></td>
			</tr> 
		<? } ?>
		</table>
	<? }

	if($xmlAntecedentes->antecedente){?>
		<h3>Antecedentes</h3>
		<table>	
			<tr>
				<th>Tipo de Antecedente</th>
				<th>Descripcion</th>
				<th>Observaciones</th>
				<th>Fecha</th>
				<th>Medico</th>
				<th>Accion</th>
			</tr>
		<? 		
		foreach ($xmlAntecedentes->antecedente as $ant){?>
			<tr>
				<td><? echo $ant['descripcion']; ?></td>
				<td><? echo $ant['antecedente']; ?></td>
				<td><? echo $ant['observaciones']; ?></td>
				<td align="center"><? echo $ant['fecha']; ?></td>
				<td><? echo $ant['medico']; ?></td>
				<td><? echo $ant['accion']; ?></td>
			</tr> 
		<? } ?>
		</table>
	<? }
	
	if($xmlVacunas->vacunaciones){?>
		<h3>Vacunaciones</h3>
		<table>	
			<tr>
				<th>Vacuna</th>
				<th>Enfermedades</th>
				<th>Fecha</th>
			</tr>
		<? 		
		foreach ($xmlVacunas->vacunaciones as $vac){?>
			<tr>
				<td><? echo $vac['nombre']; ?></td>
				<td><? echo $vac['enfermedades']; ?></td>
				<td align="center"><? echo $vac['fecha']; ?></td>
			</tr> 
		<? } ?>
		</table>
	<? }
?>
</body>
</html>
