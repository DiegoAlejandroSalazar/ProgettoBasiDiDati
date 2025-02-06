-- MySQL Script generated by MySQL Workbench
-- Wed Feb  5 16:39:23 2025
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

-- -----------------------------------------------------
-- Schema Farmaciadb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Farmaciadb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Farmaciadb` DEFAULT CHARACTER SET utf8 ;
USE `Farmaciadb` ;

-- -----------------------------------------------------
-- Table `Farmaciadb`.`TesseraSanitaria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmaciadb`.`TesseraSanitaria` (
  `CodiceFiscale` VARCHAR(16) NOT NULL,
  `Cognome` VARCHAR(45) NULL,
  `Nome` VARCHAR(45) NULL,
  `DataScadenza` DATE NULL,
  `DataEmissione` DATE NULL,
  `DataNascita` DATE NULL,
  `NumeroDocumento` VARCHAR(20) NULL,
  PRIMARY KEY (`CodiceFiscale`))	
  ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `Farmaciadb`.`Cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmaciadb`.`Cliente` (
  `CodiceTessera` INT NOT NULL,
  `SaldoPunti` INT NULL,
  `Cellulare` VARCHAR(20) NULL,
  `Consenso` boolean NULL,
  `CodiceFiscale` VARCHAR(16) NOT NULL,
  `Email` VARCHAR(45) NULL,
  `Via` VARCHAR(100) NULL,
  `NumeroCivico` VARCHAR(10) NULL,
  `Città` VARCHAR(45) NULL,
  `CAP` VARCHAR(10) NULL,
  PRIMARY KEY (`CodiceTessera`),
  CONSTRAINT `CodiceTessera`
  FOREIGN KEY (`CodiceFiscale`)
	REFERENCES `Farmaciadb`.`TesseraSanitaria` (`CodiceFiscale`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
	ENGINE = InnoDB
	DEFAULT CHARACTER SET utf8;
    
CREATE TABLE IF NOT EXISTS `Farmaciadb`.`RicettaMedica` (
  `CodiceRicetta` VARCHAR(45) NOT NULL,
  `DataScadenza` DATE NULL,
  `DataEmissione` DATE NULL,
  `CodiceMedicoDibase` VARCHAR(45) NULL,
  `CodiceFiscale` VARCHAR(16) NULL,
  PRIMARY KEY (`CodiceRicetta`),
  -- INDEX `CodiceFiscale_idx` (`CodiceFiscale` ASC) VISIBLE,
  CONSTRAINT `CodiceFiscale`
  FOREIGN KEY (`CodiceFiscale`)
  REFERENCES `Farmaciadb`.`TesseraSanitaria` (`CodiceFiscale`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION
    )
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Farmaciadb`.`Farmaco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmaciadb`.`Farmaco` (
  `AIC` VARCHAR(50) NOT NULL,
  `Nome` VARCHAR(45) NULL,
  `PrincipioAttivo` VARCHAR(45) NULL,
  `PrezzoUnitario` DECIMAL(10,2) NULL,
  `Dosaggio` VARCHAR(45) NULL,
  `FormaFarmaceutica` VARCHAR(45) NULL,
  `Prescrizione` boolean NULL,
  PRIMARY KEY (`AIC`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Farmaciadb`.`Prescrizione`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmaciadb`.`Prescrizione` (
  `CodiceRicetta` VARCHAR(45) NOT NULL,
  `Farmaco` VARCHAR(45) NOT NULL,
  `QuantitàTotale` INT NULL,
  `QuantitàRimanente` INT NULL,
  PRIMARY KEY (`CodiceRicetta`, `Farmaco`),
  INDEX `Farmaco_idx` (`Farmaco` ASC) VISIBLE,
  CONSTRAINT `CodiceRicetta`
    FOREIGN KEY (`CodiceRicetta`)
    REFERENCES `Farmaciadb`.`RicettaMedica` (`CodiceRicetta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Farmaco`
    FOREIGN KEY (`Farmaco`)
    REFERENCES `Farmaciadb`.`Farmaco` (`AIC`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Farmaciadb`.`Allergene`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmaciadb`.`Allergene` (
  `Nome` VARCHAR(45) NOT NULL,
  `Descrizione` LONGTEXT NULL,
  PRIMARY KEY (`Nome`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Farmaciadb`.`Presenza`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmaciadb`.`Presenza` (
  `Farmaco` VARCHAR(45) NOT NULL,
  `Allergene` VARCHAR(45) NOT NULL,
  `InfoAggiuntive` LONGTEXT NULL,
  PRIMARY KEY (`Farmaco`, `Allergene`),
  CONSTRAINT `PFarmaco`
    FOREIGN KEY (`Farmaco`)
    REFERENCES `Farmaciadb`.`Farmaco` (`AIC`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Allergene`
    FOREIGN KEY (`Allergene`)
    REFERENCES `Farmaciadb`.`Allergene` (`Nome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Farmaciadb`.`Lotto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmaciadb`.`Lotto` (
  `CodiceLotto` VARCHAR(45) NOT NULL,
  `Farmaco` VARCHAR(45) NULL UNIQUE,
  `QuantitàDisponibile` INT NULL,
  PRIMARY KEY (`CodiceLotto`),
  INDEX `Farmaco_idx` (`Farmaco` ASC) VISIBLE,
  CONSTRAINT `FKFarmaco`
    FOREIGN KEY (`Farmaco`)
    REFERENCES `Farmaciadb`.`Farmaco` (`AIC`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Farmaciadb`.`Cassa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmaciadb`.`Cassa` (
  `IdCassa` INT NOT NULL,
  `ContanteDisponibile` DECIMAL(10,2) NULL,
  PRIMARY KEY (`IdCassa`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Farmaciadb`.`Vendita`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmaciadb`.`Vendita` (
  `IdVendita` INT NOT NULL UNIQUE,
  `DataVendita` DATE NOT NULL UNIQUE,
  `OraVendita` TIME NULL,
  `MetodoDiPagamento` VARCHAR(45) NULL,
  `IdCassa` INT NULL,
  PRIMARY KEY (`IdVendita`, `DataVendita`),
  CONSTRAINT `IdCassa`
    FOREIGN KEY (`IdCassa`)
    REFERENCES `Farmaciadb`.`Cassa` (`IdCassa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Farmaciadb`.`Ruolo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmaciadb`.`Ruolo` (
  `NomeQualifica` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`NomeQualifica`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Farmaciadb`.`Dipendente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmaciadb`.`Dipendente` (
  `CodiceFiscale` VARCHAR(16) NOT NULL,
  `DataNascita` DATE NULL,
  `Cognome` VARCHAR(45) NULL,
  `Nome` VARCHAR(45) NULL,
  `DataAssunzione` DATE NULL,
  `DataScadenzaContratto` DATE NULL,
  `DataIncarico` DATE NULL,
  `Ruolo` VARCHAR(45) NULL,
  PRIMARY KEY (`CodiceFiscale`),
  INDEX `Ruolo_idx` (`Ruolo` ASC) VISIBLE, -- non so che fa 
  CONSTRAINT `Ruolo`
    FOREIGN KEY (`Ruolo`)
    REFERENCES `Farmaciadb`.`Ruolo` (`NomeQualifica`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Farmaciadb`.`TurnoLavorativo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmaciadb`.`TurnoLavorativo` (
  `Dipendente` VARCHAR(16) NOT NULL,
  `Data` DATE NOT NULL,
  `OraInizio` TIME NULL,
  `OraFine` TIME NULL,
  PRIMARY KEY (`Dipendente`, `Data`),
  CONSTRAINT `Dipendente`
    FOREIGN KEY (`Dipendente`)
    REFERENCES `Farmaciadb`.`Dipendente` (`CodiceFiscale`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Farmaciadb`.`TurnoCassa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmaciadb`.`TurnoCassa` (
  `Dipendente` VARCHAR(16) NOT NULL,
  `Data` DATE NOT NULL,
  `OraInizio` TIME NOT NULL,
  `OraFine` TIME NULL,
  PRIMARY KEY (`Dipendente`, `Data`, `OraInizio`),
  CONSTRAINT `TDipendente`
    FOREIGN KEY (`Dipendente`)
    REFERENCES `Farmaciadb`.`Dipendente` (`CodiceFiscale`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Farmaciadb`.`Fornitore`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmaciadb`.`Fornitore` (
  `PIva` VARCHAR(45) NOT NULL,
  `NomeAzienda` VARCHAR(100) NULL,
  `CelluraleTelefonoFisso` VARCHAR(20) NULL,
  `Via` VARCHAR(100) NULL,
  `NumeroCivico` VARCHAR(10) NULL,
  `Cap` VARCHAR(10) NULL,
  PRIMARY KEY (`PIva`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Farmaciadb`.`Ordine`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmaciadb`.`Ordine` (
  `CodiceOrdine` VARCHAR(45) NOT NULL,
  `DataConsegnaEffettiva` DATE NULL,
  `DataConsegnaPrevista` DATE NULL,
  `StatoOrdine` VARCHAR(45) NULL,
  `DataEmissione` DATE NULL,
  `Fornitore` VARCHAR(45) NULL,
  PRIMARY KEY (`CodiceOrdine`),
  INDEX `Fornitore_idx` (`Fornitore` ASC) VISIBLE,
  CONSTRAINT `Fornitore`
    FOREIGN KEY (`Fornitore`)
    REFERENCES `Farmaciadb`.`Fornitore` (`PIva`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Farmaciadb`.`Acquisto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmaciadb`.`Acquisto` (
  `Vendita` INT NOT NULL,
  `Data` DATE NOT NULL,
  `Ricetta` VARCHAR(45) NULL,
  `Lotto` VARCHAR(45) NOT NULL,
  `Farmaco` VARCHAR(45) NOT NULL,
  `NumeroDiSerie` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Vendita`, `Data`, `Lotto`, `Farmaco`, `NumeroDiSerie`),
  INDEX `Ricetta_idx` (`Ricetta` ASC) VISIBLE,
  INDEX `Lotto_idx` (`Lotto` ASC) VISIBLE,
  INDEX `Farmaco_idx` (`Farmaco` ASC) VISIBLE,
  INDEX `Data_idx` (`Data` ASC) VISIBLE,
    CONSTRAINT `FKVendita`
    FOREIGN KEY (`Vendita`)
    REFERENCES `Farmaciadb`.`Vendita` (`IdVendita`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Data`
    FOREIGN KEY (`Data`)
    REFERENCES `Farmaciadb`.`Vendita` (`DataVendita`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Ricetta`
    FOREIGN KEY (`Ricetta`)
    REFERENCES `Farmaciadb`.`RicettaMedica` (`CodiceRicetta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Lotto`
    FOREIGN KEY (`Lotto`)
    REFERENCES `Farmaciadb`.`Lotto` (`CodiceLotto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FKAFarmaco`
    FOREIGN KEY (`Farmaco`)
    REFERENCES `Farmaciadb`.`Lotto` (`Farmaco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Farmaciadb`.`Riferimento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Farmaciadb`.`Riferimento` (
  `Lotto` VARCHAR(45) NOT NULL,
  `Farmaco` VARCHAR(45) NOT NULL,
  `Ordine` VARCHAR(45) NOT NULL,
  `QuantitàOrdinata` VARCHAR(45) NULL,
  PRIMARY KEY (`Lotto`, `Farmaco`, `Ordine`),
  INDEX `Farmaco_idx` (`Farmaco` ASC) VISIBLE,
  INDEX `Ordine_idx` (`Ordine` ASC) VISIBLE,
  CONSTRAINT `FKRLotto`
    FOREIGN KEY (`Lotto`)
    REFERENCES `Farmaciadb`.`Lotto` (`CodiceLotto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FKRFarmaco`
    FOREIGN KEY (`Farmaco`)
    REFERENCES `Farmaciadb`.`Lotto` (`Farmaco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Ordine`
    FOREIGN KEY (`Ordine`)
    REFERENCES `Farmaciadb`.`Ordine` (`CodiceOrdine`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


