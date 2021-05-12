DROP TABLE IF EXISTS `moneywash1`;
CREATE TABLE `moneywash1`(
    `Numero` int(11) NOT NULL AUTO_INCREMENT,
    `ìd` varchar(20) NOT NULL,
    `amount` int(20) NOT NULL,
    `time` time NOT NULL,
    `ostime` int(50) NOT NULL,
    PRIMARY KEY (`Numero`)
);