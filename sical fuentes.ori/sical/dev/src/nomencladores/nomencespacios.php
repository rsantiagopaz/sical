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
	    $this->SetFont('Arial','',18);
	    $this->Cell(0,6,'Listado de Espacios',0,1,'C');
	    $this->Ln(10);
	    $this->SetFont('Arial','',10);
	    $this->Cell(0,6,date("d/m/Y"),0,1,'R');
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
	function LoadData($orden)
	{
		$sql="SELECT * ";
		$sql.="FROM espacios ";
		($orden == 'codigo') ? $sql.="ORDER BY codigo" : $sql.="ORDER BY denominacion";
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);	
		$data = array();
		while ($row = mysqli_fetch_array($result)) {		
			$data[] = array($row['codigo'],utf8_decode($row['denominacion']));	
		}	
		return $data;
	}
	
	// Una tabla más completa
	function ImprovedTable($header, $data)
	{		
		// Datos
		foreach($data as $row)
		{			
			$this->Row(array($row[0],$row[1]));
		}		
	}		
}

$orden = $_REQUEST['orden'];
$pdf = new PDF();
$pdf->AliasNbPages();
// Títulos de las columnas
$header = array('CODIGO', 'DENOMINACION');
// Carga de datos
$data = $pdf->LoadData($orden);
$pdf->SetFont('Arial','',10);
$pdf->SetTableHeader($header);
$pdf->AddPage();
$pdf->SetWidths(array(40,150));
$pdf->PrintTableHeader();
$pdf->ImprovedTable($header,$data);
$pdf->Output();
?>