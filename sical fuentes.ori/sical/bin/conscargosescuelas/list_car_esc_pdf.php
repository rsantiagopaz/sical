<?php
include("../control_acceso_flex.php");
require($SYSpathraiz.'fpdf17/mc_table/mc_table.php');
include("../rutinas.php");

ini_set('memory_limit', '512M');
set_time_limit(1200);

class PDF extends PDF_MC_Table
{
	//Page header
	function Header()
	{
		$sql="SELECT * FROM escuelas WHERE id_escuela='".$_REQUEST['id_escuela']."'";			
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
		$row = mysqli_fetch_array($result);
	    //Title
	    $this->Image('../img/logo.jpg',10,8,33);
	    $this->SetFont('Arial','',18);
	    $this->Cell(0,6,'Cargos por Escuela',0,1,'C');
	    $this->Ln(10);
	    $this->SetFont('Arial','',14);
	    $this->Cell(0,6,'Escuela: ' . $row['nombre'],0,1,'C');
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
		$sql="SELECT id_escuela_cargo, id_cargo, cod_cargo, ca.denominacion 'denomcar', id_escuela, cod_escuela, nombre, n.id_nivel 'id_nivel', n.nivel 'nivel', 'A' as origen ";
		$sql.="FROM escuelas_cargos ";
		$sql.="INNER JOIN cargos ca USING(id_cargo) ";
		$sql.="INNER JOIN escuelas USING(id_escuela) ";
		$sql.="INNER JOIN niveles n ON ca.id_nivel = n.id_nivel ";	
		$sql.="WHERE id_escuela = '".$_REQUEST['id_escuela']."' ";
		if ($_SESSION['usuario_nivel_id'] != '4' && $_SESSION['usuario_organismo_area_id'] != '6')	
			$sql.="AND n.id_nivel = '".$_SESSION['usuario_nivel_id']."' ";
		$sql.="ORDER BY denomcar";
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);	
		$data = array();
		while ($row = mysqli_fetch_array($result)) {		
			$data[] = array($row['cod_cargo'],utf8_decode($row['denomcar']),$row['nivel']);	
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
$pdf->AliasNbPages();
// Títulos de las columnas
$header = array('CODIGO', 'CARGO', 'NIVEL');
// Carga de datos
$data = $pdf->LoadData();
$pdf->SetFont('Arial','',10);
$pdf->SetTableHeader($header);
$pdf->AddPage();
$pdf->SetWidths(array(25,135,30));
$pdf->PrintTableHeader();
$pdf->ImprovedTable($header,$data);
$pdf->Output();
?>