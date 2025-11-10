import java.io.*;
public class Student implements Serializable {
  private String name;
  private int year;
  private double gpa;
  public Student() {}
  public Student (String nameIn, int yr, double gpaIn) {
    name = nameIn;
    year = yr;
    gpa = gpaIn;
  }

  public void writeToFile(FileOutputStream outStream)
                                     throws IOException{
    ObjectOutputStream ooStream = new ObjectOutputStream(outStream);
    ooStream.writeObject(this);
    ooStream.flush();
  } // writeToFile()
  
  public void readFromFile(FileInputStream inStream)
           throws IOException, ClassNotFoundException {
    ObjectInputStream oiStream = new ObjectInputStream(inStream);
    Student s = (Student)oiStream.readObject();
    this.name = s.name;
    this.year = s.year;
    this.gpa = s.gpa;
  } // readFromFile()
  
  public String toString() {
    return name + "\t" + year + "\t" + gpa;
  }
} // Student

import javax.swing.*;         // Swing components
import java.awt.*;
import java.io.*;
import java.awt.event.*;

public class ObjectIO extends JFrame implements ActionListener{
  private JTextArea display = new JTextArea();
  private JButton read = new JButton("Read From File"),
                  write = new JButton("Write to File");
  private JTextField nameField = new JTextField(10);
  private JLabel prompt = new JLabel("Filename:",JLabel.RIGHT);
  private JPanel commands = new JPanel();

  public ObjectIO () {
    super("ObjectIO Demo");                // Set window title
    read.addActionListener(this);
    write.addActionListener(this);
    commands.setLayout(new GridLayout(2,2,1,1));
    commands.add(prompt);                 // Control panel
    commands.add(nameField);
    commands.add(read);
    commands.add(write);
    display.setLineWrap(true);
    this.getContentPane().setLayout(new BorderLayout () );
    this.getContentPane().add("North",commands);
    this.getContentPane().add( new JScrollPane(display));
    this.getContentPane().add("Center", display);
  } // ObjectIO

  public void actionPerformed(ActionEvent evt) {
    String fileName = nameField.getText();
    if (evt.getSource() == read)
        readRecords(fileName);
    else
        writeRecords(fileName);
  } // actionPerformed()

  private void readRecords(String fileName) {
     try {
       FileInputStream inStream = new FileInputStream(fileName);  // Open a stream
       display.setText("Name\tYear\tGPA\n");
       try {
         while (true) {                   // Infinite loop
           Student student = new Student();    // Create a student instance
           student.readFromFile(inStream);     //  and have it read an object
           display.append(student.toString() +  "\n"); //  and display it
         }
       } catch (IOException e) {     // Until IOException
       }
       inStream.close();                           // Close the stream
     } catch (FileNotFoundException e) {
         display.append("IOERROR: File NOT Found: " + fileName + "\n");
     } catch (IOException e) {
         display.append("IOERROR: " + e.getMessage() + "\n");
     } catch (ClassNotFoundException e) {
         display.append("ERROR: Class NOT found " + e.getMessage() + "\n");
     }
  } // readRecords()

  private void writeRecords(String fileName) {
    try {
      FileOutputStream outStream = new FileOutputStream( fileName );// Open stream
      for (int k = 0; k < 5 ; k++) {               // Generate 5 random objects
        String name = "name" + k;                     // Name
        int year = (int)(2000 + Math.random() * 4);   // Class year
        double gpa = Math.random() * 12;              // GPA
        Student student = new Student(name, year, gpa); // Create the object
        display.append("Output: "+ student.toString() +"\n"); // and display it
        student.writeToFile(outStream) ;    //  and tell it to write data
      } //for
      outStream.close();
    } catch (IOException e) {
       display.append("IOERROR: " + e.getMessage() + "\n");
    }
  } // writeRecords()

  public static void main(String args[]) {
    ObjectIO io = new ObjectIO();
    io.setSize( 400,200);
    io.setVisible(true);
    io.addWindowListener(new WindowAdapter() {
        public void windowClosing(WindowEvent e) {
            System.exit(0);  // Quit the application
            }
    });
  } // main()
} // ObjectIO
