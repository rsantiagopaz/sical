<?php
include("../control_acceso_flex.php");
include("../rutinas.php");
require($SYSpathraiz.'fpdf17/mc_table/mc_table.php');

ini_set('memory_limit', '256M');
set_time_limit(900);

class PDF extends PDF_MC_Table
{	
	var $xmlPaciente;
	//Page header
	function Header()
	{
	    //Title	    
	    $this->SetFont('Arial','',14);
	    $this->Cell(0,6,utf8_decode('Situación del Docente'),0,1,'C');	    
	    $this->Ln(10);	    
	    //Ensure table header is output
	    parent::Header();
	}
	
	//Page footer
	function Footer()
	{
	    //Position at 1.5 cm from bottom
	    $this->SetY(-15);
	    //Arial italic 8
	    $this->SetFont('Arial','I',8);
	    //Page number
	    $this->Cell(0,10,'Pagina '.$this->PageNo().'/{nb}',0,0,'C');
	}
	
	//Table header
	function SetTableHeader($header)
	{
		$this->header = $header;
	}
	
	function PrintTableHeader()
	{
		$this->SetFont('','B');
		$this->Row($this->header);
		$this->SetFont('');
	}
	
	// Cargar los datos
	function LoadData()
	{		
		$xmlDocente=new SimpleXMLElement('<rows/>');
		$xmlNivelesInscripciones=new SimpleXMLElement('<rows/>');		
		$xmlTitularizaciones=new SimpleXMLElement('<rows/>');
		$xmlComisionTitularizacion=new SimpleXMLElement('<rows/>');
		$xmlSueldos=new SimpleXMLElement('<rows/>');
		$xmlAltaTitulares2012=new SimpleXMLElement('<rows/>');
						
		$query ="SELECT COUNT(*) 'CANT' ";		
		$query.="FROM docentes ";
		$query.="WHERE nro_doc='".$_REQUEST['nro_doc']."'";
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $query);
		$row = mysqli_fetch_array($result);		
		
		if ($row['CANT'] > 0){
			$sql ="SELECT * ";		
			$sql.="FROM docentes ";
			$sql.="WHERE nro_doc='".$_REQUEST['nro_doc']."'";
			toXML($xmlDocente, $sql, "docente");		
			$id_docente = $xmlDocente->docente['id_docente'];						
		
			$sql ="SELECT DISTINCT id_nivel ";
			$sql.="FROM docentes JOIN docentes_llamados USING(id_docente) ";
			$sql.="JOIN llamados USING(id_llamado) ";
			$sql.="WHERE id_docente='$id_docente' ";
			$sql.="ORDER BY id_nivel";			
			toXML($xmlNivelesInscripciones, $sql, "nivelinscripcion");
			
			$this->xmlDocente = $xmlDocente;
			$this->xmlNivelesInscripciones = $xmlNivelesInscripciones;			
		}
		
		$sql ="SELECT cargo, expediente, hs, sr, DATE_FORMAT(fecha_alta,'%d/%m/%Y') 'fecha_alta', fecha_baja FROM ";
		$sql.="interinos_titulares_primario_2012 ";
		$sql.="WHERE documento='".$_REQUEST['nro_doc']."'";
		toXML($xmlTitularizaciones, $sql, 'titularizacion');
		$this->xmlTitularizaciones = $xmlTitularizaciones;
		
		$sql ="SELECT * FROM ";
		$sql.="docentes_comision_titularizacion ";
		$sql.="WHERE documento='".$_REQUEST['nro_doc']."'";
		toXML($xmlComisionTitularizacion, $sql, 'titularizacion');
		$this->xmlComisionTitularizacion = $xmlComisionTitularizacion; 
		
		$sql ="SELECT mi.CONTROL, mi.CUIL, mi.HORAS, cs.NOM_CAR 'cargo', es.NOMBRE 'escuela' ";
		$sql.="FROM miria1 mi LEFT JOIN cargos_sueldos cs ON mi.COD_CAR = cs.COD_CAR ";
		$sql.="LEFT JOIN escuelas_sueldos es ON mi.ESCUELA = es.CODESC ";
		$sql.="WHERE mi.NRODOC='".$_REQUEST['nro_doc']."'";		
		toXML($xmlSueldos, $sql, 'sueldo');
		$this->xmlSueldos = $xmlSueldos;
		
		$sql ="SELECT * FROM alta_titulares_2012 ";
		$sql.="WHERE Documento='".$_REQUEST['nro_doc']."'";		
		toXML($xmlAltaTitulares2012, $sql, 'titulares');
		$this->xmlAltaTitulares2012 = $xmlAltaTitulares2012;
	}
	
	// Una tabla más completa
	function ImprovedTable($header, $data)
	{
		// Anchuras de las columnas		
		// Datos
		foreach($data as $row)
		{
			$this->Row(array($row[0],$row[1],$row[2],$row[3]));
		}		
	}		
}

$pdf = new PDF();
$pdf->SetLeftMargin(20);
$pdf->AliasNbPages();

// Carga de datos
$data = $pdf->LoadData();

$pdf->AddPage();

$pdf->SetFont('Arial','',8);
$pdf->SetFont('','B');

