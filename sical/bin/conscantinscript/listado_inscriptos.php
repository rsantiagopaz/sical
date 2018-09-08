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
	    $this->SetFont('Arial','',16);
	    $sql = "SELECT nro_llamado FROM llamados WHERE id_llamado='".$_REQUEST['id_llamado']."'";
	    $result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
	    $row = mysqli_fetch_array($result);
	    $this->Cell(0,6,utf8_decode('Listado de Inscriptos Llamado N°: ') . $row['nro_llamado'],0,1,'C');
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
		$sql ="SELECT apellido, nombres, nro_doc FROM docentes JOIN docentes_llamados USING(id_docente) ";		
		$sql.="WHERE id_llamado = '".$_REQUEST['id_llamado']."' ";		
		$sql.="ORDER BY apellido, nombres DESC";
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);	
		$data = array();			
							
		while ($row = mysqli_fetch_array($result)) {		
			$data[] = array(utf8_decode($row['apellido']),utf8_decode($row['nombres']),$row['nro_doc']);	
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
			$this->Row(array($row[0],$row[1],$row[2]));
		}		
	}		
}

$pdf = new PDF();
$pdf->SetLeftMargin(35);
$pdf->AliasNbPages();
// Títulos de las columnas
$header = array('APELLIDO', 'NOMBRES', 'DNI');
// Carga de datos
$data = $pdf->LoadData();
$pdf->SetFont('Arial','',10);
$pdf->SetTableHeader($header);
$pdf->AddPage();
$pdf->SetWidths(array(60,60,20));
$pdf->PrintTableHeader();
$pdf->ImprovedTable($header,$data);
$pdf->Output();
?>
