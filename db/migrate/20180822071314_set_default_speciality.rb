class SetDefaultSpeciality < ActiveRecord::Migration[5.0]
  def change
	  User.temps.update_all(speciality: "Generalist")
	  StaffingRequest.update_all(speciality: "Generalist")
	  CareHome.update_all(manual_assignment_flag: false)
	  StaffingRequest.update_all(manual_assignment_flag: false)
  end
end
