<?php
include("../control_acceso_flex.php");
require($SYSpathraiz.'fpdf17/mc_table/mc_table.php');

ini_set('memory_limit', '512M');
set_time_limit(1200);

class PDF extends PDF_MC_Table
{
	//Page header
	function Header()
	{
	    //Title
	    $this->Image('../img/logo.jpg',10,8,33);
	    $this->Ln(10);
	    $this->SetFont('Arial','',14);
	    $sql = "SELECT nro_llamado FROM llamados WHERE id_llamado='".$_REQUEST['id_llamado']."'";
	    $result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
	    $row = mysqli_fetch_array($result);
	    $this->Cell(0,6,utf8_decode('Listado de Inscripciones Observadas para el Llamado N°: ') . $row['nro_llamado'],0,1,'C');
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
		$sql ="SELECT apellido, nombres, nro_doc, IF (id_observacion='19',comentarios,descripcion) 'observacion' FROM docentes JOIN docentes_llamados USING(id_docente) ";
		$sql.="JOIN docentes_llamados_observaciones USING(id_docente_llamado) ";
		$sql.="JOIN observaciones USING(id_observacion) ";		
		$sql.="WHERE id_llamado = '".$_REQUEST['id_llamado']."' ";		
		$sql.="ORDER BY apellido, nombres DESC";
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);	
		$data = array();			
							
		while ($row = mysqli_fetch_array($result)) {		
			$data[] = array(utf8_decode($row['apellido']),utf8_decode($row['nombres']),$row['nro_doc'],utf8_decode($row['observacion']));	
		}	
		return $data;
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
$pdf->SetLeftMargin(10);
$pdf->AliasNbPages();
// Títulos de las columnas
$header = array('APELLIDO', 'NOMBRES', 'DNI', utf8_decode('OBSERVACIÓN'));
// Carga de datos
$data = $pdf->LoadData();
$pdf->SetFont('Arial','',8);
$pdf->SetTableHeader($header);
$pdf->AddPage();
if (count($data) > 0) {
	$pdf->SetWidths(array(55,55,20,60));
	$pdf->PrintTableHeader();
	$pdf->ImprovedTable($header,$data);	
} else {
	$pdf->Cell(0,6,'No hay Inscripciones Observadas para el Llamado',0,1,'C');
}
$pdf->Output();
?>
