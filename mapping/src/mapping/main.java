package mapping;

import mapping.repository.*;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class main {
    public static void main(String[] args) {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@144.21.67.201:1521/PDBM1INF.631174089.oraclecloud.internal", "AMEDOMEY1I2223", "Amedomey1I222301");
            Statement stmt = connection.createStatement();

            // Mapping des types
            java.util.Map mapOraObjType = connection.getTypeMap();
            mapOraObjType.put((Object)"AMEDOMEY1I2223.BOAT", (Object)Class.forName("mapping.repository.Boat"));
            mapOraObjType.put((Object)"AMEDOMEY1I2223.CATEGORY", (Object)Class.forName("mapping.repository.Category"));
            mapOraObjType.put((Object)"AMEDOMEY1I2223.RESERVATION", (Object)Class.forName("mapping.repository.Reservation"));
            mapOraObjType.put((Object)"AMEDOMEY1I2223.PILOT", (Object)Class.forName("mapping.repository.Pilot"));
            mapOraObjType.put((Object)"AMEDOMEY1I2223.CUSTOMER", (Object)Class.forName("mapping.repository.Customer"));
            mapOraObjType.put((Object)"AMEDOMEY1I2223.PERSON", (Object)Class.forName("mapping.repository.Person"));

            // Find all sur tous les types
            ResultSet resultsetTableau = stmt.executeQuery(Boat.findAll());
            System.out.println("***************************INFOS Bateaux***************************************");
            while (resultsetTableau.next()) {
                Boat dept = (Boat) resultsetTableau.getObject(1, mapOraObjType);
                dept.display();
            }

            resultsetTableau = stmt.executeQuery(Category.findAll());
            System.out.println("***************************INFOS Categories***************************************");
            while (resultsetTableau.next()) {
                Category employe = (Category) resultsetTableau.getObject(1, mapOraObjType);
                employe.display();
            }

            resultsetTableau = stmt.executeQuery(Customer.findAll());
            System.out.println("***************************INFOS Categories***************************************");
            while (resultsetTableau.next()) {
                Customer employe = (Customer) resultsetTableau.getObject(1, mapOraObjType);
                employe.display();
            }

            resultsetTableau = stmt.executeQuery(Pilot.findAll());
            System.out.println("***************************INFOS Categories***************************************");
            while (resultsetTableau.next()) {
                Pilot employe = (Pilot) resultsetTableau.getObject(1, mapOraObjType);
                employe.display();
            }

            resultsetTableau = stmt.executeQuery(Reservation.findAll());
            System.out.println("***************************INFOS Categories***************************************");
            while (resultsetTableau.next()) {
                Reservation employe = (Reservation) resultsetTableau.getObject(1, mapOraObjType);
                employe.display();
            }
        } catch (Exception e){
            System.out.println("Echec du mapping");
            e.printStackTrace();
        }
    }
}
