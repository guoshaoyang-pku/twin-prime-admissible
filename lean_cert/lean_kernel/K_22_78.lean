import Sound
import lean_certs.cert_22_78

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H22_gt_78_kernel : ¬ ∃ t : List Nat, admissible 22 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 22) (d := 78) (c := cert_22_78) (by decide)
