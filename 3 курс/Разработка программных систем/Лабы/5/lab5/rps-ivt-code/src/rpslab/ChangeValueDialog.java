package rpslab;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowListener;
import java.awt.event.WindowEvent;

public class ChangeValueDialog extends JDialog {

    private JButton exBtn = new JButton("Закрыть");
    private JButton saveBtn = new JButton("Изменить");
    private JTextField pointInput, valueInput;
    private Decomposition dn;

    public ChangeValueDialog(GUI parent, Decomposition dn) {
        super(parent, "Изменить значение в точке", Dialog.ModalityType.DOCUMENT_MODAL);
        this.dn = dn;

        this.setBounds(232, 232, 300, 200);

        getContentPane().add(createGUI());
        pack();

        this.addWindowListener(closeWindow);
        exBtn.addActionListener(new CloseHandler());
        saveBtn.addActionListener(new ChangeHandler());
    }


    private JPanel createGUI() {
        int n = dn.getLen();

        JPanel panel = this.createVerticalPanel();
        panel.setBorder (BorderFactory.createEmptyBorder(12,12,12,12));

        JPanel pointPanel = this.createHorizontalPanel();
		JLabel pointLabel = new JLabel(String.format("Точка [0-%d]:", n-1));
		pointPanel.add(pointLabel);
		pointPanel.add(Box.createHorizontalStrut(12));
		pointInput = new JTextField(15);
		pointPanel.add(pointInput);
        
        JPanel valuePanel = this.createHorizontalPanel();
		JLabel valueLabel = new JLabel("Значение:");
		valuePanel.add(valueLabel);
		valuePanel.add(Box.createHorizontalStrut(12));
		valueInput = new JTextField(15);
		valuePanel.add(valueInput);

        JPanel grid = new JPanel( new GridLayout( 2,1, 0,7) );
        grid.add(saveBtn);
        grid.add(exBtn);


        this.makeSameSize(new JComponent[] { pointLabel, valueLabel } );

        panel.add(pointPanel);
        panel.add(Box.createVerticalStrut(12));
        panel.add(valuePanel);
        panel.add(Box.createVerticalStrut(17));
        panel.add(grid);

        return panel;
    }

	public JPanel createVerticalPanel() {
		JPanel panel = new JPanel();
		panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));
		return panel;
	}

    public JPanel createHorizontalPanel() {
		JPanel panel = new JPanel();
		panel.setLayout(new BoxLayout(panel, BoxLayout.X_AXIS));
		return panel;
	}

    private static WindowListener closeWindow = new WindowAdapter() {
        public void windowClosing(WindowEvent e) {
            e.getWindow().dispose();
        }
    };

    public void makeSameSize(JComponent[] components) {

        int[] array = new int[components.length];
		for (int i = 0; i < array.length; i++) {
			array[i] = components[i].getPreferredSize().width;
		}

        int maxSizePos = maximumElementPosition(array);
		Dimension maxSize = components[maxSizePos].getPreferredSize();
		for (int i=0; i<components.length; i++) {
			components[i].setPreferredSize(maxSize);
			components[i].setMinimumSize(maxSize);
			components[i].setMaximumSize(maxSize);
		}
	}

    private int maximumElementPosition(int[] array) {
		int maxPos = 0;
		for (int i = 1; i < array.length; i++) {
			if (array[i] > array [maxPos])
				maxPos = i;
		}
		return maxPos;
	}


    class CloseHandler implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            dispose();
        }
    }

    class ChangeHandler implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            int point = 0;

            try {
                point = Integer.parseInt(pointInput.getText());
            } catch (NumberFormatException ex) {
                JOptionPane.showMessageDialog(null, "Точка указана неверно");
                return;
            }

            int n = dn.getLen();
            if (point < 0 || point > n-1) {
                JOptionPane.showMessageDialog(null, "Точка указана неверно");
                return;
            }

            double val = 0.0;
            try {
                val = Double.parseDouble(valueInput.getText());
            } catch (NumberFormatException ex) {
                JOptionPane.showMessageDialog(null, "Значение указано неверно");
                return;
            }


            long max_value = dn.getMaxValue();
                
            if (val > max_value) {
                JOptionPane.showMessageDialog(null, String.format("Максимальное значение элемента: {%s}", max_value));
                return;
            }
            
            if (val < -max_value) {
                JOptionPane.showMessageDialog(null, String.format("Минимальное значение элемента: {%s}", -max_value));
                return;
            }


            try {
                dn.updateValue(point, val);
                JOptionPane.showMessageDialog(null, "Значение изменено");
            } catch (DecompositionException exc) {
                JOptionPane.showMessageDialog(null, exc.getMessage());
            }
        }
    }
}
