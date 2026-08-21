import Sound
import lean_certs.cert_23_78

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H23_gt_78_kernel : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 23) (d := 78) (c := cert_23_78) (by decide)