if ($pdf->xmlDocente->docente) {
	$pdf->Cell(0,6,'DATOS DEL DOCENTE',0,1,'C');
	$pdf->SetWidths(array(30,30,20,60));
	$pdf->Row(array('Apellido','Nombre','DNI','Domicilio'));
	$pdf->SetFont('');
	$pdf->Row(array(utf8_decode($pdf->xmlDocente->docente['apellido']),utf8_decode($pdf->xmlDocente->docente['nombres']),$pdf->xmlDocente->docente['nro_doc'],utf8_decode($pdf->xmlDocente->docente['domicilio'])));
	
	$pdf->SetFont('','B');
	$pdf->Cell(0,6,'INSCRIPCIONES',0,1,'C');
	
	$niveles = array('1' => 'Inicial', '2' => 'Primario', '3' => 'Secundario', '4' => 'Superior');
	
	foreach ($pdf->xmlNivelesInscripciones->nivelinscripcion as $nivel) {
		$id_nivel = $nivel['id_nivel'];
		$pdf->SetFont('','B');
		$pdf->Cell(0,6,'Nivel ' . $niveles["$id_nivel"],0,1,'C');		
		
		$xmlInscripciones=new SimpleXMLElement('<rows/>');
		
		$sql ="SELECT descripcion, DATE_FORMAT(fecha_inscripcion,'%d/%m/%Y %H:%i:%s') 'fecha_inscripcion' FROM docentes JOIN docentes_llamados USING(id_docente) ";
		$sql.="JOIN llamados USING(id_llamado) ";
		$sql.="WHERE id_docente='".$pdf->xmlDocente->docente['id_docente']."' ";
		$sql.="AND id_nivel = '".$nivel['id_nivel']."'";		
		toXML($xmlInscripciones, $sql, 'inscripcion');
		
		$pdf->SetFont('','B');
		$pdf->SetWidths(array(105,35));
		$pdf->Row(array('Llamado',utf8_decode('Fecha de Inscripción')));
		$pdf->SetFont('');
		
		foreach ($xmlInscripciones->inscripcion as $inscripcion) {
			$pdf->Row(array(utf8_decode($inscripcion['descripcion']),$inscripcion['fecha_inscripcion']));	
		}				
	}
}

if ($pdf->xmlTitularizaciones->titularizacion) {
	$pdf->SetFont('','B');	
	$pdf->Cell(0,6,utf8_decode('TITULARIZACIÓN NIVEL PRIMARIO'),0,1,'C');
	
	$pdf->SetWidths(array(50,30,15,30,25,25));
	$pdf->Row(array('Cargo','Expediente','HS','Sit. Rev.','Fecha Alta','Fecha Baja'));
	foreach ($pdf->xmlTitularizaciones->titularizacion as $titularizacion) {
		$pdf->SetFont('');
		$pdf->Row(array($titularizacion['cargo'],$titularizacion['expediente'],$titularizacion['hs'],$titularizacion['sr'],$titularizacion['fecha_alta'],$titularizacion['fecha_baja']));
	}
}

if ($pdf->xmlComisionTitularizacion->titularizacion) {
	$pdf->SetFont('','B');	
	$pdf->Cell(0,6,utf8_decode('COMISIÓN DE TITULARIZACIÓN'),0,1,'C');
	
	$pdf->SetWidths(array(50,15,60,50));
	$pdf->Row(array('Cargo','HS',utf8_decode('Curso División Asignatura Turno Situación'),'Escuela'));
	foreach ($pdf->xmlComisionTitularizacion->titularizacion as $titularizacion) {
		$pdf->SetFont('');
		$pdf->Row(array($titularizacion['nom_car'],$titularizacion['horas'],utf8_decode($titularizacion['situacion']),$titularizacion['escuela']));
	}
}

if ($pdf->xmlSueldos->sueldo) {
	$pdf->SetFont('','B');	
	$pdf->Cell(0,6,utf8_decode('SUELDOS PERIODO 05/2013'),0,1,'C');
	
	$pdf->SetWidths(array(20,20,15,55,65));
	$pdf->Row(array('Control','CUIL','HS','Cargo','Escuela'));
	foreach ($pdf->xmlSueldos->sueldo as $sueldo) {
		$pdf->SetFont('');
		$pdf->Row(array($sueldo['CONTROL'],$sueldo['CUIL'],$sueldo['HORAS'],$sueldo['cargo'],$sueldo['escuela']));
	}
}

if ($pdf->xmlAltaTitulares2012->titulares) {
	$pdf->SetFont('','B');	
	$pdf->Cell(0,6,utf8_decode('TITULARES 2012 CAD'),0,1,'C');
	
	$pdf->SetWidths(array(50,90,15,20));
	$pdf->Row(array('Cargo','Escuela','HS','Sit. Revista'));
	foreach ($pdf->xmlAltaTitulares2012->titulares as $titulares) {
		$pdf->SetFont('');
		$pdf->Row(array($titulares['cargoO'],utf8_decode($titulares['nombreO']),$titulares['horaO'],$titulares['sitrevistaO']));
	}
}
$pdf->Output();
?>