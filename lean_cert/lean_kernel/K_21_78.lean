import Sound
import lean_certs.cert_21_78

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H21_gt_78_kernel : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 21) (d := 78) (c := cert_21_78) (by decide)
