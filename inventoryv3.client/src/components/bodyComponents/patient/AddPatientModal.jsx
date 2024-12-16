import React, { Component } from 'react';
import { Dialog, DialogActions, DialogContent, DialogTitle, Button, TextField } from '@mui/material';

export default class AddPatientModal extends Component {
  constructor(props) {
    super(props);
    this.state = {
      id: this.props.editingPatient ? this.props.editingPatient.id : '',
      firstName: this.props.editingPatient ? this.props.editingPatient.firstName : '',
      lastName: this.props.editingPatient ? this.props.editingPatient.lastName : '',
      dob: this.props.editingPatient ? this.props.editingPatient.dob : '',
      email: this.props.editingPatient ? this.props.editingPatient.email : '',
      mobile: this.props.editingPatient ? this.props.editingPatient.mobile : '',
    };
  } 

  handleChange = (e) => {
    this.setState({ [e.target.name]: e.target.value });
  };

  handleSubmit = () => {
    const { id, firstName, lastName, dob, email, mobile } = this.state;
    const patient = { id, firstName, lastName, dob, email, mobile };

    if (this.props.editingPatient) {
      this.props.onUpdatePatient(patient); // Update existing patient
    } else {
      this.props.onAddPatient(patient); // Add new patient
    }

    // Reset state after submission
    this.setState({
      id: '',
      firstName: '',
      lastName: '',
      dob: '',
      email: '',
      mobile: '',
    });
  };

  render() {
    const { open, onClose } = this.props;
    const { id, firstName, lastName, dob, email, mobile } = this.state;

    return (
      <Dialog open={open} onClose={onClose}>
        <DialogTitle>{this.props.editingPatient ? 'Update Patient' : 'Add Patient'}</DialogTitle>
        <DialogContent>
          <TextField
            label="Patient ID"
            fullWidth
            value={id}
            name="id"
            onChange={this.handleChange}
            margin="normal"
          />
          <TextField
            label="First Name"
            fullWidth
            value={firstName}
            name="firstName"
            onChange={this.handleChange}
            margin="normal"
          />
          <TextField
            label="Last Name"
            fullWidth
            value={lastName}
            name="lastName"
            onChange={this.handleChange}
            margin="normal"
          />
          <TextField
            label="Date of Birth"
            type="date"
            fullWidth
            value={dob}
            name="dob"
            onChange={this.handleChange}
            InputLabelProps={{
              shrink: true,
            }}
            margin="normal"
          />
          <TextField
            label="Email Address"
            fullWidth
            value={email}
            name="email"
            onChange={this.handleChange}
            margin="normal"
          />
          <TextField
            label="Mobile"
            fullWidth
            value={mobile}
            name="mobile"
            onChange={this.handleChange}
            margin="normal"
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={onClose} color="secondary">
            Cancel
          </Button>
          <Button onClick={this.handleSubmit} color="primary">
            {this.props.editingPatient ? 'Update' : 'Add'}
          </Button>
        </DialogActions>
      </Dialog>
    );
  }
}
