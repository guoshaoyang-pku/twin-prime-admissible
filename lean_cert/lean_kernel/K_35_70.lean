import Sound
import lean_certs.cert_35_70

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_70_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 70 := by
  exact certValidRoot_sound (k := 35) (d := 70) (c := cert_35_70) (by decide)
