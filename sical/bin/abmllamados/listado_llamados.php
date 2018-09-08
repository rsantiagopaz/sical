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
	    $this->Cell(0,6,'Listado de Llamados',0,1,'C');
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
	function LoadData($filter)
	{
		$sql="SELECT id_llamado, nro_llamado, descripcion, id_tipo_clasificacion 'tipo_clasificacion', oculto, id_nivel, nivel, ";
	  	$sql.="DATE_FORMAT(fecha_desde,'%d/%m/%Y') 'fecha_desde', ";
	  	$sql.="DATE_FORMAT(fecha_hasta,'%d/%m/%Y') 'fecha_hasta' ";
		$sql.="FROM llamados ";
		$sql.="INNER JOIN niveles USING(id_nivel) ";
		$sql.="WHERE descripcion LIKE '%$filter%' ";
		$sql.="AND id_nivel = '".$_SESSION['usuario_nivel_id']."' ";		
		$sql.="ORDER BY id_llamado DESC LIMIT 1000";
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);	
		$data = array();			
							
		while ($row = mysqli_fetch_array($result)) {		
			$data[] = array($row['nro_llamado'],utf8_decode($row['descripcion']),$row['fecha_desde'],$row['fecha_hasta']);	
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

$filter = $_REQUEST['filter'];
$pdf = new PDF();
$pdf->SetLeftMargin(35);
$pdf->AliasNbPages();
// Títulos de las columnas
$header = array(utf8_decode('NÚMERO'), utf8_decode('DESCRIPCIÓN'), 'DESDE', 'HASTA');
// Carga de datos
$data = $pdf->LoadData($filter);
$pdf->SetFont('Arial','',10);
$pdf->SetTableHeader($header);
$pdf->AddPage();
$pdf->SetWidths(array(20,75,20,20));
$pdf->PrintTableHeader();
$pdf->ImprovedTable($header,$data);
$pdf->Output();
?>
