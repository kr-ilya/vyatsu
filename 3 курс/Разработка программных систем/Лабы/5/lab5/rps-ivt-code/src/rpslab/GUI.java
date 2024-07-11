package rpslab;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class GUI extends JFrame {
    private JButton openChangeValueDlgBtn = new JButton("Изниметь значение в точке");
    private JButton openChangeValuesBtn = new JButton("Изменить значения на интервале");
    private JButton sumValuesBtn = new JButton("Сумма значений на интервале");
    private JButton exitBtn = new JButton("Выход");

    private ChangeValueDialog changeValDlg;
    private ChangeValuesDialog changeValsDlg;
    private GetSumDialog sumDlg;

    public GUI(Decomposition dn) {
        super("Lab");
        this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        this.setSize(300, 200);

        this.setResizable(false);
        this.getRootPane().setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        this.setLocationRelativeTo(null);

        Container content = this.getContentPane();
        content.setLayout(new GridLayout(4, 1, 10, 10));
        content.add(openChangeValueDlgBtn);
        content.add(openChangeValuesBtn);
        content.add(sumValuesBtn);
        content.add(exitBtn);


        changeValDlg = new ChangeValueDialog(this, dn);
        changeValsDlg = new ChangeValuesDialog(this, dn);
        sumDlg = new GetSumDialog(this, dn);

        openChangeValueDlgBtn.addActionListener(new OpenChangeValueDlgHandler());
        openChangeValuesBtn.addActionListener(new OpenChangeValuesDlgHandler());
        sumValuesBtn.addActionListener(new OpenSumValuesDlgHandler());
        exitBtn.addActionListener(new ExitHandler());
    };

    class ExitHandler implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent event) {
            System.exit(0);
        }
    }
    
    class OpenChangeValueDlgHandler implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent event) {
            changeValDlg.setVisible(true);
        }
    }
    
    class OpenChangeValuesDlgHandler implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent event) {
            changeValsDlg.setVisible(true);
        }
    }

    class OpenSumValuesDlgHandler implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent event) {
            sumDlg.setVisible(true);
        }
    }
}
