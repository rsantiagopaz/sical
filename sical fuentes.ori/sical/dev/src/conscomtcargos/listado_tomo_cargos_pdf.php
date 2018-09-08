<?php
include("../control_acceso_flex.php");
require($SYSpathraiz.'fpdf17/mc_table/mc_table.php');
include("../_phpincludes/_vertablatomocargo.php");

ini_set('memory_limit', '512M');
set_time_limit(1200);

class PDF extends PDF_MC_Table
{
	var $nombre;
	var $denominacion;
	
	//Page header
	function Header()
	{
	    //Title
	    $this->Image('../img/logo.jpg',10,8,33);
	    $this->SetFont('Arial','',16);
	    $this->Cell(0,6,'Cargos por Titulo',0,1,'C');	    
	    $this->Ln(10);	    
	    $this->SetFont('Arial','',10);	    
	    $this->Cell(0,6,'Titulo: ' . utf8_decode($this->nombre),0,1,'C');
	    $this->Cell(0,6,utf8_decode('Código: ') . $this->codigo,0,1,'C');	    
	    $this->Cell(0,6,'Institucion: ' . utf8_decode($this->denominacion),0,1,'C');
	    $this->Ln(8);
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
		global $opcion, $SYSusuario_nivel_id;
		if (isset($opcion)) {
 			$tabla = determinar_tabla_tomo($opcion,$SYSusuario_nivel_id);
 		} else
 			$tabla = "tomo_cargos";
		$sql="SELECT id_tomo_cargo, id_cargo, cod_cargo, id_tipo_titulo, cod_tipo_titulo, tipo, id_tipo_clasificacion, ";
		$sql.="ca.denominacion 'denomcar', t.denominacion 'denomclas', t.codigo 'cod_tipo_clasificacion', cod_nivel, nivel, 'A' as origen ";
		$sql.="FROM $tabla ";
		$sql.="INNER JOIN cargos ca USING(id_cargo) ";		
		$sql.="INNER JOIN tipos_titulos USING(id_tipo_titulo) ";
		$sql.="INNER JOIN tipos_clasificacion t USING(id_tipo_clasificacion) ";
		$sql.="INNER JOIN niveles USING(id_nivel) ";
		$sql.="WHERE id_titulo = '".$_REQUEST['id_titulo']."' ";
		
		if ($_REQUEST['status'] == "sorted") {	
			$field = str_replace('@', '', $_REQUEST['field']);
			$order = $_REQUEST['order'];
			$sql.="ORDER BY $field $order";
		}
		
		$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);	
		$data = array();
		while ($row = mysqli_fetch_array($result)) {		
			$data[] = array(utf8_decode($row['denomcar']),utf8_decode($row['nivel']),utf8_decode($row['denomclas']),$row['tipo']);	
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

$sql="SELECT id_titulo, t.codigo, t.denominacion 'nombre', id_grado_titulo, id_institucion, norma_creacion, disciplina_unica, id_nivel_otorga, i.denominacion, descripcion 'nivel', anios_duracion, ";
$sql.="carga_horaria, requisitos_ingreso, modalidad_cursado, especifico ";
$sql.="FROM titulos t ";		
$sql.="LEFT JOIN instituciones i USING(id_institucion) ";		
$sql.="LEFT JOIN nivel_otorga USING(id_nivel_otorga) ";
$sql.="WHERE id_titulo = '".$_REQUEST['id_titulo']."'";		
		
$result = mysqli_query($GLOBALS["___mysqli_ston"], $sql);
$row = mysqli_fetch_array($result);

$nombre = $row['nombre'];
$denominacion = $row['denominacion'];
$codigo = $row['codigo'];

$pdf = new PDF();
$pdf->nombre = $nombre;
$pdf->denominacion = $denominacion;
$pdf->codigo = $codigo;
$pdf->AliasNbPages();
// Títulos de las columnas
$header = array('CARGO', 'NIVEL', 'TIPO CLASIF.', 'TIPO TITULO');
// Carga de datos
$data = $pdf->LoadData();
$pdf->SetFont('Arial','',10);
$pdf->SetTableHeader($header);
$pdf->AddPage();
$pdf->SetWidths(array(100,20,35,35));
$pdf->PrintTableHeader();
$pdf->ImprovedTable($header,$data);
$pdf->Output();
?>