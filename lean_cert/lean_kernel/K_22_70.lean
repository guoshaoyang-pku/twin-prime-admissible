import Sound
import lean_certs.cert_22_70

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H22_gt_70_kernel : ¬ ∃ t : List Nat, admissible 22 t = true ∧ diameter t ≤ 70 := by
  exact certValidRoot_sound (k := 22) (d := 70) (c := cert_22_70) (by decide)
