﻿namespace TestSigCapt
{
    partial class TestSigCapt
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
 
        private void InitializeComponent()
        {
            this.sigImage = new System.Windows.Forms.PictureBox();
            this.btnSign = new System.Windows.Forms.Button();
            this.txtDisplay = new System.Windows.Forms.TextBox();
            this.btnExit = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.sigImage)).BeginInit();
            this.SuspendLayout();
            // 
            // sigImage
            // 
            this.sigImage.BackColor = System.Drawing.SystemColors.ControlLightLight;
            this.sigImage.Location = new System.Drawing.Point(26, 24);
            this.sigImage.Name = "sigImage";
            this.sigImage.Size = new System.Drawing.Size(240, 164);
            this.sigImage.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.sigImage.TabIndex = 0;
            this.sigImage.TabStop = false;
            // 
            // btnSign
            // 
            this.btnSign.Location = new System.Drawing.Point(297, 24);
            this.btnSign.Name = "btnSign";
            this.btnSign.Size = new System.Drawing.Size(94, 44);
            this.btnSign.TabIndex = 1;
            this.btnSign.Text = "Sign";
            this.btnSign.UseVisualStyleBackColor = true;
            this.btnSign.Click += new System.EventHandler(this.btnSign_Click);
            // 
            // txtDisplay
            // 
            this.txtDisplay.Location = new System.Drawing.Point(26, 194);
            this.txtDisplay.Multiline = true;
            this.txtDisplay.Name = "txtDisplay";
            this.txtDisplay.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.txtDisplay.Size = new System.Drawing.Size(496, 268);
            this.txtDisplay.TabIndex = 2;
            // 
            // btnExit
            // 
            this.btnExit.Location = new System.Drawing.Point(297, 144);
            this.btnExit.Name = "btnExit";
            this.btnExit.Size = new System.Drawing.Size(94, 44);
            this.btnExit.TabIndex = 3;
            this.btnExit.Text = "Exit";
            this.btnExit.UseVisualStyleBackColor = true;
            this.btnExit.Click += new System.EventHandler(this.btnExit_Click);
            // 
            // TestSigCapt
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(547, 474);
            this.Controls.Add(this.btnExit);
            this.Controls.Add(this.txtDisplay);
            this.Controls.Add(this.btnSign);
            this.Controls.Add(this.sigImage);
            this.Name = "TestSigCapt";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "TestSigCapt";
            ((System.ComponentModel.ISupportInitialize)(this.sigImage)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.PictureBox sigImage;
        private System.Windows.Forms.Button btnSign;
        private System.Windows.Forms.TextBox txtDisplay;
        private System.Windows.Forms.Button btnExit;
    }
}

